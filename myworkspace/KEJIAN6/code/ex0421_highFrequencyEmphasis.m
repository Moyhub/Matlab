%ex0421_highFrequencyEmphasis
f = imread('..\data\Fig0459(a)(orig_chest_xray).tif');
f = im2double(f);
[M,N] = size(f);
P = max(2*[M N]);% Padding size. 
F = fftshift(fft2(f,P,P));

D0=40;
H = 0.5+0.75*(1-glpf(D0,P));
G = H.*F;
g = real(ifft2(ifftshift(G)));
g = g(1:M,1:N);

H_hp = 1-glpf(D0,P);
G_hp = H_hp.*F;
g_hp = real(ifft2(ifftshift(G_hp)));
g_hp = g_hp(1:M,1:N);

close all
figure(1),imshow(f,[]);
figure(2),imshow(log(1+abs(F)),[]);
figure(3),mesh(H(1:5:end,1:5:end)),colormap('jet');
figure(4),imshow(H,[]);
figure(5),imshow(log(1+abs(G)),[]);
figure(6),imshow(g,[]);
g2 = histeq(g);
figure(7),imshow(g2);
figure(8),imshow(g_hp,[]);
% g3 = histeq(f);
% figure(8),imshow(g3);