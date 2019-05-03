        
   %%  ��С���Ƕ�ͼƬ���ж�ȡ��Ԥ����
     img = imread('C:\Users\MacBook Air\Documents\������ѧ��\����ͼ����\�ۺ���ҵ1\phone.bmp'); 
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
     img = im2double(img);     %�м�װ����double�ͣ����ҽ���resize
     img_save = img;
     img2 = zeros(566,566);
     %��ʾ������ͼ��
     %��һ���������õ���ͼƬƽ��ֵ�뷽��
%      img = Normalization (img,3); 
     figure(1);                         %��ʾͼƬ
     imshow(img);
     img = img - mean(img(:));          %Ϊ����ȡ����Ҷ����ȥ��ֱ��
     imgpadding = padarray(img,[12,12]);%��ԭͼ����
%%   Ԫ������ʹ�õõ�������ZJW�İ���  �ֿ����
     chunks = cell(81,81);
     chunks_padarray = cell(81,81);
     for i=1:81
        for j=1:81  
            chunks{i,j} = img(1+(i-1)*7:8+(i-1)*7 , 1+(j-1)*7:8+(j-1)*7);
            chunks_padarray{i,j} = imgpadding(1+(i-1)*7:32+(i-1)*7 , 1+(j-1)*7:32+7*(j-1));
        end
     end
 %% Ƶ����ͼ��������ͼ���Լ�Ƶ��ͼ
     chunksDFT = cell(81,81);
     chunkshigh = cell(81,81);
     state = zeros(81);   %Ƶ����ͼ
     state1 = zeros(81);  %������ͼ
     distance = zeros(81);
     dis =zeros(81);      %Ƶ��ͼ
     flagjudge = ones(81);     %�ж��Ƿ�Ϊָ������
     grads = gradients(img_save);   %�ݶ�ͼ������һ����ͼ
 %%  �������ͼ��Ƶ��ͼ������
     for i = 1:81
         for j = 1:81
             chunksDFT{i,j} = fftshift(fft2(  chunks_padarray{i,j}  ));
             chunkshigh{i,j} = abs(chunksDFT{i,j});
             [x,y] = sort(chunkshigh{i,j}(:),'descend'); 
             for k = 1:7 %ȡ��ǰ7���������ҵ����ֵ����
                 [x1,y1] = ind2sub(size(chunks_padarray{i,j}),y(k));
                 [x2,y2] = ind2sub(size(chunks_padarray{i,j}),y(k+1));
                 if(chunkshigh{i,j}(x1,y1) == chunkshigh{i,j}(x2,y2) && ((x1+x2)/2==17&&(y1+y2)/2==17))
                      distance(i,j) = sqrt (((x1-x2)/2).^2 + ((y1-y2)/2).^2 );   %�����ֵ��֮��ľ���
                      dis(i,j) = distance(i,j)/32;
                      state(i,j) =0.5*pi + atan2( (x1-x2),(y1-y2) );
                      if(distance(i,j) > 4 )
                          distance(i,j) = 0;
                          dis(i,j) = -1;
                          state(i,j) = 2*pi;
                      end
                      break;  %һ���ҵ�һ���ֵ�㣬���˳�
                  end
             end
         end
     end
 %%  ������ͼ
     for i=1:81
         for j=1:81
             if(distance(i,j) == 0)
                 state1(i,j) = 2*pi;
             else
                 state1(i,j) =mean(mean(grads(1+(i-1)*7:8+(i-1)*7,1+(j-1)*7:8+(j-1)*7)));
             end
         end
     end
%% ������ͼ��Ƶ����ͼ��Ƶ��ͼ��ƽ������ʾ
    dis=dis_Filter(dis,flag);%���ݰ�����ֵ���˲�    
    %����Ƶ��ͼ
    figure(5); 
    imshow(dis./max(max(dis)));
    %��������ͼ
    state = lowpass_filter(state);  % ƽ������
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
   quiver(m,n,u,v,0.7);title('Ƶ����ͼ');
   set(gca,'ydir','reverse');
   if(flag==1)
     axis([0,81,0,81]);
   elseif(flag==2)
     axis([0,81,0,81]);
   else
     axis([0,81,0,81]);
   end        
    
   % im = directon(state,flag);  %Ƶ����ͼ
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
     quiver(m,n,u,v,0.7);title('������ͼ');
     set(gca,'ydir','reverse');
     if(flag==1)
       axis([0,81,0,81]);
     elseif(flag==2)
       axis([0,81,0,81]);
     else
       axis([0,81,0,81]);
     end
   % directon1(state1,flag); %������ͼ   
%% ���gabor�˲���
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
 %%  �˲�
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
    img2 = imresize(img2,[m1,n1+110],'bicubic'); %ͻ����ʾЧ��������һ�³���
    figure(6); 
    imshow(img2);  