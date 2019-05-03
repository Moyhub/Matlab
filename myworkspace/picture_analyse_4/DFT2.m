function [ img_out ] = DFT2( f )
%   simple 2D DFT algorithm
%   realize DFT in vector method
size=256;%size of the pic
A=0:1:size-1;
adapter=ones(1,size);
x_2D=A'*adapter;
f=(-1).^(x_2D+x_2D').*f;%将直流成分居中
Wn=exp(-2*pi*1i/size);
img_out=zeros(size,size,2);
DFT_matrix=(Wn.^(A'*A))*f*(Wn.^(A'*A));
img_out(:,:,1)=abs(DFT_matrix);%算法的解释见实验报告
img_out(:,:,2)=angle(DFT_matrix);
end

