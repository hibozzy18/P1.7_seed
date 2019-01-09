#include <stdio.h>

#include <cuda_runtime.h>

__global__ void
add2(double *c, const double *a, const double *b) {
  c[0] = a[0] + b[0];
}

int
main(void) {
  double *a, *b, *c;
  float t;

  cudaEvent_t start, stop;

  cudaMalloc( (void **)&a, sizeof(double) );
  cudaMalloc( (void **)&b, sizeof(double) ) ;
  cudaMalloc( (void **)&c, sizeof(double) ) ;

  cudaEventCreate(&start);
  cudaEventCreate(&stop);

  cudaEventRecord(start, 0);
  add2<<<1,1>>>(c, a, b);
  cudaEventRecord(stop, 0);

  cudaEventSynchronize(stop);

  cudaEventElapsedTime(&t, start, stop);
  printf("cudaEventElapsedTime(%.6f)\n", t / 1000.0f);

  cudaFree(c);
  cudaFree(b);
  cudaFree(a);

  return 0;
}
