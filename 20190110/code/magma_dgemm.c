#include<stdlib.h>
#include<stdio.h>
#include<magma.h>
#include<magmablas.h>
#include<cuda_runtime.h>


void print_list(double * C, int n_loc, int N);

int main(int argc, char  *argv[])
{
    if(argc< 2)
    {
        fprintf(stderr,"Wrong usage please eneter the number N");
        exit(0);
    }

    //get value of N
    size_t N, size;
    N = atoi(argv[1]);

    //declare arrays 
    double *A,*B,*C;
    double *d_A, *d_B, *d_C;
    float t, t_total;
    
    //size of matrix 
    size = N*N*sizeof(double);

    // declare create event
    cudaEvent_t start, stop;
    cudaEvent_t start_perf, stop_perf;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    cudaEventCreate(&start_perf);
    cudaEventCreate(&stop_perf);

    //initialize magma
    magma_init();

    //allocate CPU matrices
    magma_malloc_cpu((void **)&A, size);
    magma_malloc_cpu((void **)&B, size);
    magma_malloc_cpu((void **)&C, size);
 

    //allocate GPU matrices
    magma_malloc((void **)&d_A, size);
    magma_malloc((void **)&d_B, size);
    magma_malloc((void **)&d_C, size);

    //initialize the arrays
     for(size_t i = 0; i < N*N; i++)
     {
        A[i] = 1;
        B[i] = 1;
        C[i] = 0;
     }

     //start recording
     cudaEventRecord(start, 0);

     //copy matricies from GPU to CPU
     magma_setmatrix(N, N, sizeof(double), A, N, d_A, N);
     magma_setmatrix(N, N, sizeof(double), B, N, d_B, N);

     
     //record computational time only
     cudaEventRecord(start_perf, 0);
     //Compute in GPU
     magma_dgemm(MagmaNoTrans, MagmaNoTrans, N, N, N, 1.0, d_A, N, d_B, N, 1.0, d_C, N);
     cudaEventRecord(stop_perf, 0);
     //Copy Results back from the GPU to CPU
     magma_getmatrix(N, N, sizeof(double), d_C, N, C, N);
    
    //stop the recording
     cudaEventRecord(stop, 0);
     cudaEventSynchronize(stop);

     //get elapsed time  
     cudaEventElapsedTime(&t, start, stop);
     cudaEventElapsedTime(&t_total, start_perf, stop_perf);

     //convert time to seconds
    t = t/100.0f;
    t_total = t_total / 100.0f;
    printf("%d %g %g %g %g\n", N, t, 2.0 * N * N * N / t, t_total, 2.0 * N * N * N / t_total);

    //Print results
    // print_list(C,5, N);

    //free CPU memory
    magma_free_cpu(A);
    magma_free_cpu(B);
    magma_free_cpu(C);

    //Free GPU memory 
    magma_free(d_A);
    magma_free(d_B);
    magma_free(d_C);
   
    magma_finalize();

    return 0;
}

//print portion of matrix
void print_list(double *C, int n_loc, int N){
    for (size_t j = 0; j < n_loc; j++)
    {
        for (size_t i = 0; i < n_loc; i++)
        {
            printf("%g \t", C[j * N + i]);
        }
        printf("\n");
    }
}