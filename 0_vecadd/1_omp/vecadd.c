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

int main(void) {
  const int num = 1024 * 1024 * 1024;
  const float val = 1.5F;
  struct timespec ini, end;

  // memory allocation
  float *a0, *b0, *c0;
  a0 = (float*)malloc(sizeof(float) * num);
  b0 = (float*)malloc(sizeof(float) * num);
  c0 = (float*)malloc(sizeof(float) * num);
  float* c1;
  c1 = (float*)malloc(sizeof(float) * num);

// initialization
#pragma omp parallel for
  for (int i = 0; i < num; i++) {
    a0[i] = (float)i;
    b0[i] = (float)(num - i);
    c0[i] = 0.0F;
    c1[i] = 0.0F;
  }

  // main computation
  clock_gettime(CLOCK_MONOTONIC, &ini);
  for (int i = 0; i < num; i++) {
    c0[i] = a0[i] + val * b0[i];
  }
  clock_gettime(CLOCK_MONOTONIC, &end);
  const double elapsed_serial = (double)(end.tv_sec - ini.tv_sec) + (double)(end.tv_nsec - ini.tv_nsec) * 1e-9;
  printf("elapsed time (serial): %e [s]\n", elapsed_serial);
  clock_gettime(CLOCK_MONOTONIC, &ini);
#pragma omp parallel for
  for (int i = 0; i < num; i++) {
    c1[i] = a0[i] + val * b0[i];
  }
  clock_gettime(CLOCK_MONOTONIC, &end);
  const double elapsed_omp = (double)(end.tv_sec - ini.tv_sec) + (double)(end.tv_nsec - ini.tv_nsec) * 1e-9;
  printf("elapsed time (OpenMP): %e [s] (%e times faster)\n", elapsed_omp, elapsed_serial / elapsed_omp);

  // validation
  int err = 0;
  for (int i = 0; i < num; i++) {
    if (c0[i] != c1[i]) {
      err++;
    }
  }
  if (err == 0) {
    printf("validation: OK\n");
  } else {
    printf("validation: NG (%d errors)\n", err);
  }

  // free memory
  free(a0);
  free(b0);
  free(c0);
  free(c1);

  return 0;
}
