function BER1th = func_BERth_U1_nonGray(b,a,SNR_dB,channel,channel_factor)
% channel_factor: m factor for Nak
% channel_factor: Rician factor in dB for Rice
% clc
% clear
% close all
% b = [2 2];
% a = equal_distance_square(b).';
% SNR_dB = 0:30;
% channel = 'Rice'
% channel_factor = [5 5]
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

Sd = sqrt(PL(1))./sqrt(2.*SNR);
kappa = 2/3.*(M-1);

% SU loop
A_su = cell(1,log2(sqrt(M(1))));
c_su = cell(1,log2(sqrt(M(1))));
BER_su = cell(1,log2(sqrt(M(1))));
for k = 1:log2(sqrt(M(1)))
    i = [0:(1-2^(-k))*(sqrt(M(1))-1)];
    d_i = 2.*i + 1;
    c_su{k} = 2/sqrt(M(1))*(-1).^floor(i.*2^(k-1)./sqrt(M(1))).*...
              (2^(k-1) - floor(i.*2^(k-1)./sqrt(M(1))+1/2));
    c_su{k} = c_su{k}.';
    A_su{k} = d_i.*sqrt(a(1)/kappa(1)) + 0.*sqrt(a(2)/kappa(2));
    A_su{k} = A_su{k}(:);

    if(strcmp(channel,'AWGN'))
        gamma = 1./Sd.^2;
        BER_su{k} = sum(c_su{k}.*0.5.*erfc(A_su{k}.*sqrt(gamma/2)),1);
    elseif(strcmp(channel,'Ray'))
        gamma = (A_su{k}./Sd).^2;
        BER_su{k} = sum(c_su{k}.*0.5.*(1 - sqrt(gamma./(2 + gamma))),1);
    elseif(strcmp(channel,'Nak'))
        gamma = 1./Sd.^2;
        BER_su{k} = sum(c_su{k}.*Epsi(A_su{k},SNR_dB,channel_factor,PL(1)),1);
    elseif(strcmp(channel,'Rice'))
        K_dB = channel_factor;
        K_r = 10.^(K_dB./10);
        gamma{k} = (A_su{k}(:)./Sd).^2./(1+K_r);
        a_rice{k} = sqrt(K_r./(2.*(1+0.5.*gamma{k}))).*sqrt(1+2.*0.5.*gamma{k}-2.*sqrt(0.5.*gamma{k}.*(1+0.5.*gamma{k})));
        b_rice{k} = sqrt(K_r./(2.*(1+0.5.*gamma{k}))).*sqrt(1+2.*0.5.*gamma{k}+2.*sqrt(0.5.*gamma{k}.*(1+0.5.*gamma{k})));
        BER_su{k} = sum(c_su{k}.*(marcumq(a_rice{k},b_rice{k}) - 0.5*(1 + sqrt(0.5*gamma{k}./(1 + 0.5*gamma{k}))).*exp(-0.5*(a_rice{k}.^2 + b_rice{k}.^2)).*besseli(0,a_rice{k}.*b_rice{k})),1);
    end
end

m = 1:sqrt(M(2))-1;
for k = 1:log2(sqrt(M(1)))
    f = 1 - ceil(floor(k-1/2)./k);
    i = [0:(2^f*(2- 2^(1-k))*sqrt(M(1))-1)].';
    if(f==1)
        i_bar = [i(1:(2 - 2^(1-k))*sqrt(M(1)));i(1:(2 - 2^(1-k))*sqrt(M(1)))];
        d_m = 2*m + floor(i./((2- 2^(1-k))*sqrt(M(1)))) - 1;
    elseif(f==0)
        i_bar = i;
        d_m = 2*m;
    end
    d_i = 2.*i_bar - sqrt(M(1))*(2-2^(1-k)) + 1;
    temp = nchoosek_sVer2(2,2^(k-1));
    temp_ = temp(floor(2^k.*i_bar./2./sqrt(M(1)))+1);
    temp_ = reshape(temp_,[length(temp_),1]);
    c{k} = 2./sqrt(prod(M)).*(sqrt(M(2))-m).*...
           (-1).^floor(2^k*i/sqrt(M(1))-(2.^(k-1).*i/sqrt(M(1))-1/2)).*...
           temp_;
    c{k} = c{k}(:);
    A{k} = d_i.*sqrt(a(1)/kappa(1)) + d_m.*sqrt(a(2)/kappa(2));
    A{k} = A{k}(:);
    
    if(strcmp(channel,'AWGN'))
        gamma = 1./Sd.^2;
        BER_sic{k} = sum(c{k}.*0.5.*erfc(A{k}.*sqrt(gamma/2)),1);
    elseif(strcmp(channel,'Ray'))
        gamma = (A{k}./Sd).^2;
        BER_sic{k} = sum(c{k}.*0.5.*(1 - sqrt(gamma./(2 + gamma))),1);
    elseif(strcmp(channel,'Nak'))
        gamma = 1./Sd.^2;
        BER_sic{k} = sum(c{k}.*Epsi(A{k},SNR_dB,channel_factor,PL(1)),1);
    elseif(strcmp(channel,'Rice'))
        K_dB = channel_factor;
        K_r = 10.^(K_dB./10);
        gamma{k} = (A{k}(:)./Sd).^2./(1+K_r);
        a_rice{k} = sqrt(K_r./(2.*(1+0.5.*gamma{k}))).*sqrt(1+2.*0.5.*gamma{k}-2.*sqrt(0.5.*gamma{k}.*(1+0.5.*gamma{k})));
        b_rice{k} = sqrt(K_r./(2.*(1+0.5.*gamma{k}))).*sqrt(1+2.*0.5.*gamma{k}+2.*sqrt(0.5.*gamma{k}.*(1+0.5.*gamma{k})));
        BER_sic{k} = sum(c{k}.*(marcumq(a_rice{k},b_rice{k}) - 0.5*(1 + sqrt(0.5*gamma{k}./(1 + 0.5*gamma{k}))).*exp(-0.5*(a_rice{k}.^2 + b_rice{k}.^2)).*besseli(0,a_rice{k}.*b_rice{k})),1);
    end

    BERthPerBit{k} = BER_su{k}.' + BER_sic{k}.';

end

BER1th = mean([BERthPerBit{:}],2).';