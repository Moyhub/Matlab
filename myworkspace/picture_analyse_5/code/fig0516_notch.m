function fig0516_notch()
% fig0516_notch, P358

f = imread('..\data\Fig0516(a)(applo17_boulder_noisy).tif');
f = im2double(f);
[M,N] = size(f);

% P = max([M N]);% Padding size. 
F = fftshift(fft2(f,M,N));

close all
figure(1),imshow(f,[]);
figure(2),imshow(log(1+abs(F)),[]);

% find position of noise
if 1
    impixelinfo;
    return
end

% Creat 4 pairs of notch reject filters
p = [316 61; 441 113; 493 238; 441 363];% locations of maxima, found by impixelinfo
H = ones(M,N);
[DX, DY] = meshgrid(1:N,1:M);
D0 = 20; n = 4;
for k = 1:4
    Dk1 = sqrt((DX-p(k,1)).^2+(DY-p(k,2)).^2);
    Dk2 = sqrt((DX-N-2+p(k,1)).^2+(DY-M-2+p(k,2)).^2);
    H1 = 1./(1+(D0./Dk1).^(2*n));
    H2 = 1./(1+(D0./Dk2).^(2*n));
    H = H.*H1.*H2;
end
figure(3),imshow(H,[]);

G_noise = F.*H;
g_noise = real(ifft2(ifftshift(G_noise)));
G = F.*(1-H);
g = real(ifft2(ifftshift(G)));

figure(4),imshow(g_noise,[]);
figure(5),imshow(g,[]);
