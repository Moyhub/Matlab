% num = 100*conv([1,1],[0.5657,1]);
% gh = conv([1,0],conv([0.5,1],conv([0.1,1],conv([12,1],[0.017,1]))));
% margin(num,gh);
% %fprintf('p = %3.2f\n',p);  方程保留位数

% num = 10*conv([24.01,1],[58.8,1]);
% gh = conv([1,0],conv([1,1],conv([2,1],conv([1.49,1],[635.04,1]))));
% margin(num,gh);

num = 100*conv([0.414,1],[1,1])
gh = conv([1,0],conv([0.1,1],conv([0.5,1],conv([6,1],[0.023,1]))));
bode(num,gh);
margin(num,gh);

% num = 10
% gh = conv([1,0],conv([1,1],[2,1]));
% margin(num,gh);