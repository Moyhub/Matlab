%ex0420_laplacian
f = imread('..\data\Fig0458(a)(blurry_moon).tif');
f = im2double(f);
[M,N] = size(f);
P = max(2*[M N]);% Padding size. 
F = fftshift(fft2(f,P,P));

[DX, DY] = meshgrid(1:P);
H = -4*pi*pi * ((DX-P/2-1).^2 + (DY-P/2-1).^2);
G1 = H.*F;
g1 = real(ifft2(ifftshift(G1)));
g1 = g1(1:M,1:N);
g = f - g1/max(g1(:));

close all
figure(1),imshow(f,[]);
figure(2),imshow(log(1+abs(F)),[]);
figure(3),mesh(H(1:5:end,1:5:end)),colormap('jet');
figure(4),imshow(H,[]);
figure(5),imshow(log(1+abs(G1)),[]);
figure(6),imshow(g1,[]);
figure(7),imshow(g,[]);
