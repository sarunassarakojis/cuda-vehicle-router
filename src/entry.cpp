#include <cstdio>
#include "router_libraries.cuh"

int main(int argc, char* argv[]) {
	// CUDA 9.1 does not support cl of version 19.12
	// Alternative: use toolset v140, cl version: 19.0
	printf("cl ver: %d%c", _MSC_VER, '\n');

	vr::execute_kernel_wrapper(100);
}