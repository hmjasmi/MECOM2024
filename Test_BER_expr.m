clc
clear
close all
b = [10 10];
M = 2.^b;
a = equal_distance_square(b).';
SNR_dB = 0:50;
K_dB = 5;
BERth = [func_BERth_U1_nonGray(b,a,SNR_dB,'AWGN',[])];
BERth_tasneem = BER_An_U2(M(2),M(1),SNR_dB,a(2));
% BER = sim_BER_nonGray(b,a,SNR_dB,'AWGN',[],1e5);
% BER = BER(1,:);
%%
figure
set(gcf, 'Units', 'Inches', 'Position', [0, 0, 4.5, 4.5], 'PaperUnits', 'Inches', 'PaperSize', [4.5, 4.5]);
set(groot,'defaultAxesTickLabelInterpreter','tex');
set(gcf,'color','w');
t = tiledlayout(1,1,'TileSpacing','tight');
t.Padding = 'compact';
ax1 = axes(t);
semilogy(ax1,NaN,NaN,'-','LineWidth',0.75); hold on
semilogy(ax1,NaN,NaN,'ok','LineWidth',0.75); hold on
ax1.ColorOrderIndex = 1;
semilogy(ax1,SNR_dB,BERth,'-','LineWidth',0.75); hold on
semilogy(ax1,SNR_dB,BERth_tasneem,'ok','LineWidth',0.75); hold on
% semilogy(ax1,SNR_dB,BER,'ok','LineWidth',0.75); hold on
ax1.XGrid = 'on';
ax1.YGrid = 'on';
xlabel(ax1,'SNR (dB)','interpreter','tex','fontsize',11)
ylabel(ax1,'BER','interpreter','tex','fontsize',11)
legend(ax1,'Near User','Tasneem',...
           'interpreter','tex','fontsize',10,'location','northeast') 

ax1.XLim = [min(SNR_dB) max(SNR_dB)];
ax1.YLim = [1e-4 1];
ax1.FontSize = 11;
ax1.LineWidth = 0.75;

% ax2 = axes(t);
% ax2.Layout.Tile=2;
% ax2.ColorOrderIndex = 1;
% print(gcf,'Fig_3UEsumrate_SNR_N8.eps','-depsc','-r600');

