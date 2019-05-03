% ex0511_InverseFilter
close all
f = im2double(imread('C:\Users\MacBook Air\Documents\MATLAB\myworkspace\picture_analyse_5\data\Fig0525(a)(aerial_view_no_turb).tif'));
figure(1), subplot(2,2,1), imshow(f), title('f');

g = im2double(imread('C:\Users\MacBook Air\Documents\MATLAB\myworkspace\picture_analyse_5\data\Fig0525(b)(aerial_view_turb_c_0pt0025).tif'));
subplot(2,2,2), imshow(g), title('g');

[M,N] = size(g);
P = max(2*[M N]);% Padding size. 

G = fftshift(fft2(g,P,P));
subplot(2,2,3), imshow(log(abs(G)+1),[]), title('|G|');

% Degradation function
[DX, DY] = meshgrid(1:P);
H = exp(-0.0025*(((DX-P/2-1).^2+(DY-P/2-1).^2)^(5/6)));
subplot(2,2,4), imshow(log(abs(H)+1),[]), title('H');

F2 = G./H;
figure(2), subplot(2,2,1),imshow(log(abs(F2)+1),[]), title('|F2|');

f2 = real(ifft2(ifftshift(F2)));% estimate of f
f2 = f2(1:M,1:N);
subplot(2,2,2), imshow(f2), title('f2');

D0 = 40;
H_lp = blpf(D0,10,P);%butterworth lowpass filter
F3 = F2.*H_lp;
f3 = real(ifft2(ifftshift(F3)));
f3 = f3(1:M,1:N);
subplot(2,2,3), imshow(log(abs(F3)+1),[]), title('|F3|');
subplot(2,2,4), imshow(f3,[]), title('f3');
