disp('方法一：使用MATLAB的for循环')
disp('针对10')
tic;
%可以使用初始化分配以提高效率
  for i=1:1:10
      for j=1:1:10
          H(i,j) = 1./(i+j-1);
      end
  end
toc;
disp('针对100')
tic;
 for i=1:1:100
      for j=1:1:100
          H1(i,j) = 1./(i+j-1);
      end
  end
toc;
disp('针对1000')
tic;
 for i=1:1:1000
      for j=1:1:1000
          H2(i,j) = 1./(i+j-1);
      end
  end
toc;

disp('方法二：使用matlab向量化方式')
disp('针对10')
tic;
[i,j] =  meshgrid(1:10,1:10);
value = 1./(i+j-1);
toc;

disp('针对100')
tic;
[i,j] =  meshgrid(1:100,1:100);
value1 = 1./(i+j-1);
toc;

disp('针对1000')
tic;
[i,j] =  meshgrid(1:1000,1:1000);
value2 = 1./(i+j-1);
toc;

 disp('方法三：使用Mex方式')
 disp('针对10')
 mex hm1_2.cpp '-g';
 tic;
 G = ones(10);
 hm1_2(G);
 toc;
 disp('针对100')
 mex hm1_2.cpp '-g'; 
 tic;
 G = ones(100);
 hm1_2(G);
 toc;
 disp('针对1000')
 mex hm1_2.cpp '-g';
 tic;
 G = ones(1000);
 hm1_2(G);
 toc;

  