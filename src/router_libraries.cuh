#include <cuda_runtime.h>

namespace vr {

	__global__
	void execute_kernel();

	void execute_kernel_wrapper(int);
}