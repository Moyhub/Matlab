function [output,output1,output2]=sin_change(x,y)
     X=1:1:256;
     Y=X';
    % f=Y.*X;
     f=sin(0.2*x*X+0.2*y*Y);
     output=f;
     f1=fftshift(DFT_2(f));
     f1=log(abs(f1));
     output1=f1;
     f2=angle(f1);
     output2=f2;
end
