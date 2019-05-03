function [symbols, prob] = prob4huffman(x)
% Jianjiang Feng
% 2016-11-16
x = x(:);
symbols = unique(x);  %ɾ�������е��ظ�ֵ�����ѽ������������
[N,~] = histcounts(x,[symbols;symbols(end)+1]); %�������䣬N��ÿ�������Ԫ�ظ���
prob = N/numel(x);    %��Ԫ�ظ��������ص��Ǹ��ʺ�����