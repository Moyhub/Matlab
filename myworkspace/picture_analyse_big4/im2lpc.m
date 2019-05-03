function Y = im2lpc(X, f)
%IM2LPC 对图像做1-D linear predictive coding 一维线性预测编码
% 2016-11-16
% reference: mat2lpc.m in DIPUM

if nargin<2             %根据输入变量的个数来执行不同的功能
    f = 1; % default: previous pixel coding
end

X = double(X);
[M, N] = size(X);
P = zeros(M,N);

Xs = X;
for j = 1:length(f)
    Xs = [zeros(M,1) Xs(:,1:end-1)];
    P = P + f(j) * Xs;
end
Y = X - round(P);