function imgchunk = imgchunk(img)
f = img;
[M,N] = size(f);
z = log(f+1);
P = 2*max([M N]);
zp = padarray(z,[P-M P-N],0,'post');
Z = fftshift(fft2(zp));
% filter
[X, Y] = meshgrid(1:P);
D0 = 40;
gamma_h =15;  %不断调整参数直至输出达到一个号的结果；
gamma_l = 0.99;

c = 1;
H = (gamma_h-gamma_l) * (1-exp(-c*((X-P/2-1).^2+(Y-P/2-1).^2)/(D0*D0))) + gamma_l;

S = Z.*H;
sp = real(ifft2(ifftshift(S)));
g = sp(1:M,1:N);
%g = Normalization (g,3);
 g =real(g.^0.17);
imgchunk = g;
end
