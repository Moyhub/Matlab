function img2 = medfilter(img1)
   [m1,n1,s1] = size(img1);%若无s1,这里的n1为3000，过不得一直出错
   img_padding = img1;
   for i = 2:size(img1,1)-2
       for j = 2:size(img1,2)-2
           imgr_temp = img_padding(i-1:i+1,j-1:j+1,1);
           imgg_temp = img_padding(i-1:i+1,j-1:j+1,2);
           imgb_temp = img_padding(i-1:i+1,j-1:j+1,3);
           intensity = imgr_temp+imgg_temp+imgb_temp;
           [A,index] = sort(intensity(:));
            if(imgr_temp(index(5))~=1 && imgg_temp(index(5))~=1 && imgb_temp(index(5))~=1)
                img_padding(i,j,1) = imgr_temp(index(5));
                img_padding(i,j,2) = imgg_temp(index(5));
                img_padding(i,j,3) = imgb_temp(index(5));
           else%去除一些中值滤波没有去除的噪声点
              img_padding(i,j,1) = imgr_temp(index(3));
              img_padding(i,j,2) = imgg_temp(index(3));
              img_padding(i,j,3) = imgb_temp(index(3));         
           end
       end
   end
   %去除边缘椒盐噪声
   img2(:,:,1) = img_padding(2:m1-1,2:n1-1,1);
   img2(:,:,2) = img_padding(2:m1-1,2:n1-1,2);
   img2(:,:,3) = img_padding(2:m1-1,2:n1-1,3);
   for i=2:size(img2,1)
       for j=1:size(img2,2)
           if(img2(i,j,1)==0 || img2(i,j,2)==0 ||img2(i,j,3) == 0)
               img2(i,j,1) = img2(i-1,j,1);
               img2(i,j,2) = img2(i-1,j,2);
               img2(i,j,3) = img2(i-1,j,3);
           end
       end
   end
end