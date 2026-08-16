///
/// @file vecadd.c
/// @author Yohei MIKI (The University of Tokyo)
/// @brief sample code for vector addition (serial version)
///

// for CLOCK_MONOTONIC
#define _POSIX_C_SOURCE 199309L

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

static inline void vecadd(const int num, const float val, const float* restrict a, const float* restrict b, float* restrict c) {
  for (int i = 0; i < num; i++) {
    c[i] = a[i] + val * b[i];
  }
}

int main(void) {
  const int num = 1024 * 1024 * 1024;
  const float val = 1.5F;
  struct timespec ini, end;

  // memory allocation
  float *a0, *b0, *c0;
  a0 = (float*)malloc(sizeof(float) * num);
  b0 = (float*)malloc(sizeof(float) * num);
  c0 = (float*)malloc(sizeof(float) * num);

  // initialization
  for (int i = 0; i < num; i++) {
    a0[i] = (float)i;
    b0[i] = (float)(num - i);
    c0[i] = 0.0F;
  }

  // main computation
  clock_gettime(CLOCK_MONOTONIC, &ini);
  vecadd(num, val, a0, b0, c0);
  clock_gettime(CLOCK_MONOTONIC, &end);
  const double elapsed = (double)(end.tv_sec - ini.tv_sec) + (double)(end.tv_nsec - ini.tv_nsec) * 1e-9;
  printf("elapsed time: %e [s]\n", elapsed);

  // free memory
  free(a0);
  free(b0);
  free(c0);

  return 0;
}
