#include "routing/router_library.h"
#include "utilities/device/device_query.h"

int main(int argc, char* argv[]) {
    using namespace device_types;

    Device_properties* properties = nullptr;
    unsigned size = 0;

    vr::execute_in_parallel();
    device_query::get_cuda_device_properties(properties, size);
}
