disp('����һ��ʹ��MATLAB��forѭ��')
disp('���10')
tic;
%����ʹ�ó�ʼ�����������Ч��
  for i=1:1:10
      for j=1:1:10
          H(i,j) = 1./(i+j-1);
      end
  end
toc;
disp('���100')
tic;
 for i=1:1:100
      for j=1:1:100
          H1(i,j) = 1./(i+j-1);
      end
  end
toc;
disp('���1000')
tic;
 for i=1:1:1000
      for j=1:1:1000
          H2(i,j) = 1./(i+j-1);
      end
  end
toc;

disp('��������ʹ��matlab��������ʽ')
disp('���10')
tic;
[i,j] =  meshgrid(1:10,1:10);
value = 1./(i+j-1);
toc;

disp('���100')
tic;
[i,j] =  meshgrid(1:100,1:100);
value1 = 1./(i+j-1);
toc;

disp('���1000')
tic;
[i,j] =  meshgrid(1:1000,1:1000);
value2 = 1./(i+j-1);
toc;

 disp('��������ʹ��Mex��ʽ')
 disp('���10')
 mex hm1_2.cpp '-g';
 tic;
 G = ones(10);
 hm1_2(G);
 toc;
 disp('���100')
 mex hm1_2.cpp '-g'; 
 tic;
 G = ones(100);
 hm1_2(G);
 toc;
 disp('���1000')
 mex hm1_2.cpp '-g';
 tic;
 G = ones(1000);
 hm1_2(G);
 toc;

  