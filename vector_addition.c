#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

// Function to add two vectors
void vecAdd(float* A_h, float* B_h, float* C_h, int n) {
    for (int i = 0; i < n; i++) {
        C_h[i] = A_h[i] + B_h[i];
    }
}

void printVec(float* A, int N){
    // Print results
    for (int i = 0; i < N; i++) {
        printf("%2d ", (int)floor(A[i]));
    }
    printf("\n");
}

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
    int N = 40; // Size of vectors

    // Allocate memory for vectors
    float* A = (float*)malloc(N * sizeof(float));
    float* B = (float*)malloc(N * sizeof(float));
    float* C = (float*)malloc(N * sizeof(float));

    if (A == NULL || B == NULL || C == NULL) {
        printf("Memory allocation failed\n");
        return 1;
    }

    // Initialize vectors with random values
    for (int i = 0; i < N; i++) {
        A[i] = (float)(rand() % 50); // Random values between 0 and 99
        B[i] = (float)(rand() % 50);
    }

    // Perform vector addition
    vecAdd(A, B, C, N);

    // Print results
    printVec(A, N);
    printVec(B, N);
    printf("%s",createDashString(3*N-1));
    printVec(C, N);

    // Free allocated memory
    free(A);
    free(B);
    free(C);

    return 0;
}
