f = imread('..\data\F0020.bmp');
[M,N] = size(f);
P = max(2*[M N]);% Padding size. 

D0=90;
W=70;
n=2;
% H = 1-ibpf(D0,W,P);
H = 1-bbpf(D0,W,n,P);
% H = gbpf(D0,W,P);

F = fftshift(fft2(f,P,P));
G = F.*H;
g = real(ifft2(ifftshift(G)));
g = g(1:M,1:N);

close all
figure(1),imshow(f,[]);
figure(2),imshow(log(1+abs(F)),[]);
figure(3),mesh(H(1:10:end,1:10:end)),colormap('jet');
figure(4),imshow(H,[]);
figure(5),imshow(log(1+abs(G)),[]);
figure(6),imshow(g,[]);
