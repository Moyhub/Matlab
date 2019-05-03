#include "mex.h"
#include <iostream>
#include <vector>
using namespace std;
 void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
 {
     
    vector<vector<double>>params; 
    int M = mxGetM(prhs[0]);
    int N = mxGetN(prhs[0]);
    // �õ��������A������������
    params.resize(M);
    for(int s=0;s<M;s++)
        params[s].resize(N);
    //�õ�һ����ά����
    for (int i = 0; i < M ; ++i)
        for ( int j=0; j< N; ++j)
            params[i][j]=1/(i+j+1);
    
    plhs[0] = mxCreateDoubleMatrix(M, N, mxREAL);
    // Ϊ�������B����洢�ռ�
 }
     