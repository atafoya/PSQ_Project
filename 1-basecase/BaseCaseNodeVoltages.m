% Run the simulink model first if we can't find Voltages
if ~exist("V13")
    sim("IEEE13bus_v2019b_Discrete.slx")
end

% take the steady-state values at the last timestep of sim
Vs13=V13(end,:)';
Vsim=reshape(Vs13,3,length(Vs13)/3)'; % Three Phase Steady State Node Voltage of All Nodes
Va=Vsim(:,1);Vb=Vsim(:,2);Vc=Vsim(:,3); % phase voltages (simulated)
load('BenchmarkVoltage');
Vab=BM(:,1);Vbb=BM(:,2);Vcb=BM(:,3); % phase voltages (benchmark)
Powers=RG60_Powers.Data(end,:); % [active reactive]

% preprocess - remove NaN and zero
id1 = find(isnan(Vab));Vab(id1) = [];
id1 = find((Va==0));Va(id1) = [];
id1 = find(isnan(Vbb));Vbb(id1) = [];
id1 = find((Vb==0));Vb(id1) = [];
id1 = find(isnan(Vcb));Vcb(id1) = [];
id2 = find((Vc==0));Vc(id2) = [];

% preprocess - bus 1 has a different Vbase
secprim = 4.16/115
Va(1)=Va(1)*secprim; Vb(1)=Vb(1)*secprim;Vc(1)=Vc(1)*secprim;

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

figure(2);
hold on;
%x = 1900:10:2000;
y=[];
for i=1:12;
    y=[y Va(i)];
end
bar(y,'FaceColor','red');
titletext='Phase A Voltage Per Bus';
title(titletext)
xlabel('Bus')
ylabel('V pu ')
fontsize(16,'point');
saveas(gcf,'1basecase.png')

figure(3);
hold on;
x=[];
for i=1:12;
    x=[x Vb(i)];
end
bar(x,'FaceColor','m');
titletext='Phase B Voltage Per Bus';
title(titletext)
xlabel('Bus')
ylabel('V pu ')
fontsize(16,'point');
saveas(gcf,'1basecase.png')

figure(4);
hold on;
z=[];
for i=1:12;
    z=[z Vc(i)];
end
bar(z,'FaceColor','c');
titletext='Phase C Voltage Per Bus';
title(titletext)
xlabel('Bus')
ylabel('V pu ')
fontsize(16,'point');
saveas(gcf,'1basecase.png')

