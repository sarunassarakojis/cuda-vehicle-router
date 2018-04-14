#include "router_library.h"
#include "cuda_router_library.cuh"

void vr::executeInParallel() {
	cuda_vr::addVectorsWrapper();
}
