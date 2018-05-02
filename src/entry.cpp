#include "utilities/device/device_query.h"
#include "utilities/logging.h"
#include <iostream>

int main(int argc, char* argv[]) {
    using namespace device_types;

    logging::create_logger();
    std::vector<std::unique_ptr<Device_properties>> properties = device_query::get_cuda_device_properties();
    auto p = std::move(properties[0]);

    std::cout << p->device_name << '\n';
}
