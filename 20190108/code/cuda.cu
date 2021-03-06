#include<stdio.h>
#include<stdlib.h>
#include <cuda_runtime.h>
#include "cublas_v2.h"

// print to check  array 
void check(int dim, double* A, double* B, double* C, double* D, double* E );
void check_mult(int size, double* A, double* B, double* E );

//Implement the matmul method on GPU
__global__ void matmul(double *d_A, double *d_B, double *d_E, int size)
{
    int idx = threadIdx.x + blockIdx.x * blockDim.x;
    if(idx < size)
    d_E[idx] = d_A[idx] * d_B[idx];
}

// implement the AddArray on GPU
__global__ void Addarray(double *d_E, double *d_C, double *d_D, int size)
{
    int idx = threadIdx.x + blockIdx.x * blockDim.x;
    if(idx < size);
    d_D[idx] = d_C[idx] + d_E[idx];
}

int main(int argc, char *argv[])
{
    //declare cuda variables
    double *d_A, *d_B, *d_E, *d_C, *d_D;

    //declare CPU variables
    double *A, *B, *E, *C, *D;

    //Declare variables 
    int size_bytes, N;
    
    //initialize
    N = atoi(argv[1]);

    size_bytes = N* N * sizeof(double);
    const int NUM_THREADS = 32;
    const int NUM_BLOCKS = ( N + (NUM_THREADS-1) ) / NUM_THREADS;

    //create Streams
    cudaStream_t stream1, stream2;
    cudaStreamCreate( &stream1);
    cudaStreamCreate( &stream2);

    //create Events
    cudaEvent_t e1,e2;
    cudaEventCreateWithFlags(&e1, cudaEventDisableTiming);
    cudaEventCreateWithFlags(&e2, cudaEventDisableTiming);
    //cudaEventCreateWithFlags(&e3, cudaEventDisableTiming);
    
    //Allocate GPU memory 
    cudaMalloc((void **)&d_A, size_bytes);
    cudaMalloc((void **)&d_B, size_bytes);
    cudaMalloc((void **)&d_C, size_bytes);
    cudaMalloc((void **)&d_D, size_bytes);
    cudaMalloc((void **)&d_E, size_bytes);

    //Allocate host memory
    cudaHostAlloc((void **)&A, size_bytes,cudaHostAllocDefault);
    cudaHostAlloc((void **)&B, size_bytes,cudaHostAllocDefault);
    cudaHostAlloc((void **)&C, size_bytes,cudaHostAllocDefault);
    cudaHostAlloc((void **)&D, size_bytes,cudaHostAllocDefault);
    cudaHostAlloc((void **)&E, size_bytes,cudaHostAllocDefault);

    //initialize A,B,C 
    for (int i = 0; i < N; ++i)
    {
        for (int j = 0; j < N; ++j)
        {
          A[i + j*N] = 0.5;
          B[i + j*N] = 0.25;
          C[i + j*N] = 0.0;
        }
    }

    //load A and B from CPU to GPU S1
    cudaMemcpyAsync(d_A,A,size_bytes,cudaMemcpyHostToDevice, stream1);
    cudaMemcpyAsync(d_B,B,size_bytes,cudaMemcpyHostToDevice, stream1);
    cudaEventRecord(e1,stream1);

    // Multiply  using S1
    matmul<<<NUM_BLOCKS, NUM_THREADS, 0, stream1>>>(d_A,d_B,d_E,N);
    cudaEventRecord(e2,stream1);

    //load C from CPU to GPU using  S2
    cudaStreamWaitEvent( stream2 , e1 , 0);
    cudaMemcpyAsync(d_C,C,size_bytes,cudaMemcpyHostToDevice, stream2);

    //Add E to C S2
    cudaStreamWaitEvent( stream2 , e2 , 0);
    Addarray<<<NUM_BLOCKS, NUM_THREADS,0, stream2>>>(d_E,d_C,d_D, N);

    //Load E from GPU to CPU S1
    cudaMemcpyAsync(E,d_E,size_bytes,cudaMemcpyDeviceToHost, stream1);

    //print the array to check the correctness
    check_mult(N, A, B, E );

    //load D to CPU from GPU using S2
    cudaMemcpyAsync(D,d_D,size_bytes,cudaMemcpyDeviceToHost, stream2);

    //print the array to check the correctness  
   // check( N, A, B, C, D, E );

    //free memory from GPU and CPU
    cudaFreeHost(A); cudaFree(d_A);
    cudaFreeHost(B); cudaFree(d_B);
    cudaFreeHost(C); cudaFree(d_C);
    cudaFreeHost(D); cudaFree(d_D);
    cudaFreeHost(E); cudaFree(d_E);

    //destroy Stream
    cudaStreamDestroy(stream1);
    cudaStreamDestroy(stream2);

    //destroy Events
    cudaEventDestroy(e1);
    cudaEventDestroy(e2);

    return 0;
}

//verify correctness of multiplication
void check_mult(int size, double* A, double* B, double* E )
{
	int i, e;
	for (i = 0; i < size; ++i)
	{
		e = A[i]*B[i];
        if(E[i] != e) 
        {
            printf("Wrong results \n"); 
            return;
        }
    }
    printf("Results are correct \n");
	return;
}


void check(int size, double* A, double* B, double* C, double* D, double* E )
{
	int i, e, d;
	for (i = 0; i < size; ++i)
	{
		e = A[i]*B[i];
		d = e + C[i];
        if(E[i] != e) 
        {
            printf("Wrong results \n"); 
            return;
        }
        if(D[i] != d) 
        {
            printf("wrong results \n"); 
            return;
        }
    }
    printf("Results are correct \n");
	return;
}