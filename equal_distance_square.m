function a = equal_distance_square(b)
M = 2.^b; % only square QAM
N = length(M);
kappa = 2/3.*(M-1);
Lambda = sqrt(M)-1;
z = zeros(N,1);
z(N,1) = 1;
Omega = zeros(N,N);
Omega(N,:) = ones(1,N);
for i = 1:N-1
    Omega(i,i) = kappa(i+1)*(Lambda(i)+1)^2;
    Omega(i,i+1) = -kappa(i);
end
a = linsolve(Omega,z);
