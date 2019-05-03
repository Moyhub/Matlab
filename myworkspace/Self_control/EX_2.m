num=[100];      %分子
num1=[4 100];
num2=[50 100];
num3=[2100000 14200000 20000000];
den=[0.001 0.11 1 0];  %分母
den1=[0.000004 0.00144 0.1104 1 0];
den2=[0.0085 0.936 8.61 1 0];
den3=[9 1892 108420 924000 200000 0];
g=tf(num,den);
g1=tf(num1,den1);
g2=tf(num2,den2);
g3=tf(num3,den3);
w=logspace(-3,4,260); %10的-1次方，到10的一次方，60份
bode(g,w,'r');          %bode图
hold on;
bode(g1,w,'b');
hold on;
bode(g2,w,'y');
hold on;
bode(g3,w,'g');

figure(2);
correction1=[0.04 1];
correction2=[0.5 1];
correction1_dividend=[0.004 1];
correction2_dividend=[8.5 1];
correction3=[21 142 200]
correction3_dividend=[9 902 200];
tr1=tf(correction1,correction1_dividend);
tr2=tf(correction2,correction2_dividend);
tr3=tf(correction3,correction3_dividend);
bode(tr1,w,'b');
hold on;
bode(tr2,w,'y');
hold on;
bode(tr3,w,'g');