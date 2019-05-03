
imgPath = 'C:\Users\MacBook Air\Documents\大三上学期\数字图像处理\作业2\';
imgDir = dir([imgPath ,'*.jpg']);

for i=1:length(imgDir)
    img =imread([imgPath,imgDir(i).name]);
    img_gray=rgb2gray(img);
    [m,n]=size(img_gray);
    a=1000./m;
    img_tran=imresize(img_gray,a,'bicubic'); %插值变换
    [x,y]=size(img_tran); 
    img_trans=im2double(img_tran);  
    A=randn(x,y);                          %生成高斯噪声
    img_gass = imlincomb(1,img_trans,1,A); %图像的叠加
    img_gass1 = mat2gray(img_gass);  %灰度线性拉伸
    %也可以采取max=double(max(max(img_gass)));img_gass1=img_gass/max
    figure(1);
    ax(1)= subplot(1,3,1);imshow(img_trans),title('I3');
    ax(2)= subplot(1,3,2);imshow(A),title('噪声图');
    ax(3)= subplot(1,3,3);imshow(img_gass),title('加入高斯噪声');
    linkaxes(ax,'x');
    str = num2str(i,'%01d');
    imwrite(img_gass1,[str,'.bmp'])
end
    
    

