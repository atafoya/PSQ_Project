% https://claude.ai/share/6da1f4c2-ef45-428a-940c-0c98cc210244

% --- Parameters ---
peak_GHI   = 1000;   % W/m^2 (summer clear sky)
sunrise    = 5.5;    % hours (5:30 AM)
sunset     = 19.5;   % hours (7:30 PM)
cloud_frac = 0.3;    % 0 = clear, 1 = overcast

% --- Time vector ---
t = 0 : 0.5 : 24;   % half-hourly steps

% --- Clear sky GHI (sine curve) ---
GHI_clear = zeros(size(t));
daylight   = sunset - sunrise;

for i = 1:length(t)
    if t(i) > sunrise && t(i) < sunset
        angle        = pi * (t(i) - sunrise) / daylight;
        GHI_clear(i) = peak_GHI * sin(angle);
    end
end

% --- Cloud attenuation ---
GHI_cloudy = GHI_clear .* (1 - cloud_frac * 0.75);

% --- Daily energy (trapezoidal integration) ---
energy_clear  = trapz(t, GHI_clear)  / 1000;  % kWh/m^2
energy_cloudy = trapz(t, GHI_cloudy) / 1000;

fprintf('Clear sky energy:  %.2f kWh/m^2\n', energy_clear);
fprintf('Cloudy energy:     %.2f kWh/m^2\n', energy_cloudy);
fprintf('Cloud loss:        %.1f%%\n', (1 - energy_cloudy/energy_clear)*100);

% --- Plot ---
figure;
plot(t, GHI_clear,  '--', 'Color', [0.94 0.63 0.15], 'LineWidth', 2); hold on;
plot(t, GHI_cloudy, '-',  'Color', [0.22 0.54 0.87], 'LineWidth', 2);
xlabel('Hour of day');
ylabel('GHI (W/m^2)');
title('Solar Irradiance Model');
legend('Clear sky', 'With clouds');
xlim([0 24]);  ylim([0 1100]);
xticks(0:2:24);
grid on;

%% 

% --- Season lookup table ---
seasons = struct();
seasons(1).name     = 'Winter';
seasons(1).peak_GHI = 500;
seasons(1).daylight = 9;

seasons(2).name     = 'Spring';
seasons(2).peak_GHI = 800;
seasons(2).daylight = 12;

seasons(3).name     = 'Summer';
seasons(3).peak_GHI = 1000;
seasons(3).daylight = 14;

seasons(4).name     = 'Autumn';
seasons(4).peak_GHI = 650;
seasons(4).daylight = 10;

t = 0:0.5:24;
figure; hold on;
colors = [0.22 0.54 0.87;
          0.39 0.78 0.31;
          0.94 0.63 0.15;
          0.82 0.36 0.19];

for s = 1:4
    rise    = 12 - seasons(s).daylight / 2;
    set_    = 12 + seasons(s).daylight / 2;
    GHI     = zeros(size(t));
    for i = 1:length(t)
        if t(i) > rise && t(i) < set_
            GHI(i) = seasons(s).peak_GHI * sin(pi*(t(i)-rise)/seasons(s).daylight);
        end
    end
    plot(t, GHI, 'LineWidth', 2, 'Color', colors(s,:), ...
         'DisplayName', seasons(s).name);
end

xlabel('Hour of day'); ylabel('GHI (W/m^2)');
title('GHI by Season'); legend; grid on; xlim([0 24]);
