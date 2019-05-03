function x = huffmanBin2Double(y,bit_num)
% Jianjiang Feng
% 2016-11-16
x = dec2bin(y,8);  %转成二进制
x = x';
x = double(x(1:bit_num))-48; %ASCII编码-48
