        
   %%  该小节是对图片进行读取和预处理
     img = imread('C:\Users\MacBook Air\Documents\大三上学期\数字图像处理\综合作业1\phone.bmp'); 
     flag = 3;
     [m1,n1] = size(img);  
     img = imresize(img,[568,568],'bicubic');  
     img = im2double(img);    
     img = imgchunk(img);
%      imgchunk1 = img(1:394,1:212);
%      imgchunk2 = img(1:394,212:568);
%      imgchunk3 = img(394:568,:);
%      imgchunk(imgchunk3,0.8,0.5);
%      imgchunk(imgchunk2,1.6,0.5);
%      imgchunk(imgchunk1,);
     img = im2double(img);     %切记装换成double型，并且将其resize
     img_save = img;
     img2 = zeros(566,566);
     %显示欲处理图像
     %归一化处理计算得到的图片平均值与方差
%      img = Normalization (img,3); 
     figure(1);                         %显示图片
     imshow(img);
     img = img - mean(img(:));          %为了提取傅里叶，先去掉直流
     imgpadding = padarray(img,[12,12]);%给原图扩充
%%   元胞操作使用得到了室友ZJW的帮助  分块操作
     chunks = cell(81,81);
     chunks_padarray = cell(81,81);
     for i=1:81
        for j=1:81  
            chunks{i,j} = img(1+(i-1)*7:8+(i-1)*7 , 1+(j-1)*7:8+(j-1)*7);
            chunks_padarray{i,j} = imgpadding(1+(i-1)*7:32+(i-1)*7 , 1+(j-1)*7:32+7*(j-1));
        end
     end
 %% 频域方向图、空域方向图、以及频率图
     chunksDFT = cell(81,81);
     chunkshigh = cell(81,81);
     state = zeros(81);   %频域方向图
     state1 = zeros(81);  %空域方向图
     distance = zeros(81);
     dis =zeros(81);      %频率图
     flagjudge = ones(81);     %判断是否为指纹区域
     grads = gradients(img_save);   %梯度图，带入一个大图
 %%  求出方向图，频率图，距离
     for i = 1:81
         for j = 1:81
             chunksDFT{i,j} = fftshift(fft2(  chunks_padarray{i,j}  ));
             chunkshigh{i,j} = abs(chunksDFT{i,j});
             [x,y] = sort(chunkshigh{i,j}(:),'descend'); 
             for k = 1:7 %取出前7个分量，找到其峰值所在
                 [x1,y1] = ind2sub(size(chunks_padarray{i,j}),y(k));
                 [x2,y2] = ind2sub(size(chunks_padarray{i,j}),y(k+1));
                 if(chunkshigh{i,j}(x1,y1) == chunkshigh{i,j}(x2,y2) && ((x1+x2)/2==17&&(y1+y2)/2==17))
                      distance(i,j) = sqrt (((x1-x2)/2).^2 + ((y1-y2)/2).^2 );   %求出峰值点之间的距离
                      dis(i,j) = distance(i,j)/32;
                      state(i,j) =0.5*pi + atan2( (x1-x2),(y1-y2) );
                      if(distance(i,j) > 4 )
                          distance(i,j) = 0;
                          dis(i,j) = -1;
                          state(i,j) = 2*pi;
                      end
                      break;  %一旦找到一组峰值点，则退出
                  end
             end
         end
     end
 %%  空域方向图
     for i=1:81
         for j=1:81
             if(distance(i,j) == 0)
                 state1(i,j) = 2*pi;
             else
                 state1(i,j) =mean(mean(grads(1+(i-1)*7:8+(i-1)*7,1+(j-1)*7:8+(j-1)*7)));
             end
         end
     end
%% 空域方向图，频域方向图，频率图的平滑和显示
    dis=dis_Filter(dis,flag);%内容包括插值和滤波    
    %画出频率图
    figure(5); 
    imshow(dis./max(max(dis)));
    %画出方向图
    state = lowpass_filter(state);  % 平滑操作
    state1 = lowpass_filter(state1);
    
   if(flag == 1)
   m = 1:2:81;
   n = 1:2:81;
   elseif(flag == 2)
   m = 1:2:81;
   n = 1:2:81;
   else
    m = 1:2:81;
    n = 1:2:81;
   end
   u=cos(state(m,n));
   v=sin(state(m,n));
   figure(2);
   quiver(m,n,u,v,0.7);title('频域方向图');
   set(gca,'ydir','reverse');
   if(flag==1)
     axis([0,81,0,81]);
   elseif(flag==2)
     axis([0,81,0,81]);
   else
     axis([0,81,0,81]);
   end        
    
   % im = directon(state,flag);  %频域方向图
   if(flag == 1)
     m = 1:2:81;
     n = 1:2:81;
    elseif(flag == 2)
     m = 1:2:81;
     n = 1:2:81;
    else
      m = 1:2:81;
      n = 1:2:81;
    end
     u=cos(state(m,n));
     v=sin(state(m,n));
     figure(3);
    % axes(handles.axes5);
     quiver(m,n,u,v,0.7);title('空域方向图');
     set(gca,'ydir','reverse');
     if(flag==1)
       axis([0,81,0,81]);
     elseif(flag==2)
       axis([0,81,0,81]);
     else
       axis([0,81,0,81]);
     end
   % directon1(state1,flag); %空域方向图   
%% 解得gabor滤波器
   gabor = cell(81,81);
   for i = 1:81
       for j = 1:81 
           if(dis(i,j)<=0)
               gabor{i,j} = zeros(11);
           else
               gabor{i,j} = gaborfilter(0.5*pi-state(i,j),dis(i,j));
           end
       end
   end
 %%  滤波
   for i = 1:566
         for j = 1:566
             if(dis(floor((i+6)/7),floor((j+6)/7)) >0)
                 s = imgpadding(i+13-5:i+13+5,j+13-5:j+13+5).*gabor{floor((i+6)/7),floor((j+6)/7)};
                 img2(i,j) =sum(sum(s));
             else
                 img2(i,j) = 255;
             end
         end
   end
    img2 = 1- img2;
    img2 = imresize(img2,[m1,n1+110],'bicubic'); %突出显示效果，调整一下长宽
    figure(6); 
    imshow(img2);  