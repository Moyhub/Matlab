function output = pingjun(A,fliter)  %����������㣬�����Ǻ������������
%���㷨�õ����ż���ͬѧ�İ���

law_h=fliter(1);                     %ȡ������������
law_l=fliter(2);                     %ȡ������������
[m,n]=size(A);
A_enlarge_one=zeros(m+law_h-1,n+law_l-1);
A_enlarge_one(floor((law_h-1)/2)+1:m+(floor((law_h-1)/2)),floor((law_l-1)/2)+1:n+floor((law_l-1)/2))=A;
A=A_enlarge_one;
A=double(A);
[m,n]=size(A);
B=zeros(m,n);

for i=1:1:m
    for j=1:1:n
        if(i==1&&j==1)
            B(i,j)=A(i,j);
        elseif(i==1&&j~=1)
            B(i,j)=A(i,j)+B(i,j-1);
        elseif(i~=1&&j==1)
            B(i,j)=A(i,j)+B(i-1,j);
        else
            B(i,j)=B(i,j-1)+B(i-1,j)-B(i-1,j-1)+A(i,j);  %������ʦ�Ͽεķ��������һ���;���
        end
    end
end
A_enlarge=zeros(m+1,n+1);
A_enlarge(2:end,2:end)=B;
% �Եõ��ľ�����н�һ����չ
for i=1:(m-law_h+1)
    for j=1:(n-law_l+1)
        output(i,j)=(A_enlarge(i+law_h,j+law_l)-A_enlarge(i+law_h,j)-A_enlarge(i,j+law_l)+A_enlarge(i,j))/(law_h*law_l);
    end
end
end