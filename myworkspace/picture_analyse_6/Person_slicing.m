ImgPath = '3crop\';
ImgDir = dir([ImgPath,'*jpg']);

for k=1:length(ImgDir)
    img =imread([ImgPath,ImgDir(k).name]);
    img = im2double(img);
    img = img.^1.4;          %幂函数处理增强对比度
    img_hsv = rgb2hsv(img);
    h = img_hsv(:,:,1);
    s = img_hsv(:,:,2);
    v = img_hsv(:,:,3);
    for i = 1:size(h,1)
        for j = 1:size(h,2)
            if( h(i,j)>0.29 && h(i,j)<0.44 )
                img_hsv(i,j,2)=0;
                %img_hsv(i,j,3)=img_hsv(i,j,3)*1.2;
            end
        end
    end                      %在HSV平面进行处理
    img = hsv2rgb(img_hsv);  %转换回rgb图
    %背景图像置0(将图像分块),不同的块进行不同的处理
    img1 = img(1:270,:,:);
    img2 = img(271:590,:,:);
    img3 = img(590:size(img,1),:,:);

%%  
   for i = 1:size(img1,1)
        for j = 1:size(img1,2)
             if(img1(i,j,2)==img1(i,j,1) && img1(i,j,2)==img1(i,j,3) && img1(i,j,1) == img1(i,j,3) && img1(i,j,1)>0.2)
                 img1(i,j,1)=1;
                 img1(i,j,2)=1;
                 img1(i,j,3)=1;
             end
        end
   end
 %% 
   for i = 1:size(img2,1)
        for j = 1:size(img2,2)
             if(img2(i,j,2)==img2(i,j,1) && img2(i,j,2)==img2(i,j,3) && img2(i,j,1) == img2(i,j,3) && img2(i,j,1)>0.085)
                 img2(i,j,1)=1;
                 img2(i,j,2)=1;
                 img2(i,j,3)=1;
             end
        end
   end  
 %% 
   for i = 1:size(img3,1)
        for j = 1:size(img3,2)
             if((img3(i,j,1)==img3(i,j,2) && img3(i,j,2)==img3(i,j,3) &&img3(i,j,1)==img3(i,j,3) &&img3(i,j,3)<0.9  && img3(i,j,1)>0.1))
                   img3(i,j,1)=1;
                   img3(i,j,2)=1;
                   img3(i,j,3)=1;
             end
        end
   end
   img(1:270,:,:) = img1(:,:,:);
   img(271:590,:,:) = img2(:,:,:);
   img(590:size(img,1)-3,:,:)=img3(1:size(img3,1)-3,:,:);
   %去除一些黑边,增加美观度
   img(size(img,1)-2:size(img,1),:,:)=1;
   img(:,1:20,:)=1;
   img(:,size(img,2)-10:size(img,2),:)=1;
   %对图像进行平滑，去除毛刺
    w = fspecial('gaussian',[3,3],1);
   img = imfilter(img,w,'replicate');  
   img(:,:,1) = imresize(img(:,:,1),[size(img,1),size(img,2)],'nearest');%最近邻插值
   img(:,:,2) = imresize(img(:,:,2),[size(img,1),size(img,2)],'nearest');%最近邻插值
   img(:,:,3) = imresize(img(:,:,3),[size(img,1),size(img,2)],'nearest');%最近邻插值
    
    str = num2str(k,'%03d');
    imwrite(img,['result3\',str,'.jpg']);
   figure(5);
   imshow(img);
end
