function data_detected_ = grayDecoderNOMA(dataGray_detected,xBits,yBits,i)
N = length(xBits);
TU_index = N-i+1;
ii = N;
for i_chain = 1:TU_index
    dataGray_x{1,i_chain} = dataGray_detected{i,i_chain}(:,1:xBits(ii));
    if (yBits(ii)~=0)
        dataGray_y{1,i_chain} = dataGray_detected{i,i_chain}(:,xBits(ii)+1:end);
    else
        dataGray_y{1,i_chain} = [];
    end
    ii = ii - 1;
end

nomaGrayCode_x = [dataGray_x{1,:}];

if (sum(yBits(i:N))~=0)
    nomaGrayCode_y = [dataGray_y{1,:}];
else
    nomaGrayCode_y = [];
end

nomaCode_x(:,1) = nomaGrayCode_x(:,1);
if(size(nomaGrayCode_x,2)>1)
    for ii = 2:size(nomaGrayCode_x,2)
        nomaCode_x(:,ii) = xor(nomaGrayCode_x(:,ii),nomaGrayCode_x(:,ii-1));
    end
end
if(size(nomaGrayCode_y,2)~=0)
    nomaCode_y(:,1) = nomaGrayCode_y(:,1);
    if(size(nomaGrayCode_y,2)>1)
        for ii = 2:size(nomaGrayCode_y,2)
            nomaCode_y(:,ii) = xor(nomaGrayCode_y(:,ii),nomaGrayCode_y(:,ii-1));
        end
    end
    
else
    nomaCode_y = [];
end

if(xBits(i)~=0)
    Code_x = nomaCode_x(:,sum(xBits(i+1:N))+1:end);
else
    Code_x = [];
end

if(yBits(i)~=0)
    Code_y = nomaCode_y(:,sum(yBits(i+1:N))+1:end);
    data_detected_ = [Code_x Code_y];
else
    Code_y{i} = [];
    data_detected_ = [Code_x];
end



