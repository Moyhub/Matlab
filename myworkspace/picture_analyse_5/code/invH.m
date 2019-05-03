% invH
close all
f = im2double(imread('..\data\lena512.bmp'));
N = 512;
F = fft2(f);

% blur
b = 16;
h = ones(b,b)/b^2;
H = fft2(h,N,N);
G = F.*H;
noise_level = 0;%0.05;
g = ifft2(G) + noise_level*randn(N,N);
G = fft2(g);

figure(1), 
subplot(2,3,1), imshow(f), title('f')
subplot(2,3,2), imshow(log(abs(fftshift(F))+1),[]), title('|F|')
subplot(2,3,3), imshow(log(abs(fftshift(H))+1),[]), title('|H|')
subplot(2,3,4), imshow(g,[]), title('g')
subplot(2,3,5), imshow(log(abs(fftshift(G))+1),[]), title('|G|')

n=.000002;
H2 = H;
H2(abs(H2)<n) = n;
R = ones(N,N)./H2;% restoration filter
F2 = G.*R;
f2 = abs(ifft2(F2));

subplot(2,3,6), imshow(log(abs(fftshift(R))+1),[]), title('|R|')

figure(2), 
subplot(2,3,1), imshow(log(abs(fftshift(F))+1),[]), title('|F|')
subplot(2,3,2), imshow(log(abs(fftshift(G))+1),[]), title('|G|')
subplot(2,3,3), imshow(log(abs(fftshift(F2))+1),[]), title('|F2|')
subplot(2,3,4), imshow(f,[]), title('f')
subplot(2,3,5), imshow(g,[]), title('g')
subplot(2,3,6), imshow(f2,[]), title('f2')
