f = imread('..\data\Fig0442(a)(characters_test_pattern).tif');
[M,N] = size(f);
P = max(2*[M N]);% Padding size. 

D0=30;
H = glpf(D0,P);

F = fftshift(fft2(f,P,P));
G = F.*H;
g = real(ifft2(ifftshift(G)));
g = g(1:M,1:N);

close all
figure(1),imshow(f,[]);
figure(2),imshow(log(1+abs(F)),[]);
figure(3),mesh(H(1:5:end,1:5:end)),colormap('default');
figure(4),imshow(H,[]);
figure(5),imshow(log(1+abs(G)),[]);
figure(6),imshow(g,[]);
