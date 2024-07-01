function BER2th = func_BERth_U2_Gray(b,a,SNR_dB,channel,channel_factor)
% channel_factor: m factor for Nak
% channel_factor: Rician factor in dB for Rice
% clc
% clear
% close all
% b = [2 4];
% a = equal_distance_square(b).';
% SNR_dB = 0:30;
% channel = 'AWGN'
% channel_factor = []
N = 2;
M = 2.^b;
SNR = 10.^(SNR_dB./10);

if(strcmp(channel,'AWGN'))
    qq = 0;
else
    qq = 0;
end

q = 0;
for i = 1:N
    PL(i) = 10.^(q/10);
    q = q + qq;       %to account for pathloss (factored out) 
end

Sd = sqrt(PL(2))./sqrt(2.*SNR);
kappa = 2/3.*(M-1);

i = [0:sqrt(M(1))-1].';
d_i = 2.*i - sqrt(M(1)) + 1;
A = cell(1,log2(sqrt(M(2))));
c = cell(1,log2(sqrt(M(2))));
for k = 1:log2(sqrt(M(2)))
    m = 1:(1-2.^(-k))*sqrt(M(2));
    d_m = 2.*m - 1;
    c{k} = 2/sqrt(prod(M)).*...
        (-1).^floor(2.^k.*(m-1)./2./sqrt(M(2))).*...
        (2.^k./2-floor((m-1)./2.^(1-k)./sqrt(M(2))+1/2));
    A{k} = d_i.*sqrt(a(1)/kappa(1)) + d_m.*sqrt(a(2)/kappa(2));
    A{k} = A{k}(:);
    c{k} = c{k}.*ones(length(d_i),1);
    c{k} = c{k}(:);

    if(strcmp(channel,'AWGN'))
        gamma = 1./Sd.^2;
        BER{k} = sum(c{k}.*0.5.*erfc(A{k}.*sqrt(gamma/2)),1);
    elseif(strcmp(channel,'Ray'))
        gamma = (A{k}./Sd).^2;
        BER{k} = sum(c{k}.*0.5.*(1 - sqrt(gamma./(2 + gamma))),1);
    elseif(strcmp(channel,'Nak'))
        gamma = 1./Sd.^2;
        BER{k} = sum(c{k}.*Epsi(A{k},SNR_dB,channel_factor,PL(2)),1);
    elseif(strcmp(channel,'Rice'))
        K_dB = channel_factor;
        K_r = 10.^(K_dB./10);
        gamma{k} = (A{k}(:)./Sd).^2./(1+K_r);
        a_rice{k} = sqrt(K_r./(2.*(1+0.5.*gamma{k}))).*sqrt(1+2.*0.5.*gamma{k}-2.*sqrt(0.5.*gamma{k}.*(1+0.5.*gamma{k})));
        b_rice{k} = sqrt(K_r./(2.*(1+0.5.*gamma{k}))).*sqrt(1+2.*0.5.*gamma{k}+2.*sqrt(0.5.*gamma{k}.*(1+0.5.*gamma{k})));
        BER{k} = sum(c{k}.*(marcumq(a_rice{k},b_rice{k}) - 0.5*(1 + sqrt(0.5*gamma{k}./(1 + 0.5*gamma{k}))).*exp(-0.5*(a_rice{k}.^2 + b_rice{k}.^2)).*besseli(0,a_rice{k}.*b_rice{k})),1);
    end

    BERthPerBit{k} = BER{k}.';

end

BER2th = mean([BERthPerBit{:}],2).';