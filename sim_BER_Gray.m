% 29.06.2024
% Copyrights to Khalifa University
% Author: Hamad Yahya

% This function is used to simulate Downlink NOMA system with Joint Gray
% Labeling (systematic approach)
% N = arbitrary number of users ==> U_1 is near user while U_N is far user
% The channel model is the SISO broadcast Rician flat fading
% Pathloss is ignored here to see the effect of interference
% Arbitrary modulation orders for rect QAM can be assigned to any of the users
% JMLD is assumed at the users

% Input:
% number of bits per user [b1 b2 ... bN]
% a: power coefficients vector (if a = [1] then single user BER)
% SNR_dB: SNR range or single value
% K_dB: Rician factor in dB
% Iter: Number of Monte-Carlo simulation iterations

% Output: 
% The BER is stored in a matrix of N rows where the column represents
% different SNR values.

function BER = sim_BER_Gray(b,a,SNR_dB,channel,channel_factor,Iter)
M = 2.^b;
K = 10.^(channel_factor./10);         % Rician factor (linear)
N = length(b);
Lambda = NaN.*ones(1,N);
moh = NaN.*ones(1,N);
D1 = NaN.*ones(1,N);
D2 = NaN.*ones(1,N);
xBits = NaN.*ones(1,N);
yBits = NaN.*ones(1,N);
kappa = NaN.*ones(1,N);
LutKey = cell(1,N);


for i = 1:N
    Lambda(i) = 2^(ceil(0.5*log2(M(i))))-1;
    moh(i) = 2^(floor(0.5*log2(M(i))))-1;
    D1(i) = Lambda(i) + 1;
    xBits(i) = log2(D1(i));
    D2(i) = moh(i) + 1;
    yBits(i) = log2(D2(i));
    [LutKey{i},kappa(i)] = rectNaturalQAM_mod([D1(i) D2(i)]);
    LutKey{i} = LutKey{i}./sqrt(kappa(i));
end

SNR = 10.^(SNR_dB./10);     % SNR linear scale
Sf = sqrt(1./(2*SNR));      % AWGN scaling factor
% Large scale fading (Pathloss)
q = 0;
qq = 0; % ignoring pathloss
for i = 1:N
    PL(i) = 10.^(q/10);
    q = q + qq;
end

BER = NaN*ones(N,size(SNR_dB,2)); % initializing the average BER

for i_snr = 1:length(SNR_dB)
    bit_error = zeros(N,1);
    code = cell(1,N);
    grayCode = cell(1,N);
    symbol = cell(1,N);
    graySymbol  = cell(1,N);
    h = cell(1,N);
    x = cell(1,N);
    n = cell(1,N);
    y = cell(1,N);
    MSE = cell(1,N);
    decis = cell(1,N);
    data_detected = cell(1,N);
    % Transmitted NOMA symbols
    ii = N;
    for i = 1:N
        symbol{i} = randi([0 M(i)-1],1,Iter);
        code{i} = de2bi(symbol{i},b(i),'left-msb');
        ii = ii - 1;
    end
    [~,~,grayCode] = grayEncoderNOMA(code,xBits,yBits);
    x_sc = 0;
    for i = 1:N
        graySymbol{i} = bi2de(grayCode{i},'left-msb');
        x{i} = LutKey{i}(graySymbol{i}+1).';
        x_sc = x_sc + sqrt(a(i)).*x{i};
    end
    for i = 1:N
        if(strcmp(channel,'Ray'))
            h{i} = 1./sqrt(2.*PL(i)).*(randn(1,Iter) + 1j*randn(1,Iter));
        elseif(strcmp(channel,'AWGN'))
            h{i} = 1;
        elseif(strcmp(channel,'Nak'))
            h{i} = 1/sqrt(PL(i)).*sqrt(gamrnd(channel_factor,1./channel_factor,1,Iter)).*exp(1j*rand(1,Iter)*pi);
        elseif(strcmp(channel,'Rice'))
            h_real = randn(1,Iter);
            h_img = randn(1,Iter);
            h{i} = 1./sqrt(PL(i)).*(sqrt(K./(K + 1)) + sqrt(1./(K + 1))/sqrt(2).*(h_real + 1j.*h_img));
        end
        % AWGN
        n{i} = (randn(1,Iter)+1j*randn(1,Iter))*Sf(i_snr);
        % Received signal
        y{i} = h{i}.*x_sc + n{i};
        
        TU_index = N-i+1;
        y_in = y{i};
        for i_chain = 1:1:TU_index
            y_eq = y_in./h{i};                        
            MSE = abs(y_eq - sqrt(a(N-i_chain+1)).*LutKey{N-i_chain+1});     % MLD
            [min_metric,decis] = min(MSE,[],1);
            s_u = LutKey{N-i_chain+1}(decis).';
            y_sic = y_in - s_u.*h{i}*sqrt(a(N-i_chain+1));        % SIC
            y_in = y_sic;
            symbolGray_detected{i,i_chain} = decis - 1;
            dataGray_detected{i,i_chain} = de2bi(symbolGray_detected{i,i_chain},'left-msb');
        end
    end
    for i = 1:N
        data_detected{i} = grayDecoderNOMA(dataGray_detected,xBits,yBits,i);
        bit_error(i,1) = sum([data_detected{i}]~=[code{i}],'all');
    end
    BER(:,i_snr) = bit_error./Iter./b.';
end
    

