num=[16];      %����
den=[1 1 16];  %��ĸ
A=tf(num,den); %���ݺ���
num1=[16];
den1=[1 4.2 16];
B=tf(num1,den1);
t=0:0.01:10;
%u=t;г��ʱ
u=t.^0;
u(1,1)=0;%��Ծ���������ֵΪ0
[y]=lsim(A,u,t);
[y1]=lsim(B,u,t);
y=y';
y1=y1';
e=u-y;
e1=u-y1;
plot(t,e,'b');
hold on;
plot(t,e1,'r');
