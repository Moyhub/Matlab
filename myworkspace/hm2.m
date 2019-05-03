
imgPath = 'C:\Users\MacBook Air\Documents\������ѧ��\����ͼ����\��ҵ2\';
imgDir = dir([imgPath ,'*.jpg']);

for i=1:length(imgDir)
    img =imread([imgPath,imgDir(i).name]);
    img_gray=rgb2gray(img);
    [m,n]=size(img_gray);
    a=1000./m;
    img_tran=imresize(img_gray,a,'bicubic'); %��ֵ�任
    [x,y]=size(img_tran); 
    img_trans=im2double(img_tran);  
    A=randn(x,y);                          %���ɸ�˹����
    img_gass = imlincomb(1,img_trans,1,A); %ͼ��ĵ���
    img_gass1 = mat2gray(img_gass);  %�Ҷ���������
    %Ҳ���Բ�ȡmax=double(max(max(img_gass)));img_gass1=img_gass/max
    figure(1);
    ax(1)= subplot(1,3,1);imshow(img_trans),title('I3');
    ax(2)= subplot(1,3,2);imshow(A),title('����ͼ');
    ax(3)= subplot(1,3,3);imshow(img_gass),title('�����˹����');
    linkaxes(ax,'x');
    str = num2str(i,'%01d');
    imwrite(img_gass1,[str,'.bmp'])
end
    
    

