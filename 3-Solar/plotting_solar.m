

% % must load the variables to be abel to plot them
% load("workspace_60s.mat")

% t=solar_current.time;
% % select the end of each step to give it time to settle
tmeasures = timesteps_combined(1:2:size(timesteps_combined,1));


Vphbase = 4.16e3/sqrt(3);
Vrmspu_t = V_solar_rms.Data/Vphbase;
Vrmspu = Vrmspu_t(timesteps_combined(1:2:size(timesteps_combined,1)));

Ibase = 1e6/sqrt(3)/4.16e3
Irmspu_t = I_solar_rms.Data/Ibase;
Irmspu = Irmspu_t(timesteps_combined(2:2:size(timesteps_combined,1)));

% yyaxis left;
plot(Irmspu, Vrmspu);
% yyaxis right; plot(t, , label='Solar current', LineStyle='-');
title('Node 671: Solar Park');
