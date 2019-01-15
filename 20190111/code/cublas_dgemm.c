#include<stdio.h>
#include<stdlib.h>

#include <cuda_runtime.h>



int main(int argc, char const *argv[])
{

    int num_streams, N, size;

    N = atoi(argv[1]);
    num_streams = atoi(argv[2]);

    //calculate size
    size = N * N * sizeof(double);

    //Create streams 
    CudaStream_t streams[num_streams];
    double *

    //allocate CPU memory
    double *h_A, *h_B, *h_C;
    cudaMallocHost((void **)&h_A, size);
    cudaMallocHost((void **)&h_B, size);
    cudaMallocHost((void **)&h_C, size);

    //Allocate GPU memory
    double *d_A,*d_B, *d_C;
    cudaMalloc((void**)&d_A, size);
    cudaMalloc((void **)&d_B, size);
    cudaMalloc((void **)&d_C, size);

    // set alphars
    double alpha = 1.0;
    double beta = 1.0;
    
    //compute
    for(int i = 0; i < N; i++)
    {
        cudaStreamCreate(&streams[i]);
    }
    




    //Free CPU memory 


    //Freee GPU memory
    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);

    return 0;
}
