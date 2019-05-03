function H = ilpf(D0,M)
% Create a ideal low pass filter

H = zeros(M,M);
[DX, DY] = meshgrid(1:M);
D = sqrt((DX-M/2-1).^2+(DY-M/2-1).^2);
MASK = (D<=D0);
H(MASK) = 1;
