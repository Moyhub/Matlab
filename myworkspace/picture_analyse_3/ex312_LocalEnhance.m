% ex312_LocalEnhance
%
% 2018.10, �����м䲽��

close all
I = imread('C:\Users\MacBook Air\Documents\������ѧ��\����ͼ����\��ҵ3\test.jpg');
I=rgb2gray(I);
%figure(1),imshow(I),set(gcf,'name','Original');

%% Global histogram equalization
J1 = histeq(I);                           %��ֱ��ͼ����
%figure(2),imshow(J1),set(gcf,'name','Global histogram equalization');      %�ٴ���ʾͼ��

%% Enhancement using local histogram statistics
I = double(I);                         %����ʱ��double�ͣ���ʾΪunit8
mean_global = mean2(I);                %������ͼ����ƽ��ֵ
std_global = std2(I);                  %���׼��
fun1 = @(x) mean2(x);                  %��ú������,         
tic;
mean_local =pingjun(I,[32,32]);
toc;
tic;
fun2 = @(x) std2(x);
std_local = fangcha(I,[32,32],mean_local); %�����ֵ�����ԭ����ͨ��
toc;
