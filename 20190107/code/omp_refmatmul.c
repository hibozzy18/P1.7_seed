#include<stdio.h>
#include<stdlib.h>
#if defined(_OPENMP)
#include <omp.h>
#endif

// multiplication 
void matrix_multiply(double *C, double *A, double *B, int N) {
  int i, j, k;
#pragma omp for collapse(2) private(i,j,k)
  for (i = 0; i < N; ++i)
    for (j = 0; j < N; ++j) {
      for (k = 0; k < N; ++k)
        C[i + j*N] += A[i*N + k] * B[k*N + j];
    }
}

int main(int argc, char *argv[]) 
{
  // declare variables
  int i, j, numthreads;
  int N,num_size;
  double *A, *B, *C, t;
  
  if(argc!=2)
  {
    fprintf(stderr, "wrong usage please enter the value of N");
  }

  N = atoi(argv[1]);
  num_size = N * N * sizeof(double);

  // Allocate memory 
  A = (double *)malloc(num_size);
  B = (double *)malloc(num_size);
  C = (double *)malloc(num_size);

  //initialize array
  for (i = 0; i < N; ++i)
    for (j = 0; j < N; ++j) {
      A[i + j*N] = 0.5;
      B[i + j*N] = 0.25;
      C[i +j * N] = 0.0;
    }

t =- omp_get_wtime();
#pragma omp parallel
{
  numthreads = omp_get_num_threads();
  matrix_multiply(C, A, B, N);
}
  t += omp_get_wtime();

//print time
printf("%d %d %g %g \n", N, numthreads, t, 2.0 * N * N * N / t);

  return 0;
}
