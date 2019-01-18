#include<stdio.h>
#include<stdlib.h>
#include <cuda_runtime.h>
#include "cublas_v2.h"


//declare matrix
void print(double *C, int size );
int main(int argc, char const *argv[])
{
    //Declare number of streams
    int num_streams, N, size;

    //get values
    N = atoi(argv[1]);
    num_streams = atoi(argv[2]);

    //calculate size in bytes
    size = N * N * sizeof(double);

    // cuda create event 
    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    
    //allocate CPU memory
    double *A, *B *C;
    
    cudaHostAlloc((void **)&A, size,cudaHostAllocDefault);
    cudaHostAlloc((void **)&B, size,cudaHostAllocDefault);
    cudaHostAlloc((void **)&C, size,cudaHostAllocDefault);
    
    //Allocate GPU memory
    double *d_A,*d_B, *d_C;
    cudaMalloc((void**)&d_A, size);
    cudaMalloc((void**)&d_B, size);
    cudaMalloc((void**)&d_C, size);

    //initialize A,B,C 
    for (int i = 0; i < N; i++)
    {
        for (int j = 0; j < N; j++)
        {
          A[i + j*N] = 0.5;
          B[i + j*N] = 0.25;
          C[i + j* N] = 0.0;
        }
    }
    // set alphars
    const double alpha = 1.0;
    const double beta = 0.0;
    
    //create handle
    cublasHandle_t handle;
    cublasCreate(&handle);
    
    //Create streams 
    cudaStream_t streams[num_streams];
    
    //compute
    cudaEventRecord(start, 0);
    for (int i = 0; i < num_streams; i++) 
    {
        //printf("%g \n",0.0);
        cudaStreamCreate(&streams[i]);
        cudaMemcpyAsync(d_A , A ,size, cudaMemcpyHostToDevice, streams[i]);
        cudaMemcpyAsync(d_B , B ,size, cudaMemcpyHostToDevice, streams[i]);
       // cudaMemcpyAsync(d_C , C ,size, cudaMemcpyHostToDevice, streams[i]);
        cublasDgemm(handle,CUBLAS_OP_N,CUBLAS_OP_N,N,N,N,&alpha,d_A,N,d_B,N,&beta,d_C,N);
        cudaMemcpyAsync(C, d_C ,size, cudaMemcpyDeviceToHost, streams[i]);
        cudaStreamSynchronize (streams[i]);
       
    }

    cudaEventRecord(stop, 0);
    cudaEventSynchronize(stop);

    float elapsedTime;
    cudaEventElapsedTime(&elapsedTime, start, stop);
    
    //Destroy handle
    cublasDestroy(handle);

    //destory event
    cudaEventDestroy(stop);
    cudaEventDestroy(start);


    // destroy stream
    for (int i = 0; i < num_streams; ++i)
    {
        cudaStreamDestroy(streams[i]);
    }

    // print elapsed time
    printf("%d %d% .6f %g \n",N, num_streams, elapsedTime / 1000.0f, num_streams * 2e-9 * N*N*N /(elapsedTime / 1000.0f));
    //print(C,5);

    //Free CPU memory 
    cudaFreeHost(A);
    cudaFreeHost(B);
    cudaFreeHost(C);

    //Freee GPU memory
    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);

    return 0;
}

// print results of the array
void print(double *C, int size )
{
 int i,j;
 for(i=0; i < size; i++)
  {
    for(j=0; j < size; j++)
      printf("  %d", C[size*i+j]);
    printf("\n");
  }
}