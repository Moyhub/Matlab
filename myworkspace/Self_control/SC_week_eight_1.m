num = [1];
den = [1,0,100];
g1 = tf(num,den);
figure(1);
nyquist(g1);%作出奈奎斯特图
num1 = 1;
den1 = conv([1,1,0],[1,1]);
g2 = tf(num1,den1);
figure(2);
nyquist(g2);
num3 = conv([0.2,1],[0.025,1]);
den3 = conv([0.005,1,0,0],[0.001,1]);
g3 = tf(num3,den3);
figure(3);
nyquist(g3);