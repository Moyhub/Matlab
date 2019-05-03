function [Evalues, Evectors, x_mean]=PCA(x)
% PCA using Single Value Decomposition���ɷַ���ʹ�õ�ֵ�ֽ�
% Obtaining mean vector, eigenvectors and eigenvalues �õ�ƽ����������������������ֵ
%
% [Evalues, Evectors, x_mean]=PCA(x);
%
% inputs,
%   X : M x N matrix with M the trainingvector length and N the number
%              of training data sets
%����MΪѵ���������ȣ�NΪѵ�����ݼ�����
% outputs,
%   Evalues : The eigen values of the data    %���ݵ�����ֵ
%   Evector : The eigen vectors of the data   %���ݵ���������
%   x_mean : The mean training vector         %ƽ��ѵ������
%
%
s=size(x,2);
% Calculate the mean 
x_mean=sum(x,2)/s;

% Substract the mean
x2=(x-repmat(x_mean,1,s))/ sqrt(s-1);

% Do the SVD 
%[U2,S2] = svds(x2,s); 
[U2,S2] = svd(x2,0);   %����ֵ�ֽ�

Evalues=diag(S2).^2;   
Evectors=bsxfun(@times,U2,sign(U2(1,:))); %����������A��B֮���ÿһ��Ԫ�ؽ���ָ���ļ��㣨����funָ���������Ҿ����Զ���ά������