function varargout = interactive(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @interactive_OpeningFcn, ...
                   'gui_OutputFcn',  @interactive_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
end
function interactive_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes interactive wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end
function varargout = interactive_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

end
function pushbutton1_Callback(hObject, eventdata, handles)
   %%  该小节是对图片进行读取和预处理
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %在我最初做的时候，我认为方块为；9*9，处理时块与块之间没有重合
     %结果发现出现很多断点，最后在WZQ同学的指点下，将块重合一部分，得到了较好的结果
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %读取图片时单引号
     img = imread('FTIR.bmp'); 
     axes(handles.axes1);               %显示图片
     imshow(img);title('原图','fontname','楷体','Color','r','FontSize',16);
     flag = 1;          %图片标识
     [m,n] = size(img); %保存图像原始值
     img = imresize(img,[568,568],'bicubic'); 
     img = im2double(img);     %切记装换成double型，并且将其resize
     img_save = img;
     img2 = zeros(566,566);
     %显示欲处理图像
     %归一化处理计算得到的图片平均值与方差
     img = Normalization (img,flag); 
    
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
                      if(distance(i,j) > 4)
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
    axes(handles.axes6);
    %显示得到了ZJW同学的指点
    imshow(dis./max(max(dis)));title('频率图','fontname','楷体','Color','r','FontSize',16');
    %画出方向图
    state = lowpass_filter(state);  % 平滑操作
    state1 = lowpass_filter(state1);
    %频域方向图
    if(flag == 1)
    m = 1:2:81;
    n = 1:2:81;
    elseif(flag == 2)
    m = 1:2:90;
    n = 1:2:90;
    else
    m = 1:1:90;
    n = 1:1:90;
    end
    u=cos(state(m,n));
    v=sin(state(m,n));
    axes(handles.axes4);
    quiver(m,n,u,v,0.7);title('频域方向图','fontname','楷体','Color','r','FontSize',16);
    set(gca,'ydir','reverse');
    if(flag==1)
      axis([0,81,0,81]);
    elseif(flag==2)
      axis([0,90,0,90]);
    else
      axis([0,90,0,90]);
    end        
    %directon(state,flag); 
    %空域方向图 
    if(flag == 1)
     m = 1:2:81;
     n = 1:2:81;
    elseif(flag == 2)
     m = 1:1:90;
     n = 1:1:90;
    else
      m = 1:1:90;
      n = 1:1:90;
    end
     u=cos(state1(m,n));
     v=sin(state1(m,n));
     axes(handles.axes5);
     quiver(m,n,u,v,0.7);title('空域方向图','fontname','楷体','Color','r','FontSize',16);
     set(gca,'ydir','reverse');
     if(flag==1)
       axis([0,81,0,81]);
     elseif(flag==2)
       axis([0,90,0,90]);
     else
       axis([0,90,0,90]);
     end
    %directon1(state1,flag);   
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
    axes(handles.axes7);
    imshow(img2);title('增强图','fontname','楷体','Color','r','FontSize',16);
end
function pushbutton2_Callback(hObject, eventdata, handles)
    img = imread('latent.bmp'); 
    axes(handles.axes2);                     %显示图片
     imshow(img);
     flag = 2; 
     [m,n] = size(img); %保存图像原始值
     img = imresize(img,[568,568],'bicubic'); 
     img = im2double(img);     %切记装换成double型，并且将其resize
     img_save = img;
     img2 = zeros(566,566);
     %显示欲处理图像
     %归一化处理计算得到的图片平均值与方差
     img = Normalization (img,flag); 
     
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
                      if(distance(i,j) > 20 || distance(i,j)<1.5)
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
    axes(handles.axes10); 
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
    axes(handles.axes8);
   quiver(m,n,u,v,0.7);%title('频域方向图');
   set(gca,'ydir','reverse');
   if(flag==1)
     axis([0,81,0,81]);
   elseif(flag==2)
     axis([0,81,0,81]);
   else
     axis([0,90,0,90]);
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
     u=cos(state1(m,n));
     v=sin(state1(m,n));
     axes(handles.axes9);
     quiver(m,n,u,v,0.7);
     set(gca,'ydir','reverse');
     if(flag==1)
       axis([0,81,0,81]);
     elseif(flag==2)
       axis([0,81,0,81]);
     else
       axis([0,90,0,90]);
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
    axes(handles.axes11);
    %figure(1);
    imshow(img2);
end
function pushbutton3_Callback(hObject, eventdata, handles)

   %%  该小节是对图片进行读取和预处理
     img = imread('phone.bmp'); 
     flag = 3;
     [m1,n1] = size(img);  
     img = imresize(img,[568,568],'bicubic');  
     img = im2double(img);    
     img = imgchunk(img);
     img = im2double(img);     %切记装换成double型，并且将其resize
     img_save = img;
     img2 = zeros(566,566);
     %显示欲处理图像
     %归一化处理计算得到的图片平均值与方差
%    img = Normalization (img,3); 
     axes(handles.axes3);                     %显示图片
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
    axes(handles.axes14);
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
   axes(handles.axes12) 
   quiver(m,n,u,v,0.7);
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
     axes(handles.axes13);
     quiver(m,n,u,v,0.7);
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
    axes(handles.axes15) ; 
   % figure(1);
    imshow(img2);  
end

function axes1_CreateFcn(hObject, eventdata, handles)
   %隐藏坐标轴
   set(hObject,'xTick',[]);
   set(hObject,'ytick',[]);
   set(hObject,'box','on');
end
function axes2_CreateFcn(hObject, eventdata, handles)
   set(hObject,'xTick',[]);
   set(hObject,'ytick',[]);
   set(hObject,'box','on');
end
function axes3_CreateFcn(hObject, eventdata, handles)
   set(hObject,'xTick',[]);
   set(hObject,'ytick',[]);
   set(hObject,'box','on');
end
function edit1_Callback(hObject, eventdata, handles)
   
end
function edit1_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
function axes4_CreateFcn(hObject, eventdata, handles)
   set(hObject,'xTick',[]);
   set(hObject,'ytick',[]);
   set(hObject,'box','on');
end

function axes5_CreateFcn(hObject, eventdata, handles)
   set(hObject,'xTick',[]);
   set(hObject,'ytick',[]);
   set(hObject,'box','on');
end
function axes8_CreateFcn(hObject, eventdata, handles)
   set(hObject,'xTick',[]);
   set(hObject,'ytick',[]);
   set(hObject,'box','on');
end
function axes9_CreateFcn(hObject, eventdata, handles)
   set(hObject,'xTick',[]);
   set(hObject,'ytick',[]);
   set(hObject,'box','on');
end


function axes12_CreateFcn(hObject, eventdata, handles)
   set(hObject,'xTick',[]);
   set(hObject,'ytick',[]);
   set(hObject,'box','on');
end


function axes13_CreateFcn(hObject, eventdata, handles)
  set(hObject,'xTick',[]);
   set(hObject,'ytick',[]);
   set(hObject,'box','on');
end
