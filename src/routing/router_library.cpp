#include "routing/router_library.h"
#include "routing/cuda_router_library.h"

void vr::execute_in_parallel() {
    cuda_vr::add_vectors_wrapper();
}
