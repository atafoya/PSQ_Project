%plotting the v vs i for the solar park
vbase=4160/sqrt(3);
ibase=(400*10^3)/(sqrt(3)*4160);
va_solar=V_solar.Data(:,1)/(sqrt(2)*vbase);
vb_solar=V_solar.Data(:,2)/(sqrt(2)*vbase);
vc_solar=V_solar.Data(:,3)/(sqrt(2)*vbase);

ia_solar=I_solar.Data(:,1)/(sqrt(2)*ibase);
ib_solar=I_solar.Data(:,2)/(sqrt(2)*ibase);
ic_solar=I_solar.Data(:,3)/(sqrt(2)*ibase);

figure;
hold on;
plot(va_solar, ia_solar, 'r', 'DisplayName', 'Phase A');
%plot(vb_solar, ib_solar, 'g', 'DisplayName', 'Phase B');
%plot(vc_solar, ic_solar, 'b', 'DisplayName', 'Phase C');
xlabel('Voltage (pu)');
ylabel('Current (pu)');
title('Voltage vs Current for Solar Park');
legend show;
hold off;

