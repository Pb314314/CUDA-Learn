#include <cuda_runtime.h>
#include <iostream>

__global__ void vector_add(const float* A, const float* B, float* C, int N) {
    int index = blockIdx.x * blockDim.x + threadIdx.x;
    if(index < N){
        C[index] = A[index] + B[index];
    }
}

int main(){
    int N = 32 * 1024 * 1024;
    size_t size = N * sizeof(float);
    
    float *h_A = new float[N];
    float *h_B = new float[N];
    float *h_C = new float[N];

    for (int i=0;i<N;i++){
        h_A[i] = i;
        h_B[i] = 2 * i;
    } 

    float *d_A, *d_B, *d_C;
    cudaMalloc(&d_A, size);
    cudaMalloc(&d_B, size);
    cudaMalloc(&d_C, size);
    cudaMemcpy(d_A, h_A, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, h_B, size, cudaMemcpyHostToDevice);

    dim3 Grid(N / 256);
    dim3 Block(64);

    vector_add<<<Grid, Block>>>(d_A, d_B, d_C, size);

    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);

    delete[] h_A;
    delete[] h_B;
    delete[] h_C;
    return 0;
}