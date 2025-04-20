//
// Created by haruka on 2/17/25.
//
// Try not to import anything

#include "omp.h"

#define SIZE 32

int main() {
  int i;
  int A[SIZE];

// initiate A and B
#pragma omp parallel for
  for (i = 0; i < SIZE; i++) {
    A[i] = i;
  }

#pragma omp target map(tofrom: A[0:SIZE])
  for (i = 0; i < SIZE; i++) {
    A[i] += 1;
  }

  return 0;
}