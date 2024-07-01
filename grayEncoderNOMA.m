function [nomaCode nomaGrayCode grayCode] = grayEncoderNOMA(code,xBits,yBits)
N = length(xBits);
ii = N;
for i = 1:N
    if (xBits(i)~=0)
        code_x{i} = code{i}(:,1:xBits(i));
        nomaCode_x{ii} = code_x{i};
    else
        code_x{i} = [];
        nomaCode_x{ii} = [];
    end
    if (yBits(i)~=0)
        code_y{i} = code{i}(:,xBits(i)+1:end);
        nomaCode_y{ii} = code_y{i};
    else
        code_y{i} = [];
        nomaCode_y{ii} = [];
    end
    ii = ii - 1;
end
nomaCode_x = [nomaCode_x{:}];
nomaCode_y = [nomaCode_y{:}];
nomaCode = [nomaCode_x nomaCode_y];
nomaGrayCode_x(:,1) = nomaCode_x(:,1);

for i = 2:sum(xBits)
    nomaGrayCode_x(:,i) = xor(nomaCode_x(:,i),nomaGrayCode_x(:,i-1));
end
if(sum(yBits)~=0)
    nomaGrayCode_y(:,1) = nomaCode_y(:,1);
    for i = 2:sum(yBits)
        nomaGrayCode_y(:,i) = xor(nomaCode_y(:,i),nomaGrayCode_y(:,i-1));
    end
    
else
    nomaGrayCode_y = [];
end

nomaGrayCode = [nomaGrayCode_x nomaGrayCode_y];
Ox = 1;
Oy = 1;
for i = N:-1:1
    if(xBits(i)~=0)
        grayCode_x{i} = nomaGrayCode_x(:,Ox:Ox+xBits(i)-1);
        Ox = Ox + xBits(i);
    else
        grayCode_x{i} = [];
    end
    
    if(yBits(i)~=0)
        grayCode_y{i} = nomaGrayCode_y(:,Oy:Oy+yBits(i)-1);
        Oy = Oy + yBits(i);
    else
        grayCode_y{i} = [];
    end
    grayCode{i} = [grayCode_x{i} grayCode_y{i}];
end
