imgPath = 'C:\Users\MacBook Air\Documents\������ѧ��\����ͼ����\��ҵ3\background\';
IMGPATH = 'C:\Users\MacBook Air\Documents\������ѧ��\����ͼ����\��ҵ3\frontground\';
imgDir = dir([imgPath ,'*.jpg']);
IMGDIR = dir([IMGPATH ,'*.jpg']); 
for i=1:length(imgDir)
    img =imread([imgPath,imgDir(i).name]);
    img_gray=rgb2gray(img);
    sigma=10;
    gausFilter=fspecial('gaussian',[500,500],sigma);      %��˹�˲�
    img_gauss=imfilter(img_gray,gausFilter,'replicate');  %�趨�˲�ģʽ
    IMG =imread ([IMGPATH,IMGDIR(i).name]);               %��ȡǰ��
    IMG_gray=rgb2gray(IMG);                            
    img_gass = imlincomb(1,img_gauss,1,IMG_gray);         %ͼ�����
    str = num2str(i,'%01d');
    imwrite(img_gass,[str,'.bmp']);
end
    