%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%�ó����Ƕ�Ƶ��ͼ�����˲�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fF = dis_Filter(Frequency,flag)

h = fspecial('gaussian',7);
fF = Frequency;
FrequencyPad = padarray(Frequency,[3,3]);
w = 71;
if(flag==1)
   validFrq = 4;  %Ƶ��ͼ��ȫ��Ҫ�Ĳ���
elseif(flag==2)
    validFrq = 25;
else
    validFrq = 20;
end
cycleslimit = 10;%%֮��ѭ��10�Σ���ֵҲ���Ե�
invalidFrq = sum(sum(Frequency<=0));%%��ЧƵ�ʵĿ���

cycles=0;%%�ۼӱ�־

while(((invalidFrq>0)&&cycles<cycleslimit)||cycles<cycleslimit)
  for i=1:w
    for j=1:w
        Blocks = FrequencyPad(i:i+6,j:j+6);%%ȡһ����9*9������
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
%Ƶ�ʳ����˲����ø�˹�˲�
f=fspecial('gaussian',7,3);
fF=imfilter(fF,f,'replicate');
end