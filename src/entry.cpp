#include "utilities/device/device_query.h"
#include "utilities/logging.h"
#include "routing/routing.h"

#include <iostream>

int main(int argc, char* argv[]) {
    using namespace device_types;

    logging::create_logger();
    // routing::execute_in_parallel();
    std::vector<std::unique_ptr<Device_properties>> properties = device_query::get_cuda_device_properties();
    auto p = std::move(properties[0]);

    std::cout << p->device_name << '\n';
    std::cout << p->global_memory_in_mb << '\n';
    std::cout << p->compute_capability << '\n';
}
