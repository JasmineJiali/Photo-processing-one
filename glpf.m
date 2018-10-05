function H = glpf(D0,M,N)
% Create a Gaussian band pass filter
X = 1:1:N;
Y = 1:1:M;
[DX, DY] = meshgrid(X,Y);
D = sqrt((DX-N/2-1).^2+(DY-M/2-1).^2);
H = 1./(1+(D0./D).^(2*2));