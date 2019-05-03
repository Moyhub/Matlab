function fig0516_Bandreject()
% fig0516_Bandreject, P358

f = imread('..\data\Fig0516(a)(applo17_boulder_noisy).tif');
f = im2double(f);
[M,N] = size(f);

% P = max([M N]);% Padding size. 
F = fftshift(fft2(f,M,N));

close all
figure(1),imshow(f,[]);
figure(2),imshow(abs(F),[]);

% find position of noise (radius = 177)
if 0
    impixelinfo;
    return
end

D0 = 177; W = 5; n = 2;

H = bbpf(D0,W,n,N,M);
G_noise = F.*H;
g_noise = real(ifft2(ifftshift(G_noise)));
G = F.*(1-H);
g = real(ifft2(ifftshift(G)));

figure(3),imshow(g_noise,[]);
figure(4),imshow(g,[]);
figure(5),imshow(H,[]);