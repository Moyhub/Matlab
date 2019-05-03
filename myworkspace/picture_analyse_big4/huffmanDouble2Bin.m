function [y,bit_num] = huffmanDouble2Bin(x)
% Jianjiang Feng
% 2016-11-16
bit_num = length(x);
byte_num = ceil(bit_num/8);
pad_num = byte_num*8 - bit_num; %补充上四个元素以保证能够reshape
x = [x; zeros(pad_num,1)];
x = reshape(x,8,byte_num);
x = x';
x = num2str(x,'%d');
y = uint8(bin2dec(x)); %把二进制数转成十进制
y = y';