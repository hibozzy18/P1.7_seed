#include<stdio.h>
#include<stdlib.h>

# define NUM_THREADS 16 
# define NUM_BLOCKS  8

// print to check printed array 

printArray(double * Array);

__global__ void matmul(double *d_A, double *d_B, double *d_E)
{
    int idx = threadIdx.x + blockIdx.x * blockDim.x;
    if(idx < size)
    E[idx] = A[idx] * B[idx];
}

__global__ void Addarray(double *d_E, double *d_C, double *d_D)
{
    int idx = threadIdx.x + blockIdx.x * blockDim.x;
    if(idx < size)
    D[idx] = C[idx] + E[idx];
}


int main(int argc, char *argv[])
{
    //declare cuda variables
    double *d_A, *d_B, *d_E, *d_C, *d_D;

    //declare CPU variables
    double A, B, E, C, D;

    //
    cudaDeviceProp prop;
    int dev_id;
    cudaGetDevice( &dev_id );
    cudaGetDeviceProperties( &prop, dev_id );
    if (0 == prop.deviceOverlap) 
    {
         fprintf(stderr, "No handle overlap support");
    }

    //create Streams
    cudaStream_t stream1, stream2;
    cudaStreamCreate( &stream1);
    cudaStreamCreate( &stream2);

    //create Events
    cudaEvent_t e1,e2,e3;
    cudaEventCreateWithFlags(&e1, cudaEventDisableTiming);
    cudaEventCreateWithFlags(&e2, cudaEventDisableTiming);
    cudaEventCreateWithFlags(&e3, cudaEventDisableTiming);
    

    //Allocate GPU memory 
    cudaMalloc((void**)&d_A, size * sizeof(double));
    cudaMalloc((void**)&d_B, size * sizeof(double));
    cudaMalloc((void**)&d_C, size * sizeof(double));
    cudaMalloc((void**)&d_D, size * sizeof(double));
    cudaMalloc((void**)&d_E, size * sizeof(double));

    //Allocate host memory
    cudaHostAlloc((void **)&A, size * sizeof(double)),cudaHostAllocDefault);
    cudaHostAlloc((void **)&B, size * sizeof(double)),cudaHostAllocDefault);
    cudaHostAlloc((void **)&C, size * sizeof(double)),cudaHostAllocDefault);
    cudaHostAlloc((void **)&D, size * sizeof(double)),cudaHostAllocDefault);
    cudaHostAlloc((void **)&E, size * sizeof(double)),cudaHostAllocDefault);

    //initialize A,B,C 
    for(int i=0; i<size; i++)
    {
        A[i] = 1.0;
        B[i] = 1.0;
        C[i] = 1.0;
    }

    //load A and B from CPU to GPU S1
    cudaMemcpyAsync(d_A,A,size*sizeof(double),cudaMemcpyHostToDevice, stream1);
    cudaMemcpyAsync(d_B,B,size*sizeof(double),cudaMemcpyHostToDevice, stream1);
    cudaEventRecord(e1,stream1);

    // Multiply S1
    matmul<<<NUM_BLOCKS, NUM_THREADS, 0, stream1>>>(d_A,d_B,d_E);
    cudaEventRecord(e2,stream1);

    //load C from CPU to GPU using  S2
    cudaStreamWaitEvent( stream2 , e1 , 0);
    cudaMemcpyAsync(d_C,C,size*sizeof(double),cudaMemcpyHostToDevice, stream2);

    //Add E to C S2
    cudaStreamWaitEvent( stream2 , e2 , 0);
    Addarray<<<NUM_BLOCKS, NUM_THREADS,0, stream2>>>(d_E,d_C,d_D);

    //Load E from GPU to CPU S1
    cudaMemcpyAsync(E,d_E,size*sizeof(double),cudaMemcpyDeviceToHost, stream1);

    //print the array to check the correctness
    printArray(E);

    //load D to CPU from GPU using S2
    cudaMemcpyAsync(D,d_D,size*sizeof(double),cudaMemcpyDeviceToHost, stream2);

    //print the array to check the correctness  
    printArray(D);

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
    cudaEventDestroy(e3);

    return 0
}

//verify correctness of multiplication
printArray(double * Array)
{
    for(int i =0; i<size; i++)
    {
        printf("%d", Array[i])
    }
}
