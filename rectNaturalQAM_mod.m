% This function generates Naturally Labelled Rectangular M-QAM constellations (not
% normalized)
% D = [D1 D2] where D1 is x-length and D2 is y-length
function [LutKey,kappa,symbol,bits,symbol_x,symbol_y,bits_x,bits_y] = rectNaturalQAM_mod(D)
% clc
% clear 
% close all
% D = [4 2];
M = D(1)*D(2);
Lambda = D(1)-1;
moh = D(2)-1;
InPhase = -Lambda:2:Lambda;       %in-phase components
xLength = length(InPhase);
xBits = log2(xLength);
InPhase = ones(moh+1,Lambda+1)*diag(InPhase); 
QuadPhase = [moh:-2:-moh].';      %quad-phase components
yLength = length(QuadPhase);
yBits = log2(yLength);
LUT = InPhase + 1j*QuadPhase;     %Scatter matrix
LutKey = LUT(:); 
kappa = LutKey'*LutKey/M;         %normalization factor
symbol = [0:1:M-1].';
bits = de2bi(symbol,'left-msb');

if (Lambda==0)
    symbol_x = [];
    bits_x = [];
else
    symbol_x = [0:1:xLength-1].*ones(size(LUT)); %Gray coding
    symbol_x = symbol_x(:);
    bits_x = de2bi(symbol_x,'left-msb');
  
end

if (moh==0)
    symbol_y = [];
    bits_y = [];
else
    symbol_y = [0:1:yLength-1].'.*ones(size(LUT));
    symbol_y = symbol_y(:);
    bits_y = de2bi(symbol_y,'left-msb');
end
