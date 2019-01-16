#include<stdio.h>
#include<stdlib.h>
#include<omp.h>
#include<plasma.h>

int main(int argc, char * argv[])
{
    if(argc < 2)
    {
        printf("Wrong usage: please enter the value of N.");
        exit(1);
    }

    int N = atoi(argv[1]); 
    double *A, *B,*C, t;

    A = (double *)malloc(N * N * sizeof(double));
    B = (double *)malloc(N * N * sizeof(double));
    C = (double *)malloc(N * N * sizeof(double));

    //initialize Matrices
    for(size_t i = 0; i < N; i++)
    {
        A[i] = 1.0;
        B[i] = 1.0;
        C[i] = 0.0;
    }
    
    PLASMA_Init(20);

    //Compute the multiplication
    t =- omp_get_wtime();
    PLASMA_dgemm(PlasmaNoTrans, PlasmaNoTrans,N,N,N,1,A,N,B,N,0,C,N);
    t += omp_get_wtime();

    PLASMA_Finalize();

    //print the 
    printf("%d %g %g \n", N, t, 2.0 * N * N * N / t);

    return 0;

}
