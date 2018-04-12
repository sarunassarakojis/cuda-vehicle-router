#ifndef ROUTER_LIBRARY_CUH
#define ROUTER_LIBRARY_CUH

#include <cuda_runtime.h>

namespace cuda_vr {

	__global__
	void execute_kernel();

	void execute_kernel_wrapper(int num_of_threads);
}

#endif
