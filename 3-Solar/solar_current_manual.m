
function v=interleave(v1,v2)
    % interleave: https://www.mathworks.com/matlabcentral/answers/476044-interleaving-vectors-in-matlab
    v = [(v2)';(v1(2:end))'];
    v = [v1(1);v(:)];
end

phi=-40; % angle to make solar plant close to unity power factor

timesteps = (0:10:60)'; % simulate each of 5 scenarios for 10 seconds
ramptime = 1e-2;
timesteps_p1 = timesteps(2:end)-ramptime;
timesteps_combined = interleave(timesteps,timesteps_p1)
solar_current.time = timesteps_combined;

I_ph = 1e6/sqrt(3)/4.16e3; % phase current to make 1MVA solar
I_steps = [1; .8; .6; .4; .2; 0; 0];
I_steps = interleave(I_steps,I_steps(1:end-1))

solar_current.signals.values = I_ph*I_steps;
solar_GHI.signals.dimensions = 1;

% plot should show 5 different steps
plot(timesteps_combined, I_steps, LineStyle='-', Marker='o')