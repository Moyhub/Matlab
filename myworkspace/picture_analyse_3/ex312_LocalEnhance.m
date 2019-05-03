% ex312_LocalEnhance
%
% 2018.10, 解释中间步骤

close all
I = imread('C:\Users\MacBook Air\Documents\大三上学期\数字图像处理\作业3\test.jpg');
I=rgb2gray(I);
%figure(1),imshow(I),set(gcf,'name','Original');

%% Global histogram equalization
J1 = histeq(I);                           %做直方图均衡
%figure(2),imshow(J1),set(gcf,'name','Global histogram equalization');      %再次显示图像

%% Enhancement using local histogram statistics
I = double(I);                         %计算时用double型，显示为unit8
mean_global = mean2(I);                %对整个图像求平均值
std_global = std2(I);                  %求标准差
fun1 = @(x) mean2(x);                  %获得函数句柄,         
tic;
mean_local =pingjun(I,[32,32]);
toc;
tic;
fun2 = @(x) std2(x);
std_local = fangcha(I,[32,32],mean_local); %引入均值矩阵和原矩阵，通过
toc;
