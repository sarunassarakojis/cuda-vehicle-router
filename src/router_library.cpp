#include "router_library.h"
#include "cuda_router_library.h"

void vr::executeInParallel() {
	cuda_vr::addVectorsWrapper();
}
