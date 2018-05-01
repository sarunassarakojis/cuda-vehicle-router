#include "routing/router_library.h"
#include "utilities/device/device_query.h"
#include "utilities/logging.h"

int main(int argc, char* argv[]) {
    using namespace device_types;

    Device_properties* properties = nullptr;
    unsigned size = 0;

    vr::execute_in_parallel();
    logging::create_logger();
    device_query::get_cuda_device_properties(properties, size);
}
