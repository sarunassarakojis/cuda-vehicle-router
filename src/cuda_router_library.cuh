#ifndef ROUTER_LIBRARY_CUH
#define ROUTER_LIBRARY_CUH

#include <cuda_runtime.h>

namespace cuda_vr {

	__global__
	void add_vectors(float* source_vec_a, float* source_vec_b, float* res_vec, int size);

	void execute_kernel_wrapper(int num_of_threads);
}

#endif
