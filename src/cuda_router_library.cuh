#ifndef ROUTER_LIBRARY_CUH
#define ROUTER_LIBRARY_CUH

#include <cuda_runtime.h>

namespace cuda_vr {

	__global__
	void addVectors(float* source_vec_a, float* source_vec_b, float* res_vec, int size);

	void addVectorsWrapper();
}

#endif
