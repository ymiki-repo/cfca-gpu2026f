///
/// @file vecadd.cu
/// @author Yohei MIKI (The University of Tokyo)
/// @brief sample code for vector addition (CUDA version, managed memory)
/// @note This code includes bug intentionally for educational purposes. Please refer to the lecture slides for details.
///

#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

static inline void vecadd_omp(const int num, const float val, const float* __restrict a, const float* __restrict b, float* __restrict c) {
#pragma omp parallel for
  for (int i = 0; i < num; i++) {
    c[i] = a[i] + val * b[i];
  }
}

#define NTHREADS (128)
#define NBLOCKS(num, threads) (((num) + (threads) - 1) / (threads))

__global__ void vecadd_gpu(const int num, const float val, const float* __restrict a, const float* __restrict b, float* __restrict c) {
  int i = blockIdx.x * blockDim.x + threadIdx.x;
  if (i < num) {
    c[i] = a[i] + val * b[i];
  }
}

int main(void) {
  const int num = 1024 * 1024 * 1024;
  const float val = 1.5F;
  struct timespec ini, end;

  // memory allocation
  float *a0, *b0, *c0;
  cudaMallocManaged(&a0, sizeof(float) * num);
  cudaMallocManaged(&b0, sizeof(float) * num);
  c0 = (float*)malloc(sizeof(float) * num);
  float* c1;
  cudaMallocManaged(&c1, sizeof(float) * num);

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
  vecadd_omp(num, val, a0, b0, c0);
  clock_gettime(CLOCK_MONOTONIC, &end);
  const double elapsed_cpu = (double)(end.tv_sec - ini.tv_sec) + (double)(end.tv_nsec - ini.tv_nsec) * 1e-9;
  printf("elapsed time (CPU): %e [s]\n", elapsed_cpu);
  clock_gettime(CLOCK_MONOTONIC, &ini);
  vecadd_gpu<<<NBLOCKS(num, NTHREADS), NTHREADS>>>(num, val, a0, b0, c1);
  clock_gettime(CLOCK_MONOTONIC, &end);
  const double elapsed_gpu = (double)(end.tv_sec - ini.tv_sec) + (double)(end.tv_nsec - ini.tv_nsec) * 1e-9;
  printf("elapsed time (GPU): %e [s] (%e times faster)\n", elapsed_gpu, elapsed_cpu / elapsed_gpu);

  // validation
  cudaDeviceSynchronize();
  int err = 0;
  for (int i = 0; i < num; i++) {
    if (fabsf(c1[i] / c0[i] - 1.0F) > 1.0e-6F) {
      err++;
    }
  }
  if (err == 0) {
    printf("validation: OK\n");
  } else {
    printf("validation: NG (%d errors)\n", err);
  }

  // free memory
  cudaFree(a0);
  cudaFree(b0);
  free(c0);
  cudaFree(c1);

  return 0;
}
