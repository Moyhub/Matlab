f = imread('..\data\Fig0438(a)(bld_600by600).tif');
f = im2double(f);
[M, N] = size(f);

h = [-1 0 1; -2 0 2; -1 0 1];
g_spatial = imfilter(f, h);

figure(1),imshow(f,[]),ax=gca;
figure(2),imshow(g_spatial,[]),ax(end+1)=gca;

% pad
P = max([M N])+2;
fp = padarray(f,[P-M P-N],0,'post');
hp = zeros(P,P);
hp(P/2:P/2+2,P/2:P/2+2) = rot90(rot90(h));% convulution kernal

% DFT
[DX, DY] = meshgrid(0:P-1,0:P-1);
shift_matrix = (-ones(P,P)).^(DX+DY);
F = fft2(fp.*shift_matrix);
H = fft2(hp.*shift_matrix).*shift_matrix;
H = 1i*imag(H);
figure(3),surf(imag(H(1:20:end,1:20:end))),axis ij;
figure(4),imshow(imag(H),[]);
G = F.*H;
gp = real(ifft2(G)).*shift_matrix;
g = gp(1:M,1:N);
figure(5),imshow(g,[]),ax(end+1)=gca;
linkaxes(ax);

d = abs(g_spatial - g);
max(d(:))