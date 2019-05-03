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
   %%  ��С���Ƕ�ͼƬ���ж�ȡ��Ԥ����
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %�����������ʱ������Ϊ����Ϊ��9*9������ʱ�����֮��û���غ�
     %������ֳ��ֺܶ�ϵ㣬�����WZQͬѧ��ָ���£������غ�һ���֣��õ��˽ϺõĽ��
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %��ȡͼƬʱ������
     img = imread('FTIR.bmp'); 
     axes(handles.axes1);               %��ʾͼƬ
     imshow(img);title('ԭͼ','fontname','����','Color','r','FontSize',16);
     flag = 1;          %ͼƬ��ʶ
     [m,n] = size(img); %����ͼ��ԭʼֵ
     img = imresize(img,[568,568],'bicubic'); 
     img = im2double(img);     %�м�װ����double�ͣ����ҽ���resize
     img_save = img;
     img2 = zeros(566,566);
     %��ʾ������ͼ��
     %��һ���������õ���ͼƬƽ��ֵ�뷽��
     img = Normalization (img,flag); 
    
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
                      if(distance(i,j) > 4)
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
    axes(handles.axes6);
    %��ʾ�õ���ZJWͬѧ��ָ��
    imshow(dis./max(max(dis)));title('Ƶ��ͼ','fontname','����','Color','r','FontSize',16');
    %��������ͼ
    state = lowpass_filter(state);  % ƽ������
    state1 = lowpass_filter(state1);
    %Ƶ����ͼ
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
    quiver(m,n,u,v,0.7);title('Ƶ����ͼ','fontname','����','Color','r','FontSize',16);
    set(gca,'ydir','reverse');
    if(flag==1)
      axis([0,81,0,81]);
    elseif(flag==2)
      axis([0,90,0,90]);
    else
      axis([0,90,0,90]);
    end        
    %directon(state,flag); 
    %������ͼ 
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
     quiver(m,n,u,v,0.7);title('������ͼ','fontname','����','Color','r','FontSize',16);
     set(gca,'ydir','reverse');
     if(flag==1)
       axis([0,81,0,81]);
     elseif(flag==2)
       axis([0,90,0,90]);
     else
       axis([0,90,0,90]);
     end
    %directon1(state1,flag);   
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
    axes(handles.axes7);
    imshow(img2);title('��ǿͼ','fontname','����','Color','r','FontSize',16);
end
function pushbutton2_Callback(hObject, eventdata, handles)
    img = imread('latent.bmp'); 
    axes(handles.axes2);                     %��ʾͼƬ
     imshow(img);
     flag = 2; 
     [m,n] = size(img); %����ͼ��ԭʼֵ
     img = imresize(img,[568,568],'bicubic'); 
     img = im2double(img);     %�м�װ����double�ͣ����ҽ���resize
     img_save = img;
     img2 = zeros(566,566);
     %��ʾ������ͼ��
     %��һ���������õ���ͼƬƽ��ֵ�뷽��
     img = Normalization (img,flag); 
     
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
                      if(distance(i,j) > 20 || distance(i,j)<1.5)
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
    axes(handles.axes10); 
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
    axes(handles.axes8);
   quiver(m,n,u,v,0.7);%title('Ƶ����ͼ');
   set(gca,'ydir','reverse');
   if(flag==1)
     axis([0,81,0,81]);
   elseif(flag==2)
     axis([0,81,0,81]);
   else
     axis([0,90,0,90]);
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
    axes(handles.axes11);
    %figure(1);
    imshow(img2);
end
function pushbutton3_Callback(hObject, eventdata, handles)

   %%  ��С���Ƕ�ͼƬ���ж�ȡ��Ԥ����
     img = imread('phone.bmp'); 
     flag = 3;
     [m1,n1] = size(img);  
     img = imresize(img,[568,568],'bicubic');  
     img = im2double(img);    
     img = imgchunk(img);
     img = im2double(img);     %�м�װ����double�ͣ����ҽ���resize
     img_save = img;
     img2 = zeros(566,566);
     %��ʾ������ͼ��
     %��һ���������õ���ͼƬƽ��ֵ�뷽��
%    img = Normalization (img,3); 
     axes(handles.axes3);                     %��ʾͼƬ
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
    axes(handles.axes14);
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
    axes(handles.axes15) ; 
   % figure(1);
    imshow(img2);  
end

function axes1_CreateFcn(hObject, eventdata, handles)
   %����������
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
