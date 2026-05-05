% =========================================================
%  Solar Irradiance -> Simulink Current Source
%  Reads: Month, Day, Hour, Minute, Temperature, GHI, DHI, DNI from CSV
% =========================================================

% https://claude.ai/share/6da1f4c2-ef45-428a-940c-0c98cc210244

% Joseph changed the second tab of 'Solar Irradiance.xlsx' to 'Solar Irradiance.csv'
% https://claude.ai/share/e3cf0538-1ece-46bd-88d4-ed672c6e60bd

%% 1. Load CSV file
filename = 'Solar Irradiance.csv';           % change to your filename
T = readtable(filename);

%% 2. Preview to confirm column names
disp(head(T));                         % check names match below

%% 3. Build timestamps from date/time columns -> elapsed seconds
% Assumes a fixed reference year; change 2024 to match your data if needed
year_ref = 2024;
timestamps = datetime(year_ref, T.Month, T.Day, T.Hour, T.Minute, 0);
t_seconds  = seconds(timestamps - timestamps(1));  % elapsed seconds from t=0

%% 4. Extract irradiance and temperature columns
% Adjust column names to match your file exactly
GHI         = T.GHI;     % W/m^2
DHI         = T.DHI;
DNI         = T.DNI;
Temperature = T.Temperature;   % °C (available for derating if needed)

%% 5. Clean data — replace NaN/negatives with 0
GHI(isnan(GHI) | GHI < 0) = 0;
DHI(isnan(DHI) | DHI < 0) = 0;
DNI(isnan(DNI) | DNI < 0) = 0;

%% 6. Scale GHI to photocurrent (A)
% Iph = (GHI / G_ref) * Isc
% Tune these to your panel's datasheet
G_ref = 1000;    % W/m^2 reference irradiance (STC)
I_sc  = 8.5;     % Short-circuit current at STC (A) — change to your panel

I_photo = (GHI / G_ref) * I_sc;   % photocurrent vector

%% 7. Pack into timeseries for Simulink "From Workspace" block
% Simulink expects a struct with fields .time and .signals.values
solar_current.time               = t_seconds;
solar_current.signals.values     = I_photo;
solar_current.signals.dimensions = 1;

% Also save GHI timeseries if you want to monitor it separately
solar_GHI.time               = t_seconds;
solar_GHI.signals.values     = GHI;
solar_GHI.signals.dimensions = 1;

%% 8. Save to workspace (Simulink reads from base workspace)
assignin('base', 'solar_current', solar_current);
assignin('base', 'solar_GHI',     solar_GHI);

fprintf('Data loaded: %d samples, %.1f hours total\n', ...
    length(t_seconds), t_seconds(end)/3600);

%% 9. Quick sanity plot
figure;
yyaxis left;  plot(t_seconds/3600, GHI, 'Color', [0.94 0.63 0.15], 'LineWidth', 1.5);
ylabel('GHI (W/m^2)');
yyaxis right; plot(t_seconds/3600, I_photo, 'Color', [0.22 0.54 0.87], 'LineWidth', 1.5);
ylabel('Photocurrent (A)');
xlabel('Time (hours)'); title('Irradiance and Scaled Photocurrent');
legend('GHI', 'I_{photo}'); grid on;