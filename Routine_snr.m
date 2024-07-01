clc
clear
close all
Iter = 1e5;
b = [6 6];
a = equal_distance_square(b).';
SNR_dB = 10:40;
channel = "Nak";
channel_factor = 4;
BER1th_Gray_4 = func_BERth_U1_Gray(b,a,SNR_dB,channel,channel_factor);
BER1th_nonGray_4 = func_BERth_U1_nonGray(b,a,SNR_dB,channel,channel_factor);
BER2th_4 = func_BERth_U2_Gray(b,a,SNR_dB,channel,channel_factor);
SNR_dB = 10:5:40;
BER_Gray_4 = sim_BER_Gray(b,a,SNR_dB,channel,channel_factor,Iter);
BER_nonGray_4 = sim_BER_nonGray(b,a,SNR_dB,channel,channel_factor,Iter);

SNR_dB = 10:40;
channel_factor = 2;
BER1th_Gray_2 = func_BERth_U1_Gray(b,a,SNR_dB,channel,channel_factor);
BER1th_nonGray_2 = func_BERth_U1_nonGray(b,a,SNR_dB,channel,channel_factor);
BER2th_2 = func_BERth_U2_Gray(b,a,SNR_dB,channel,channel_factor);
SNR_dB = 10:5:40;
BER_Gray_2 = sim_BER_Gray(b,a,SNR_dB,channel,channel_factor,Iter);
BER_nonGray_2 = sim_BER_nonGray(b,a,SNR_dB,channel,channel_factor,Iter);

SNR_dB = 10:40;
channel_factor = 1;
BER1th_Gray_1 = func_BERth_U1_Gray(b,a,SNR_dB,channel,channel_factor);
BER1th_nonGray_1 = func_BERth_U1_nonGray(b,a,SNR_dB,channel,channel_factor);
BER2th_1 = func_BERth_U2_Gray(b,a,SNR_dB,channel,channel_factor);
SNR_dB = 10:5:40;
BER_Gray_1 = sim_BER_Gray(b,a,SNR_dB,channel,channel_factor,Iter);
BER_nonGray_1 = sim_BER_nonGray(b,a,SNR_dB,channel,channel_factor,Iter);


%%
SNR_dB = 10:40;
figure
set(gcf, 'Units', 'Inches', 'Position', [0, 0, 4.5, 3.5], 'PaperUnits', 'Inches', 'PaperSize', [4.5, 3.5]);
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(gcf,'color','w');
ax = gca;
t = tiledlayout(1,1,'TileSpacing','compact');
t.Padding = 'tight';
ax1 = axes(t);
semilogy(ax1,NaN,NaN,'--b','linewidth',0.75); hold on
semilogy(ax1,NaN,NaN,'-r','linewidth',0.75); hold on
semilogy(ax1,NaN,NaN,'-.k','linewidth',0.75); hold on
semilogy(ax1,NaN,NaN,'sk','linewidth',0.75); hold on
semilogy(ax1,NaN,NaN,'ok','linewidth',0.75); hold on
semilogy(ax1,SNR_dB,BER1th_Gray_1,'--b','linewidth',0.75); hold on
semilogy(ax1,SNR_dB,BER1th_nonGray_1,'--b','linewidth',0.75); hold on
semilogy(ax1,SNR_dB(1:5:end),BER_Gray_1(1,:),'sb','linewidth',0.75); hold on
semilogy(ax1,SNR_dB(1:5:end),BER_nonGray_1(1,:),'ob','linewidth',0.75); hold on

semilogy(ax1,SNR_dB,BER1th_Gray_2,'-r','linewidth',0.75); hold on
semilogy(ax1,SNR_dB,BER1th_nonGray_2,'-r','linewidth',0.75); hold on
semilogy(ax1,SNR_dB(1:5:end),BER_Gray_2(1,:),'sr','linewidth',0.75); hold on
semilogy(ax1,SNR_dB(1:5:end),BER_nonGray_2(1,:),'or','linewidth',0.75); hold on

semilogy(ax1,SNR_dB,BER1th_Gray_4,'-.k','linewidth',0.75); hold on
semilogy(ax1,SNR_dB,BER1th_nonGray_4,'-.k','linewidth',0.75); hold on
semilogy(ax1,SNR_dB(1:5:end),BER_Gray_4(1,:),'sk','linewidth',0.75); hold on
semilogy(ax1,SNR_dB(1:5:end),BER_nonGray_4(1,:),'ok','linewidth',0.75); hold on

legend('$\textbf{m}=1$','$\textbf{m}=2$','$\textbf{m}=4$','J-Gray','D-Gray',...
       'interpreter','latex',...
       'fontsize',10,'location','northeast')

ax1.XGrid = 'on';
ax1.YGrid = 'on';
ax1.XLim = [min(SNR_dB) max(SNR_dB)];
ax1.YLim = [1E-2 1];
ax1.FontSize = 12;
ax1.LineWidth = 0.75;
% ax1.XAxis.Exponent = -2; 
xlabel(ax1,'Transmit SNR (dB)','interpreter','latex','fontsize',12)
ylabel(ax1,'BER','interpreter','latex','fontsize',12)

%%
SNR_dB = 10:40;
figure
set(gcf, 'Units', 'Inches', 'Position', [0, 0, 4.5, 3.5], 'PaperUnits', 'Inches', 'PaperSize', [4.5, 3.5]);
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(gcf,'color','w');
ax = gca;
t = tiledlayout(1,1,'TileSpacing','compact');
t.Padding = 'tight';
ax1 = axes(t);
semilogy(ax1,NaN,NaN,'--b','linewidth',0.75); hold on
semilogy(ax1,NaN,NaN,'-r','linewidth',0.75); hold on
semilogy(ax1,NaN,NaN,'-.k','linewidth',0.75); hold on
semilogy(ax1,NaN,NaN,'sk','linewidth',0.75); hold on
semilogy(ax1,NaN,NaN,'ok','linewidth',0.75); hold on
semilogy(ax1,SNR_dB,BER2th_1,'--b','linewidth',0.75); hold on
semilogy(ax1,SNR_dB(1:5:end),BER_Gray_1(2,:),'sb','linewidth',0.75); hold on
semilogy(ax1,SNR_dB(1:5:end),BER_nonGray_1(2,:),'ob','linewidth',0.75); hold on

semilogy(ax1,SNR_dB,BER2th_2,'-r','linewidth',0.75); hold on
semilogy(ax1,SNR_dB(1:5:end),BER_Gray_2(2,:),'sr','linewidth',0.75); hold on
semilogy(ax1,SNR_dB(1:5:end),BER_nonGray_2(2,:),'or','linewidth',0.75); hold on

semilogy(ax1,SNR_dB,BER2th_4,'-.k','linewidth',0.75); hold on
semilogy(ax1,SNR_dB(1:5:end),BER_Gray_4(2,:),'sk','linewidth',0.75); hold on
semilogy(ax1,SNR_dB(1:5:end),BER_nonGray_4(2,:),'ok','linewidth',0.75); hold on

legend('$\textbf{m}=1$','$\textbf{m}=2$','$\textbf{m}=4$','J-Gray','D-Gray',...
       'interpreter','latex',...
       'fontsize',10,'location','northeast')

ax1.XGrid = 'on';
ax1.YGrid = 'on';
ax1.XLim = [min(SNR_dB) max(SNR_dB)];
ax1.YLim = [1E-4 1];
ax1.FontSize = 12;
ax1.LineWidth = 0.75;
% ax1.XAxis.Exponent = -2; 
xlabel(ax1,'Transmit SNR (dB)','interpreter','latex','fontsize',12)
ylabel(ax1,'BER','interpreter','latex','fontsize',12)

%%
figure
set(gcf, 'Units', 'Inches', 'Position', [0, 0, 4.5, 3.5], 'PaperUnits', 'Inches', 'PaperSize', [4.5, 3.5]);
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(gcf,'color','w');
ax = gca;
t = tiledlayout(1,1,'TileSpacing','compact');
t.Padding = 'tight';
ax1 = axes(t);
semilogy(ax1,NaN,NaN,'--b','linewidth',0.75); hold on
semilogy(ax1,NaN,NaN,'-r','linewidth',0.75); hold on
semilogy(ax1,NaN,NaN,'sk','linewidth',0.75); hold on
semilogy(ax1,NaN,NaN,'ok','linewidth',0.75); hold on
semilogy(ax1,SNR_dB,BER1th_Gray_2,'--b','linewidth',0.75); hold on
semilogy(ax1,SNR_dB,BER2th_2,'-r','linewidth',0.75); hold on
semilogy(ax1,SNR_dB,BER1th_nonGray_2,'--b','linewidth',0.75); hold on

semilogy(ax1,SNR_dB,BER_Gray_2(1,:),'sb','linewidth',0.75); hold on
semilogy(ax1,SNR_dB,BER_Gray_2(2,:),'sr','linewidth',0.75); hold on
semilogy(ax1,SNR_dB,BER_nonGray_2(1,:),'ob','linewidth',0.75); hold on
semilogy(ax1,SNR_dB,BER_nonGray_2(2,:),'or','linewidth',0.75); hold on
legend('$U_1$','$U_2$','J-Gray','D-Gray',...
       'interpreter','latex',...
       'fontsize',10,'location','northeast')

ax1.XGrid = 'on';
ax1.YGrid = 'on';
ax1.XLim = [min(SNR_dB) max(SNR_dB)];
ax1.YLim = [1E-3 1];
ax1.FontSize = 12;
ax1.LineWidth = 0.75;
% ax1.XAxis.Exponent = -2; 
xlabel(ax1,'Transmit SNR (dB)','interpreter','latex','fontsize',12)
ylabel(ax1,'BER','interpreter','latex','fontsize',12)

%%
figure
set(gcf, 'Units', 'Inches', 'Position', [0, 0, 4.5, 3.5], 'PaperUnits', 'Inches', 'PaperSize', [4.5, 3.5]);
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(gcf,'color','w');
ax = gca;
t = tiledlayout(1,1,'TileSpacing','compact');
t.Padding = 'tight';
ax1 = axes(t);
semilogy(ax1,NaN,NaN,'--b','linewidth',0.75); hold on
semilogy(ax1,NaN,NaN,'-r','linewidth',0.75); hold on
semilogy(ax1,NaN,NaN,'sk','linewidth',0.75); hold on
semilogy(ax1,NaN,NaN,'ok','linewidth',0.75); hold on
semilogy(ax1,SNR_dB,BER1th_Gray_1,'--b','linewidth',0.75); hold on
semilogy(ax1,SNR_dB,BER2th_1,'-r','linewidth',0.75); hold on
semilogy(ax1,SNR_dB,BER1th_nonGray_1,'--b','linewidth',0.75); hold on

semilogy(ax1,SNR_dB,BER_Gray_1(1,:),'sb','linewidth',0.75); hold on
semilogy(ax1,SNR_dB,BER_Gray_1(2,:),'sr','linewidth',0.75); hold on
semilogy(ax1,SNR_dB,BER_nonGray_1(1,:),'ob','linewidth',0.75); hold on
semilogy(ax1,SNR_dB,BER_nonGray_1(2,:),'or','linewidth',0.75); hold on
legend('$U_1$','$U_2$','J-Gray','D-Gray',...
       'interpreter','latex',...
       'fontsize',10,'location','northeast')

ax1.XGrid = 'on';
ax1.YGrid = 'on';
ax1.XLim = [min(SNR_dB) max(SNR_dB)];
ax1.YLim = [1E-3 1];
ax1.FontSize = 12;
ax1.LineWidth = 0.75;
% ax1.XAxis.Exponent = -2; 
xlabel(ax1,'Transmit SNR (dB)','interpreter','latex','fontsize',12)
ylabel(ax1,'BER','interpreter','latex','fontsize',12)

%%
figure
set(gcf, 'Units', 'Inches', 'Position', [0, 0, 4.5, 3.5], 'PaperUnits', 'Inches', 'PaperSize', [4.5, 3.5]);
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(gcf,'color','w');
ax = gca;
t = tiledlayout(1,1,'TileSpacing','compact');
t.Padding = 'tight';
ax1 = axes(t);
semilogy(ax1,NaN,NaN,'--b','linewidth',0.75); hold on
semilogy(ax1,NaN,NaN,'-r','linewidth',0.75); hold on
semilogy(ax1,NaN,NaN,'sk','linewidth',0.75); hold on
semilogy(ax1,NaN,NaN,'ok','linewidth',0.75); hold on
semilogy(ax1,SNR_dB,BER1th_Gray_5,'--b','linewidth',0.75); hold on
semilogy(ax1,SNR_dB,BER2th_5,'-r','linewidth',0.75); hold on
semilogy(ax1,SNR_dB,BER1th_nonGray_5,'--b','linewidth',0.75); hold on

semilogy(ax1,SNR_dB,BER_Gray_5(1,:),'sb','linewidth',0.75); hold on
semilogy(ax1,SNR_dB,BER_Gray_5(2,:),'sr','linewidth',0.75); hold on
semilogy(ax1,SNR_dB,BER_nonGray_5(1,:),'ob','linewidth',0.75); hold on
semilogy(ax1,SNR_dB,BER_nonGray_5(2,:),'or','linewidth',0.75); hold on
legend('$U_1$','$U_2$','J-Gray','D-Gray',...
       'interpreter','latex',...
       'fontsize',10,'location','northeast')

ax1.XGrid = 'on';
ax1.YGrid = 'on';
ax1.XLim = [min(SNR_dB) max(SNR_dB)];
ax1.YLim = [1E-3 1];
ax1.FontSize = 12;
ax1.LineWidth = 0.75;
% ax1.XAxis.Exponent = -2; 
xlabel(ax1,'Transmit SNR (dB)','interpreter','latex','fontsize',12)
ylabel(ax1,'BER','interpreter','latex','fontsize',12)
