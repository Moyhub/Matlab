function output = DFT_2(img)
   X=1:256;             %����һ��������
   C=exp(-2*pi*1i/256); %�����������
   output=(C.^(X'*X))*img*(C.^(X'*X)); %�㷨ʵ�֣����ͼ�����
end

