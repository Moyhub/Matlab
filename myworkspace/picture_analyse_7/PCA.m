function [Evalues, Evectors, x_mean]=PCA(x)
% PCA using Single Value Decomposition主成分分析使用单值分解
% Obtaining mean vector, eigenvectors and eigenvalues 得到平均向量、特征向量和特征值
%
% [Evalues, Evectors, x_mean]=PCA(x);
%
% inputs,
%   X : M x N matrix with M the trainingvector length and N the number
%              of training data sets
%其中M为训练向量长度，N为训练数据集个数
% outputs,
%   Evalues : The eigen values of the data    %数据的特征值
%   Evector : The eigen vectors of the data   %数据的特征向量
%   x_mean : The mean training vector         %平均训练向量
%
%
s=size(x,2);
% Calculate the mean 
x_mean=sum(x,2)/s;

% Substract the mean
x2=(x-repmat(x_mean,1,s))/ sqrt(s-1);

% Do the SVD 
%[U2,S2] = svds(x2,s); 
[U2,S2] = svd(x2,0);   %奇异值分解

Evalues=diag(S2).^2;   
Evectors=bsxfun(@times,U2,sign(U2(1,:))); %对两个矩阵A和B之间的每一个元素进行指定的计算（函数fun指定）；并且具有自动扩维的作用