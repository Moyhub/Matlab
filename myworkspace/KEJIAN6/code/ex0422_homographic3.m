%ex0422_homographic
close all

M = 400; N = M;
[X, Y] = meshgrid(1:M);
i = 1.1+cos(2*pi*(1/M)*X);
phase = 2*pi*0.1*(X+Y);
r = 1+cos(phase);
f = i.*r;

% [M,N] = size(f);
z = log(f+1);

P = max([M N]);
fp = padarray(f,[P-M P-N],0,'post');
zp = padarray(z,[P-M P-N],0,'post');

F = fftshift(fft2(fp));
Z = fftshift(fft2(zp));

% filter
% H = 1-blpf(100,2,P);
[X, Y] = meshgrid(1:P);
D0 = 100;
gamma_h = 1;
gamma_l = 0.0;
% D0 = 300;
% gamma_h = 2;
% gamma_l = 1;
c = 1;
H = (gamma_h-gamma_l) * (1-exp(-c*((X-P/2-1).^2+(Y-P/2-1).^2)/(D0*D0))) + gamma_l;

% filtering
S = Z.*H;

figure(1),imshow(f,[]),title('f(x,y)')
figure(2),imshow(z,[]),title('z(x,y) = ln(f(x,y))')
figure(3),imshow(log(1+abs(F)),[]),title('|F(u,v)|')
figure(4),imshow(log(1+abs(Z)),[]),title('|Z(u,v)|')
figure(5),imshow(log(1+abs(S)),[]),title('|S(u,v)|')
figure(7),surf(X(1:10:end,1:10:end),Y(1:10:end,1:10:end),H(1:10:end,1:10:end)),title('H(u,v)')
figure(8),imshow(H,[]),title('H(u,v)')

sp = real(ifft2(ifftshift(S)));
s = sp(1:M,1:N);
g = exp(s)-1;
figure(5),imshow(g(5:end-5,5:end-5),[]),title('g(x,y)')