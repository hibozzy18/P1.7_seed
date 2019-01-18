
#define N 1000

void
addArray(double *D, double *E, double *C) {
  int i;
  for (i = 0; i < N; ++i)
    D[i] = E[i] + C[i];
}

void
mulArray(double *E, double *A, double *B) {
  int i;
  for (i = 0; i < N; ++i)
    E[i] = A[i] * B[i];
}

int
main(void) {
  int i;
  double A[N], B[N], C[N], E[N], D[N];

  mulArray(E, A, B);
  addArray(D, E, C);

  return 0;
}
