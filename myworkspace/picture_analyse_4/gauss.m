function [output1,output2,output3,output4] = gauss(sigma)
   X=1:1:256;
   Y=X';
   img2=1/(2*pi*sigma*sigma)*exp(-1/2*(((X-128)/sigma).^2+((Y-128)/sigma).^2));
   img1=img2/max(max(img2));
   f=DFT_2(img1);
   f=fftshift(f);                 %ʹ����Ҷ�任�����ı�Ϊͼ������
   img3=log(abs(f));              %����
   img4=(angle(f)*180/pi);        %��λ
   img5=angle(f);
   output1=img1;
   output2=img3;
   output3=img4;
   output4=img5;
end