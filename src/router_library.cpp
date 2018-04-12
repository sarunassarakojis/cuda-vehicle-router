#include "router_library.h"
#include "cuda_router_library.cuh"

void vr::execute_in_parallel(const int num_of_threads) {
	cuda_vr::execute_kernel_wrapper(num_of_threads);
}
