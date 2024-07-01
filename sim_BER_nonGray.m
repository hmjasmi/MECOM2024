% 12.04.2024
% Copyrights to Khalifa University
% Author: Hamad Yahya

% This function is used to simulate Downlink NOMA system
% N = arbitrary number of users ==> U_1 is near user while U_N is far user
% The channel model is the SISO broadcast flat fading
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

function BER = sim_BER_nonGray(b,a,SNR_dB,channel,channel_factor,Iter)
N = length(a);              % number of users
SNR = 10.^(SNR_dB./10);     % SNR linear scale
Sf = sqrt(1./(2*SNR));      % AWGN scaling factor
M = 2.^b;                   % Modulation orders
K = 10.^(channel_factor./10);         % Rician factor (linear)

% Large scale fading (Pathloss)
q = 0;
for i = 1:N
    PL(i) = 10.^(q/10);
    q = q + 0;
end

% Generating the constellations for each user
kappa = ones(1,N);
Lambda = ones(1,N);
symKey = cell(1,N);
LutKey = cell(1,N);
DataKeyLUT = cell(1,N);
xLength = ones(1,N);
yLength = ones(1,N);

% Generating the constellations for each user
for i = 1:N
    symKey{i} = 0:M(i)-1;
    LutKey{i} = rectGrayQAM_mod(M(i));
    kappa(i) = LutKey{i}*LutKey{i}'/M(i);
    Lambda(i) = 2^(ceil(0.5*log2(M(i))))-1;
    LutKey{i} = LutKey{i}/sqrt(LutKey{i}*LutKey{i}'/M(i));
    xLength(i) = length(unique(real(LutKey{i})));
    yLength(i) = length(unique(imag(LutKey{i})));
end

LUT = cell(1,N);
[LUT{:}] = ndgrid(LutKey{:}); % generating the possible combinations for constellations before multiplexing
data_LUT = cell(1,N);
symMesh = cell(1,N);
[symMesh{:}] = ndgrid(symKey{:});

% Decimal to binary represenation for each NOMA symbol (per user)
for i = 1:N
    data_LUT{i} = de2bi(symMesh{i}(:).','left-msb');
end

% NOMA LUT generation
LUT_C = 0;
for i = 1:N
    LUT{i} = LUT{i}(:).';
    LUT_C = LUT_C + sqrt(a(i))*LUT{i};
end

% Monte-Carlo Simulation
BER = NaN*ones(N,size(SNR_dB,2)); % initializing the average BER
for i_snr = 1:size(SNR_dB,2)
    bit_error = zeros(N,1);
    symbol = cell(1,N);
    code = cell(1,N);
    s = cell(1,N);
    h = cell(1,N);
    n = cell(1,N);
    y = cell(1,N);
    MSE = cell(1,N);
    decis = cell(1,N);
    data_detected = cell(1,N);

    % Transmitted NOMA symbols
    x = 0;
    for i = 1:N
        symbol{i} = randi([0 M(i)-1],1,Iter);
        code{i} = de2bi(symbol{i},'left-msb').';
        s{i} = LutKey{i}(symbol{i}+1);
        x = x + sqrt(a(i))*s{i};
    end
    
    % Received NOMA symbols
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
            channel_factor = 10.^(channel_factor./10);
            h{i} = 1./sqrt(PL(i)).*(sqrt(channel_factor./(channel_factor + 1)) + sqrt(1./(channel_factor + 1))/sqrt(2).*(h_real + 1j.*h_img));
        end
        
        % AWGN
        n{i} = (randn(1,Iter)+1j*randn(1,Iter))*Sf(i_snr);
        
        % Received signal
        y{i} = h{i}.*x + n{i};
        
        % Equalization and JMLD
        MSE{i} = abs(y{i}./h{i} - LUT_C.');
        [min_metric,decis{i}] = min(MSE{i});
        for j = 1:log2(M(i))
            data_detected{i}(j,:) = data_LUT{i}(decis{i},j).';
        end
        bit_error(i)=sum([data_detected{i}]~=[code{i}],'all');
    end
    % Average BER computation
    BER(:,i_snr)= bit_error./Iter./b.';
end
