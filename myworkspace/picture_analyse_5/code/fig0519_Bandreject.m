function fig0519_Bandreject()
% fig0516_Bandreject, P358

f = imread('..\data\Fig0519(a)(florida_satellite_original).tif');
f = im2double(f);
[M,N] = size(f);

% P = max([M N]);% Padding size. 
F = fftshift(fft2(f,M,N));

close all
figure(1),imshow(f,[]);
figure(2),imshow(log(1+abs(F)),[]);

H = ones(size(f));
if 1
    H(1:M/2-10,N/2-3:N/2+3) = 0;
    H(M/2+11:end,N/2-3:N/2+3) = 0;
else% remove low frequency
    H(:,N/2-3:N/2+3) = 0;
end

G_noise = F.*H;
g_noise = real(ifft2(ifftshift(G_noise)));
G = F.*(1-H);
g = real(ifft2(ifftshift(G)));

figure(3),imshow(g_noise,[]);
figure(4),imshow(g,[]);
figure(5),imshow(H,[]);