function output = DFT_2(img)
   X=1:256;             %构建一个基向量
   C=exp(-2*pi*1i/256); %常数单独提出
   output=(C.^(X'*X))*img*(C.^(X'*X)); %算法实现，解释见报告
end

