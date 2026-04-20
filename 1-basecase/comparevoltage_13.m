% Run the simulink model first if we can't find Voltages
if ~exist("V13")
    sim("IEEE13bus_v2019b_Discrete.slx")
end

% take the steady-state values at the last timestep of sim
Vs13=V13(end,:)';
Vsim=reshape(Vs13,3,length(Vs13)/3)'; % Three Phase Steady State Node Voltage of All Nodes
Va=Vsim(:,1);Vb=Vsim(:,2);Vc=Vsim(:,3); % phase voltages (simulated)
% load('BenchmarkVoltage');
% Vab=BM(:,1);Vbb=BM(:,2);Vcb=BM(:,3); % phase voltages (benchmark)
Powers=RG60_Powers.Data(end,:); % [active reactive]

% preprocess - remove NaN and zero
id1 = find(isnan(Vab));Vab(id1) = [];
id1 = find((Va==0));Va(id1) = [];
id1 = find(isnan(Vbb));Vbb(id1) = [];
id1 = find((Vb==0));Vb(id1) = [];
id1 = find(isnan(Vcb));Vcb(id1) = [];
id2 = find((Vc==0));Vc(id2) = [];

% plot phase voltages
figure(1);
hold on;
plot(Va,'k','Linewidth',2);
plot(Vb,'r','Linewidth',2);
plot(Vc,'b','Linewidth',2);
yline([0.95,1.05],'Color','#888888')
titletext='Phase Voltages - Base Case Power at PCC: '+string(round(Powers(1),2))+' kW + '+string(round(Powers(2),2))+' kvar'
title(titletext)
legend('Phase A','Phase B','Phase C')
xlabel('Bus')
ylabel('V pu ')
fontsize(16,'point');
saveas(gcf,'1basecase.png')
