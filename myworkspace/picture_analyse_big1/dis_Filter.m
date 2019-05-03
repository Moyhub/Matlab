%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%该程序是对频率图进行滤波
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fF = dis_Filter(Frequency,flag)

h = fspecial('gaussian',7);
fF = Frequency;
FrequencyPad = padarray(Frequency,[3,3]);
w = 71;
if(flag==1)
   validFrq = 4;  %频率图补全重要的参数
elseif(flag==2)
    validFrq = 25;
else
    validFrq = 20;
end
cycleslimit = 10;%%之多循环10次，此值也可以调
invalidFrq = sum(sum(Frequency<=0));%%无效频率的块数

cycles=0;%%累加标志

while(((invalidFrq>0)&&cycles<cycleslimit)||cycles<cycleslimit)
  for i=1:w
    for j=1:w
        Blocks = FrequencyPad(i:i+6,j:j+6);%%取一个快9*9的领域
        msk = (Blocks>0);
        if(sum(sum(msk))>=validFrq)
            Blocks = Blocks.*msk;
            fF(i,j)=sum(sum(Blocks.*h))/sum(sum(h.*msk));
        else
            fF(i,j)=-1;
        end
    end
  end  
  Frequency=fF;
  invalidFrq=sum(sum(Frequency<=0));
  cycles = cycles+1;
end
%频率场的滤波，用高斯滤波
f=fspecial('gaussian',7,3);
fF=imfilter(fF,f,'replicate');
end