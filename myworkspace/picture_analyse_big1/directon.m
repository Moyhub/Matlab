function output = directon(state,flag)
if(flag == 1)
   m = 1:2:81;
   n = 1:2:81;
elseif(flag == 2)
   m = 1:2:90;
   n = 1:2:90;
else
    m = 1:1:90;
    n = 1:1:90;
end
   u=cos(state(m,n));
   v=sin(state(m,n));
   output = quiver(m,n,u,v,0.7);title('ÆµÓò·½ÏòÍ¼');
   set(gca,'ydir','reverse');
   if(flag==1)
     axis([0,81,0,81]);
   elseif(flag==2)
     axis([0,90,0,90]);
   else
     axis([0,90,0,90]);
   end      
end
   