#include "cuda_router_library.cuh"
#include <stdio.h>

__global__
void cuda_vr::execute_kernel() {
	printf("Thread %d running%c", threadIdx.x, '\n');
}

void cuda_vr::execute_kernel_wrapper(int num_of_threads) {
	execute_kernel<<<1, num_of_threads>>>();
}
