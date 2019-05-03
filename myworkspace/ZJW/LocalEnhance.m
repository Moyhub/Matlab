function enI = LocalEnhance(I)
mI = mean2(I);
sI = std2(I);

fun1 = @(x) mean2(x);
mean_local = nlfilter(I,[3 3],fun1);

fun2 = @(x) std2(x);
std_local = nlfilter(I,[3 3],fun2);
k0 = 0.4; k1 = 0.02; k2 = 0.4; E = 4;

mask = (mean_local<=k0*mI) & (std_local>=k1*sI) & (std_local<=k2*sI);
enI = I;
enI(mask) = I(mask)*E;

