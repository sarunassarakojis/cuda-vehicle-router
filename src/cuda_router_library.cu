#include "cuda_router_library.h"
#include <cstdlib>
#include <iostream>
#include <cuda_runtime.h>

__global__
void add_vectors(float* source_vec_a, float* source_vec_b, float* res_vec, int size) {
    const int i = blockDim.x * blockIdx.x + threadIdx.x;

    if (i < size) {
        res_vec[i] = source_vec_a[i] + source_vec_b[i];
    }
}

template <typename T>
void print_array_contents(T* block, size_t size) {
    for (auto i = 0; i != size; ++i) {
        std::cout << "Element: " << block[i] << std::endl;
    }
}

void cuda_vr::add_vectors_wrapper() {
    const int n = 5;
    size_t size = n * sizeof(float);
    float* vec_a_host = (float*)malloc(size);
    float* vec_b_host = (float*)malloc(size);
    float* vec_res_host = (float*)malloc(size);
    float* vec_a_device;
    float* vec_b_device;
    float* vec_res_device;

    vec_a_host[0] = 2.3f;
    vec_a_host[1] = 2.5f;
    vec_a_host[2] = 1.0f;
    vec_a_host[3] = 999.1f;
    vec_a_host[4] = .1f;
    std::cout << "Source vector a:" << std::endl;
    print_array_contents(vec_a_host, n);
    std::cout << std::endl;

    vec_b_host[0] = 2.3f;
    vec_b_host[1] = 2.5f;
    vec_b_host[2] = 1.0f;
    vec_b_host[3] = 999.1f;
    vec_b_host[4] = .1f;

    cudaMalloc(&vec_a_device, size);
    cudaMalloc(&vec_b_device, size);
    cudaMalloc(&vec_res_device, size);

    cudaMemcpy(vec_a_device, vec_a_host, size, cudaMemcpyHostToDevice);
    cudaMemcpy(vec_b_device, vec_b_host, size, cudaMemcpyHostToDevice);

    int threads_per_block = 256;
    int blocks_per_grid = (n + threads_per_block - 1) / threads_per_block;

    add_vectors<<<blocks_per_grid, threads_per_block>>>(vec_a_device, vec_b_device, vec_res_device, n);

    cudaMemcpy(vec_res_host, vec_res_device, size, cudaMemcpyDeviceToHost);

    std::cout << "Result vector:" << std::endl;
    print_array_contents(vec_res_host, n);

    cudaFree(vec_a_device);
    cudaFree(vec_b_device);
    cudaFree(vec_res_device);
}
