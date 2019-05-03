function [symbols, prob] = prob4huffman(x)
% Jianjiang Feng
% 2016-11-16
x = x(:);
symbols = unique(x);  %删除向量中的重复值，并把结果按升序排序
[N,~] = histcounts(x,[symbols;symbols(end)+1]); %划分区间，N是每个区间的元素个数
prob = N/numel(x);    %求元素个数，返回的是概率和区间