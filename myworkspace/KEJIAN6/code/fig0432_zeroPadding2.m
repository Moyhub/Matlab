%fig0432_zeroPadding
close all
% f = imread('..\data\Fig0429(a)(blown_ic).tif');
f = imread('..\data\Fig0432(a)(square_original).tif');
f = im2double(f);
[M,N] = size(f);
P = 2*max([M N]);
fp = padarray(f,[P-M P-N],0,'post');

F = fftshift(fft2(fp));

% Gaussian lowpass filter
[X, Y] = meshgrid(1:P);
D0 = P/100;
H = exp(-((X-P/2-1).^2+(Y-P/2-1).^2)/(2*D0*D0));

% filtering
G = F.*H;

figure(1),imshow(f),title('f(x,y): Input Image')
figure(2),imshow(fp),title('fp(x,y): Padded Image')
figure(3),imshow(log(1+abs(F)),[]),title('|F(u,v)|: Spectrum of f')
figure(4),imshow(H),title('H(u,v): Gaussian lowpass filter')
% figure(3),surf(X(1:10:end,1:10:end),Y(1:10:end,1:10:end),H(1:10:end,1:10:end)),title('H(u,v): Gaussian lowpass filter')

gp = real(ifft2(ifftshift(G)));
g = gp(1:M,1:N);
figure(5),imshow(log(1+abs(G)),[]),title('G(u,v)=F(u,v)H(u,v)')
figure(6),imshow(g),title('g(x,y): filtering result with zero padding')