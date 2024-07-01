clc
clear
close all
b = [2 4];
a1max = alpha1Max2UE(b);
a1 = linspace(0,a1max,10);
SNR_dB = 15;
channel = "AWGN";
channel_factor = [];
BER1th_Gray = ones(1,10);
BER1th_nonGray = ones(1,10);
BER2th = ones(1,10);
for i_alpha = 1:length(a1)
    a = [a1(i_alpha) 1-a1(i_alpha)];
    BER1th_Gray(1,i_alpha) = func_BERth_U1_Gray(b,a,SNR_dB,channel,channel_factor);
    BER1th_nonGray(1,i_alpha) = func_BERth_U1_nonGray(b,a,SNR_dB,channel,channel_factor);
    BER2th(1,i_alpha) = func_BERth_U2_Gray(b,a,SNR_dB,channel,channel_factor);
end
%%

Iter = 1e5;
BER_Gray = NaN.*ones(2,10);
BER_nonGray = NaN.*ones(2,10);
for i_alpha = 2:length(a1)-1
    a = [a1(i_alpha) 1-a1(i_alpha)];
    BER_Gray(:,i_alpha) = sim_BER_Gray(b,a,SNR_dB,channel,channel_factor,Iter);
    BER_nonGray(:,i_alpha) = sim_BER_nonGray(b,a,SNR_dB,channel,channel_factor,Iter);
end

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
semilogy(ax1,a1./a1max,BER1th_Gray,'--b','linewidth',0.75); hold on
semilogy(ax1,a1./a1max,BER2th,'-r','linewidth',0.75); hold on
semilogy(ax1,a1./a1max,BER1th_nonGray,'--b','linewidth',0.75); hold on

semilogy(ax1,a1./a1max,BER_Gray(1,:),'sb','linewidth',0.75); hold on
semilogy(ax1,a1./a1max,BER_Gray(2,:),'sr','linewidth',0.75); hold on
semilogy(ax1,a1./a1max,BER_nonGray(1,:),'ob','linewidth',0.75); hold on
semilogy(ax1,a1./a1max,BER_nonGray(2,:),'or','linewidth',0.75); hold on

legend('$U_1$','$U_2$','J-Gray','D-Gray',...
       'interpreter','latex',...
       'fontsize',10,'location','northeast')

ax1.XGrid = 'on';
ax1.YGrid = 'on';
ax1.XLim = [min(a1./a1max) max(a1./a1max)];
ax1.YLim = [1E-2 1];
ax1.FontSize = 12;
ax1.LineWidth = 0.75;
% ax1.XAxis.Exponent = -2; 
xlabel(ax1,'$\frac{\alpha_1}{\alpha_{1,\max}}$','interpreter','latex','fontsize',12)
ylabel(ax1,'BER','interpreter','latex','fontsize',12)
