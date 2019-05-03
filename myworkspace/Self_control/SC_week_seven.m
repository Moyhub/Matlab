%题目4.6
molucolar = [2.8];
denominator = [0.15,1,0];
g1 = tf(molucolar,denominator);
w1 = logspace(-2,2,360);
figure(1);
bode(g1,w1,'r');title("题目4.6");
%题目4.7
mol7 = [0.14,2.8];
den7 = [0.15,1,0];
g2 = tf(mol7,den7);
figure(2);
bode(g2,w1,'r');title("题目4.7-1");
mol7_1 = [14,2.8];
den7_1 = [0.15,1,0];
g3 = tf(mol7,den7);
figure(3);
bode(g3,w1,'r');title("题目4.7-2");
%题目4.9
mol9 = [8];
den9 = [1.25,1,0];
g4 = tf(mol9 , den9);
figure(4);
bode(g4,w1,'r');title("题目4.9");
%题目4.11
mol11 = [5];
den11 = [0.3,3.1,1,0];
g5 = tf(mol11 , den11);
figure(5);
bode(g5,w1,'r');title("题目4.11");
%题目4.11
mol16 = [40,0.8];
den16 = [2500,3005,506,1];
g6 = tf(mol16 , den16);
figure(6);
bode(g6,w1,'r');title("题目4.16");



