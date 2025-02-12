#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <cuda_runtime.h>

// CUDA kernel for vector addition
__global__ void vecAddKernel(float* A_d, float* B_d, float* C_d, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n) {
        C_d[i] = A_d[i] + B_d[i];
    }
}

// Function to add two vectors using CUDA
void vecAdd(float* A_h, float* B_h, float* C_h, int n) {
    float *A_d, *B_d, *C_d;  // Device pointers

    // Allocate memory on the GPU
    cudaMalloc((void**)&A_d, n * sizeof(float));
    cudaMalloc((void**)&B_d, n * sizeof(float));
    cudaMalloc((void**)&C_d, n * sizeof(float));

    // Copy data from host to device
    cudaMemcpy(A_d, A_h, n * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(B_d, B_h, n * sizeof(float), cudaMemcpyHostToDevice);

    // Define block and grid sizes
    int blockSize = 256;
    int gridSize = (n + blockSize - 1) / blockSize;

    // Launch kernel
    vecAddKernel<<<gridSize, blockSize>>>(A_d, B_d, C_d, n);

    // Copy result from device to host
    cudaMemcpy(C_h, C_d, n * sizeof(float), cudaMemcpyDeviceToHost);

    // Free GPU memory
    cudaFree(A_d);
    cudaFree(B_d);
    cudaFree(C_d);
}

// Function to print a vector
void printVec(float* A, int N) {
    for (int i = 0; i < N; i++) {
        printf("%2d ", (int)floor(A[i]));
    }
    printf("\n");
}

// Function to create a dash separator
char* createDashString(int n) {
    char *str = (char*) malloc(n + 2);
    if (str == NULL) {
        perror("Memory allocation failed");
        exit(1);
    }
    memset(str, '-', n);
    str[n] = '\n';
    str[n+1] = '\0';
    return str;
}

int main() {
    int N = 40;  // Size of vectors

    // Allocate memory for vectors on the host (CPU)
    float* A = (float*)malloc(N * sizeof(float));
    float* B = (float*)malloc(N * sizeof(float));
    float* C = (float*)malloc(N * sizeof(float));

    if (A == NULL || B == NULL || C == NULL) {
        printf("Memory allocation failed\n");
        return 1;
    }

    // Initialize vectors with random values
    for (int i = 0; i < N; i++) {
        A[i] = (float)(rand() % 50);
        B[i] = (float)(rand() % 50);
    }

    // Perform vector addition on the GPU
    vecAdd(A, B, C, N);

    // Wait for kernel to finish before continuing
    cudaDeviceSynchronize();


    // Print results
    printVec(A, N);
    printVec(B, N);
    printf("%s", createDashString(3 * N - 1));
    printVec(C, N);

    // Free allocated memory
    free(A);
    free(B);
    free(C);

    return 0;
}
