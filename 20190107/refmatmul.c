#include <stdio.h>

#if defined(_OPENMP)
#include <omp.h>
#endif

#define N 500

void
matrix_multiply(double *C, double *A, double *B) {
  int i, j, k;
  for (i = 0; i < N; ++i)
    for (j = 0; j < N; ++j) {
      C[i + j*N] = 0.0;
      for (k = 0; k < N; ++k)
        C[i + j*N] += A[i*N + k] * B[k*N + j];
    }
}

int
main(void) {
  int i, j;
  double A[N*N], B[N*N], C[N*N], t;

  for (i = 0; i < N; ++i)
    for (j = 0; j < N; ++j) {
      A[i + j*N] = 0.5;
      B[i + j*N] = 0.25;
    }

  t = - omp_get_wtime();
  matrix_multiply(C, A, B);
  t += omp_get_wtime();

  printf("%d %g us %g flop/s\n", N, t, 2.0*N*N*N/t);

  return 0;
}
