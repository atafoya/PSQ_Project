% =========================================================
%  Solar Irradiance -> Simulink Current Source (Discrete Time-Domain)
%  Reads: Month, Day, Hour, Minute, Temperature, GHI, DHI, DNI from CSV
%  Trims to daytime only — sunrise to sunset
%  Envelope as timeseries — Sine Wave generated inside Simulink
% =========================================================
%
% IMPORTANT: powergui block must be set to "Discrete" with sample time 5e-5
%
% Simulink layout per phase:
%   From Workspace (solar_envelope) -> Product -> Simulink-PS Converter -> S port
%                                         ^
%                                  Sine Wave block (5e-5 sample time)
%
% Sine Wave block phase settings:
%   Phase A: deg2rad(-40)
%   Phase B: deg2rad(-160)
%   Phase C: deg2rad(100)

%% 1. Load CSV file
filename   = 'Solar Irradiance.csv';
SolarTable = readtable(filename);

%% 2. Preview to confirm column names
disp(head(SolarTable));
disp(SolarTable.Properties.VariableNames);

%% 3. Extract first full day (144 samples = 24 hours x 6 per hour at 10-min intervals)
samples_per_day = 144;
SolarTable = SolarTable(1:samples_per_day, :);

%% 4. Trim to daytime only (sunrise to sunset)
GHI_full = SolarTable.GHI;
GHI_full(isnan(GHI_full) | GHI_full < 0) = 0;

sunrise_idx = find(GHI_full > 0, 1, 'first');
sunset_idx  = find(GHI_full > 0, 1, 'last');

% Pad one sample on each side so we start/end at zero
sunrise_idx = max(sunrise_idx - 1, 1);
sunset_idx  = min(sunset_idx + 1, samples_per_day);

SolarTable     = SolarTable(sunrise_idx:sunset_idx, :);
n_daytime      = height(SolarTable);
daytime_hours  = (sunrise_idx - 1) / 6;
daytime_length = (n_daytime - 1) / 6;

fprintf('Sunrise at hour %.1f, sunset at hour %.1f\n', ...
    daytime_hours, daytime_hours + daytime_length);
fprintf('Daylight duration: %.1f hours, %d samples\n', ...
    daytime_length, n_daytime);

%% 5. Build compressed simulation timestamps snapped to fixed-step grid
fixed_step           = 5e-5;
sim_seconds_per_hour = 10;
total_sim_time       = daytime_length * sim_seconds_per_hour;

dt_raw    = total_sim_time / (n_daytime - 1);
dt_sim    = round(dt_raw / fixed_step) * fixed_step;
stop_time = (n_daytime - 1) * dt_sim;
t_seconds = (0 : n_daytime - 1)' * dt_sim;

assignin('base', 'dt_sim', dt_sim);

fprintf('Fixed step:  %.5f s\n', fixed_step);
fprintf('dt_sim:      %.4f s\n', dt_sim);
fprintf('Stop time:   %.4f s\n', stop_time);

%% 6. Extract irradiance and temperature columns
GHI         = SolarTable.GHI;
DHI         = SolarTable.DHI;
DNI         = SolarTable.DNI;
Temperature = SolarTable.Temperature;

%% 7. Clean data — replace NaN/negatives with 0
GHI(isnan(GHI) | GHI < 0) = 0;
DHI(isnan(DHI) | DHI < 0) = 0;
DNI(isnan(DNI) | DNI < 0) = 0;

%% 8. Scale GHI to photocurrent envelope (A)
G_ref   = 1000;                     % W/m^2 reference irradiance (STC)
I_sc    = 8.5;                      % Short-circuit current at STC (A)
I_photo = (GHI / G_ref) * I_sc;    % photocurrent envelope vector

%% 9. Build envelope as timeseries (clean format for From Workspace)
scale = 138.8;
I_mag = scale * I_photo;

solar_envelope      = timeseries(I_mag, t_seconds);
solar_envelope.Name = 'solar_envelope';

assignin('base', 'solar_envelope', solar_envelope);
assignin('base', 'I_mag',          I_mag);

%% 10. Keep solar_current struct for backwards compatibility
solar_current.time               = t_seconds;
solar_current.signals.values     = I_photo;
solar_current.signals.dimensions = 1;

solar_GHI.time               = t_seconds;
solar_GHI.signals.values     = GHI;
solar_GHI.signals.dimensions = 1;

assignin('base', 'solar_current', solar_current);
assignin('base', 'solar_GHI',     solar_GHI);

%% 11. Set Simulink stop time automatically
set_param(bdroot, 'StopTime', num2str(stop_time));

%% 12. Sanity checks
fprintf('Samples:            %d\n',     n_daytime);
fprintf('Sim duration:       %.4f s\n', stop_time);
fprintf('Max envelope:       %.2f A\n', max(I_mag));
fprintf('NaN in envelope:    %d\n',     sum(isnan(I_mag)));
fprintf('Inf in envelope:    %d\n',     sum(isinf(I_mag)));

%% 13. Sanity plot
figure;
yyaxis left;
plot(t_seconds, GHI, 'Color', [0.94 0.63 0.15], 'LineWidth', 1.5);
ylabel('GHI (W/m^2)');

yyaxis right;
plot(t_seconds, I_mag, 'Color', [0.22 0.54 0.87], 'LineWidth', 1.5);
ylabel('Photocurrent Envelope (A)');

xlabel('Simulation Time (s)');
title(sprintf('Daytime Only — Sunrise hour %.1f to Sunset hour %.1f', ...
    daytime_hours, daytime_hours + daytime_length));
legend('GHI', 'I_{envelope}');
grid on;