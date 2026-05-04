vbase=4160/sqrt(3);
ibase=(400*10^3)/(sqrt(3)*4160);
va100=(V680_100.Data(end,1))/vbase;
vb100=V680_100.Data(end,2)/vbase;
vc100=V680_100.Data(end,3)/vbase;
ia100=I680_100.Data(end,1)/ibase;
ib100=I680_100.Data(end,2)/ibase;
ic100=I680_100.Data(end,3)/ibase;

va50=V680_50.Data(end,1)/vbase;
vb50=V680_50.Data(end,2)/vbase;
vc50=V680_50.Data(end,3)/vbase;
ia50=I680_50.Data(end,1)/ibase;
ib50=I680_50.Data(end,2)/ibase;
ic50=I680_50.Data(end,3)/ibase;

va40=V680_40.Data(end,1)/vbase;
vb40=V680_40.Data(end,2)/vbase;
vc40=V680_40.Data(end,3)/vbase;
ia40=I680_40.Data(end,1)/ibase;
ib40=I680_40.Data(end,2)/ibase;
ic40=I680_40.Data(end,3)/ibase;

va1=V680_1.Data(end,1)/vbase;
vb1=V680_1.Data(end,2)/vbase;
vc1=V680_1.Data(end,3)/vbase;
ia1=I680_1.Data(end,1)/ibase;
ib1=I680_1.Data(end,2)/ibase;
ic1=I680_1.Data(end,3)/ibase;


figure(1);
hold on;
plot(va100, ia100,'o', 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'r', 'LineStyle', 'none');
plot(vb100,ib100,'o', 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'r', 'LineStyle', 'none');
plot(vc100,ic100,'o', 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'r', 'LineStyle', 'none');

plot(va50, ia50,'o', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'b', 'LineStyle', 'none');
plot(vb50,ib50,'o', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'b', 'LineStyle', 'none');
plot(vc50,ic50,'o', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'b', 'LineStyle', 'none');

plot(va40, ia40,'o', 'MarkerFaceColor', '#006400', 'MarkerEdgeColor', '#006400', 'LineStyle', 'none');
plot(vb40,ib40,'o', 'MarkerFaceColor', '#006400', 'MarkerEdgeColor', '#006400', 'LineStyle', 'none');
plot(vc40,ic40,'o', 'MarkerFaceColor', '#006400', 'MarkerEdgeColor', '#006400', 'LineStyle', 'none');

plot(va1, ia1,'o', 'MarkerFaceColor', '#660066', 'MarkerEdgeColor', '#660066', 'LineStyle', 'none');
plot(vb1,ib1,'o', 'MarkerFaceColor', '#660066', 'MarkerEdgeColor', '#660066', 'LineStyle', 'none');
plot(vc1,ic1,'o', 'MarkerFaceColor', '#660066', 'MarkerEdgeColor', '#660066', 'LineStyle', 'none');



titletext='Voltage/Current Per Phase at Node 680 ';
title(titletext)
legend('100% rated load','','','50% rated load','','','40% rated load','','','10% rated load')
xlabel('Voltage rms pu')
ylabel('Current rms pu ')
fontsize(16,'point');
%saveas(gcf,'1basecase.png')