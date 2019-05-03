%ex0422_homographic
close all
img = imread('C:\Users\MacBook Air\Documents\大三上学期\数字图像处理\综合作业1\phone.bmp');
% f = rgb2gray(imread('..\data\jordan.jpg'));% not easy too set parameter
f = double(f);
[M,N] = size(f);
z = log(f+1);

P = max([M N]);
zp = padarray(z,[P-M P-N],0,'post');

Z = fftshift(fft2(zp));

% filter
[X, Y] = meshgrid(1:P);
D0 = 80;
gamma_h = 2;
gamma_l = 0.25;
% D0 = 300;
% gamma_h = 2;
% gamma_l = 1;
c = 1;
H = (gamma_h-gamma_l) * (1-exp(-c*((X-P/2-1).^2+(Y-P/2-1).^2)/(D0*D0))) + gamma_l;

% filtering
S = Z.*H;

figure(1),imshow(f,[]),title('f(x,y)')
figure(2),imshow(log(1+abs(S)),[]),title('|S(u,v)|')
figure(3),surf(X(1:10:end,1:10:end),Y(1:10:end,1:10:end),H(1:10:end,1:10:end)),title('H(u,v)')
figure(4),imshow(H,[]),title('H(u,v)')

sp = real(ifft2(ifftshift(S)));
s = sp(1:M,1:N);
g = exp(s-1);
figure(5),imshow(g,[]),title('g(x,y)')