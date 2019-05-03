imgPath = 'C:\Users\MacBook Air\Documents\大三上学期\数字图像处理\作业3\background\';
IMGPATH = 'C:\Users\MacBook Air\Documents\大三上学期\数字图像处理\作业3\frontground\';
imgDir = dir([imgPath ,'*.jpg']);
IMGDIR = dir([IMGPATH ,'*.jpg']); 
for i=1:length(imgDir)
    img =imread([imgPath,imgDir(i).name]);
    img_gray=rgb2gray(img);
    sigma=10;
    gausFilter=fspecial('gaussian',[500,500],sigma);      %高斯滤波
    img_gauss=imfilter(img_gray,gausFilter,'replicate');  %设定滤波模式
    IMG =imread ([IMGPATH,IMGDIR(i).name]);               %读取前景
    IMG_gray=rgb2gray(IMG);                            
    img_gass = imlincomb(1,img_gauss,1,IMG_gray);         %图像叠加
    str = num2str(i,'%01d');
    imwrite(img_gass,[str,'.bmp']);
end
    