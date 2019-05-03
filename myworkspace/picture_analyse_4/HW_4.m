function varargout = HW_4(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HW_4_OpeningFcn, ...
                   'gui_OutputFcn',  @HW_4_OutputFcn, ...
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
function HW_4_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
end
function varargout = HW_4_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;


% --- Executes on slider movement.
end
function slider1_Callback(hObject, eventdata, handles)
end
function slider1_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
end

function radiobutton2_Callback(hObject, eventdata, handles)
%    X=(0:1:255)'*ones(1,256);
%    Y=X';
%    sigma=get(handles.slider15,'value');
%    img2=1/(2*pi*sigma*sigma)*exp(-1/2*(((X-128)/sigma).^2+((Y-128)/sigma).^2));
%    img2=img2/max(max(img2));
%    axes(handles.axes3);
%    imshow(img2);
end



% 正弦函数的参数1
function slider3_Callback(hObject, eventdata, handles)
    value1=get(handles.slider3,'value');
    value2=get(handles.slider8,'value');
    [v1,v2,v3]=sin_change(value1,value2);
    axes(handles.axes1);
    imshow(v1);
    axes(handles.axes11); 
    imshow(v2);
    axes(handles.axes12);
    imshow(v3);
    X=(0:1:255)'*ones(1,256);
    Y=X';
    axes(handles.axes15);
    mesh(X,Y,v1);
    axes(handles.axes16);
    mesh(X,Y,v2);
    axes(handles.axes17);
    mesh(X,Y,v3);
end
function slider3_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
end
%  设置正弦函数参数2
function slider8_Callback(hObject, eventdata, handles)
    value1=get(handles.slider3,'value');
    value2=get(handles.slider8,'value');
    [v1,v2,v3]=sin_change(value1,value2);
    axes(handles.axes1);
    imshow(v1);
    axes(handles.axes11); 
    imshow(v2);
    axes(handles.axes12);
    imshow(v3);
    X=(0:1:255)'*ones(1,256);
    Y=X';
    axes(handles.axes15);
    mesh(X,Y,v1);
    axes(handles.axes16);
    mesh(X,Y,v2);
    axes(handles.axes17);
    mesh(X,Y,v3);
end
function slider8_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
end
  
function slider9_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
end
% 矩形长宽比
function slider10_Callback(hObject, eventdata, handles)
    X=(0:1:255)'*ones(1,256);
    Y=X';
    length = get(handles.slider11,'value');
    center_x=get(handles.slider12,'value');
    center_y=get(handles.slider9,'value');
    dividend = get(handles.slider10,'value');
    angle=get(handles.slider13,'value');
    [v1,v2,v3]=rectangle_change(length,center_x,center_y,dividend,angle);
    axes(handles.axes2);
    imshow(v1);
    axes(handles.axes13);
    imshow(v2);
    axes(handles.axes14);
    imshow(v3);
    axes(handles.axes18);
    mesh(X,Y,v1);
    axes(handles.axes19);
    mesh(X,Y,v2);
    axes(handles.axes20);
    mesh(X,Y,v3);
end
    
function slider10_CreateFcn(hObject, eventdata, handles)  
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
end

% 矩形长度
function slider11_Callback(hObject, eventdata, handles)
    length = get(handles.slider11,'value');
    center_x=get(handles.slider12,'value');
    center_y=get(handles.slider9,'value');
    dividend = get(handles.slider10,'value');
    angle=get(handles.slider13,'value');
    [v1,v2,v3]=rectangle_change(length,center_x,center_y,dividend,angle);
    axes(handles.axes2);
    imshow(v1);
    axes(handles.axes13);
    imshow(v2);
    axes(handles.axes14);
    imshow(v3);
    X=(0:1:255)'*ones(1,256);
    Y=X';
    axes(handles.axes18);
    mesh(X,Y,v1);
    axes(handles.axes19);
    mesh(X,Y,v2);
    axes(handles.axes20);
    mesh(X,Y,v3);
end
function slider11_CreateFcn(hObject, eventdata, handles)  
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
end
% 矩形中心坐标
function slider12_Callback(hObject, eventdata, handles)
    X=(0:1:255)'*ones(1,256);
    Y=X';
    length = get(handles.slider11,'value');
    center_x=get(handles.slider12,'value');
    center_y=get(handles.slider9,'value');
    dividend = get(handles.slider10,'value');
    angle=get(handles.slider13,'value');
    [v1,v2,v3]=rectangle_change(length,center_x,center_y,dividend,angle);
    axes(handles.axes2);
    imshow(v1);
    axes(handles.axes13);
    imshow(v2);
    axes(handles.axes14);
    imshow(v3);
    axes(handles.axes18);
    mesh(X,Y,v1);
    axes(handles.axes19);
    mesh(X,Y,v2);
    axes(handles.axes20);
    mesh(X,Y,v3);
end
function slider12_CreateFcn(hObject, eventdata, handles)  
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
end
%矩形中心坐标
function slider9_Callback(hObject, eventdata, handles)
    X=(0:1:255)'*ones(1,256);
    Y=X';
    length = get(handles.slider11,'value');
    center_x=get(handles.slider12,'value');
    center_y=get(handles.slider9,'value');
    dividend = get(handles.slider10,'value');
    angle=get(handles.slider13,'value');
   [v1,v2,v3]=rectangle_change(length,center_x,center_y,dividend,angle);
    axes(handles.axes2);
    imshow(v1);
    axes(handles.axes13);
    imshow(v2);
    axes(handles.axes14);
    imshow(v3);
    axes(handles.axes18);
    mesh(X,Y,v1);
    axes(handles.axes19);
    mesh(X,Y,v2);
    axes(handles.axes20);
    mesh(X,Y,v3);
end
function radiobutton1_CreateFcn(hObject, eventdata, handles)
end

%矩形倾斜角度
function slider13_Callback(hObject, eventdata, handles)
    X=(0:1:255)'*ones(1,256);
    Y=X';
    length = get(handles.slider11,'value');
    center_x=get(handles.slider12,'value');
    center_y=get(handles.slider9,'value');
    dividend = get(handles.slider10,'value');
    angle=get(handles.slider13,'value');
    [v1,v2,v3]=rectangle_change(length,center_x,center_y,dividend,angle);
    axes(handles.axes2);
    imshow(v1);
    axes(handles.axes13);
    imshow(v2);
    axes(handles.axes14);
    imshow(v3);
    axes(handles.axes18);
    mesh(X,Y,v1);
    axes(handles.axes19);
    mesh(X,Y,v2);
    axes(handles.axes20);
    mesh(X,Y,v3);
end
function slider13_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
end

function radiobutton1_Callback(hObject, eventdata, handles)
%     img1=zeros(256,256);
%     img1(100:150,110:140)=1;
%     axes(handles.axes2);
%     imshow(img1);
end
function radiobutton3_Callback(hObject, eventdata, handles)
%    f = zeros(256,256);
%      for i=1:256
%          for j=1:256
%              f(i,j)=sin(0.4*i+0.4*j);
%          end
%      end
%      axes(handles.axes1);
%      imshow(f);
end


function slider15_Callback(hObject, eventdata, handles)
  X=(0:1:255)'*ones(1,256);
  Y=X';
  gauss_1=get(handles.slider15,'value');
  [v1,v2,v3,v4]=gauss(gauss_1);
  axes(handles.axes3);
  imshow(v1);
  axes(handles.axes4);
  imshow(v2);
  axes(handles.axes5);
  imshow(v3);
  axes(handles.axes6);
  mesh(X,Y,v1);
  axes(handles.axes7);
  mesh(X,Y,v2);
  axes(handles.axes8);
  mesh(X,Y,v4);
end
function slider15_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
end
