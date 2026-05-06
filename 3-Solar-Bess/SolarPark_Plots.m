%plotting the v vs i for the solar park
vbase=4160/sqrt(3);
ibase=(1*10^6)/(sqrt(3)*4160);
va_solar=V_RMS.Data(:,1)/vbase;
vb_solar=V_RMS.Data(:,2)/vbase;
vc_solar=V_RMS.Data(:,3)/vbase;

%ia_solar=I_RMS.Data(:,1)/ibase;
ia_solar=I_RMS.Data(:,1)/ibase;
ib_solar=I_RMS.Data(:,2)/ibase;
ic_solar=I_RMS.Data(:,3)/ibase;

figure;
hold on;
plot(va_solar(335:end), ia_solar(335:end), 'r', 'DisplayName', 'Phase A');
%plot(vb_solar, ib_solar, 'g', 'DisplayName', 'Phase B');
%plot(vc_solar, ic_solar, 'b', 'DisplayName', 'Phase C');
xlabel('Voltage (pu)');
ylabel('Current (pu)');
title('Voltage vs Current for Solar Park');
legend show;
hold off;

