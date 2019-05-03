function fig0520_OptimalNotch()
% fig0516_Bandreject, P362
% peak太多了，还没有找

f = imread('..\data\Fig0520(a)(NASA_Mariner6_Mars).tif');
f = 1-im2double(f(:,:,1));
[M,N] = size(f);

% P = max([M N]);% Padding size. 
F = fftshift(fft2(f,M,N));
% F = fft2(f,M,N);

close all
figure(1),imshow(f,[]);
figure(2),imshow(log(1+abs(F)),[]);

% H = ones(size(f));
% H(1:M/2-10,N/2-3:N/2+3) = 0;
% H(M/2+11:end,N/2-3:N/2+3) = 0;
% 
% G_noise = F.*H;
% g_noise = real(ifft2(ifftshift(G_noise)));
% G = F.*(1-H);
% g = real(ifft2(ifftshift(G)));
% 
% figure(3),imshow(g_noise,[]);
% figure(4),imshow(g,[]);
% figure(5),imshow(H,[]);