#include<stdlib.h>
#include<stdio.h>
#include<magma.h>
//include this folder /u/shared/programs/x86_64/magma/1.6.1/intel/14.0/mkl/11.1/cudatoolkit/6.5/include
#include<magmablas.h>


int main(int argc, char  *argv[])
{
    if(argc< 2)
    {
        fprintf(stderr,"Wrong usage please eneter the number N");
        exit(0);
    }
    size_t N, size;

    N = atoi(argv[1]);

    printf("%d \n", N);
    //create and initializa arrays 
    double *A,*B,*C;
    //void **pA, **pB, **pC;

    double *d_A, *d_B, *d_C;
    //double **pd_A, **pd_B, **pd_C;
    
    //size of matrix 
    size = N*N*sizeof(double);

    //pointer to pointer
    // pA = &A; pB = &B; pC = &C;

    magma_init();

    // reg malloc
   /* A = (double *)malloc(size);
    B = (double *)malloc(size);
    C = (double *)malloc(size);*/

    //allocate CPU matrices
    magma_malloc_cpu((void **)&A, size);
    magma_malloc_cpu((void **)&B, size);
    magma_malloc_cpu((void **)&C, size);

    //set queue
    //magma_queue_t queue
    //magma_queue_create(0, &queue);

    //allocate GPU matrices
    magma_malloc((void **)&d_A, size);
    magma_malloc((void **)&d_B, size);
    magma_malloc((void **)&d_C, size);

    //cudaMalloc((void **)&d_A, size);
    //cudaMalloc((void **)&d_B, size);
    //cudaMalloc((void **)&d_C, size);

    // initialize the array
     
     for(size_t i = 0; i < N*N; i++)
     {
        A[i] = (double) rand();
        B[i] = (double) rand();
        C[i] = 0;
     }
     

    //copy matrciess from GPU to CPU
    magma_setmatrix(N, N, size, A, N, d_A, N);
    magma_setmatrix(N, N, size, B, N, d_B, N);

    //magma_setmatrix(m, n, elemSize, hA_src, lda, dB_dst, lddb);


    //Compute in GPU
    /*
    magmablas_dgemm(
        magma_trans_t transA, magma_trans_t transB,
        magma_int_t m, magma_int_t n, magma_int_t k,
        double alpha,
        magmaDouble_const_ptr dA, magma_int_t ldda,
        magmaDouble_const_ptr dB, magma_int_t lddb,
        double beta,
        magmaDouble_ptr dC, magma_int_t lddc);
        */

    magma_dgemm(MagmaNoTrans, MagmaNoTrans, N, N, N, -1.0, d_A, N, d_B, N, 1.0, d_C, N);

    //Copy Results back from the GPU to CPU
    magma_getmatrix(N, N, size, d_C, N, C, N);

    //Print results
    /*
    for(size_t i = 0; i < 2; i++)
    {
        
        for(size_t j = 2; j < N; j++)
        {
            printf("%g \t", C[i*N + j]);
        }
        
        printf("\n");
    }
    */

    //free CPU memory
    magma_free_cpu(A);
    magma_free_cpu(B);
    magma_free_cpu(C);

    //free
    /*free(A);
    free(B);
    free(C);*/

    //Free GPU memory 
    magma_free(d_A);
    magma_free(d_B);
    magma_free(d_C);
    /*
    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);*/

    magma_finalize();

    return 0;
}
