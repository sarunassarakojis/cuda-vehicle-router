#include "router_libraries.cuh"
#include <stdio.h>

__global__
void vr::execute_kernel() {
	printf("Thread %d running%c", threadIdx.x, '\n');
}

void vr::execute_kernel_wrapper(int num_threads) {
	vr::execute_kernel<<<1, num_threads>>>();
}
