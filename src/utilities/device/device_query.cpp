#include <spdlog/spdlog.h>
#include "utilities/device/device_query.h"

using namespace device_types;

void device_query::get_cuda_device_properties(Device_properties* devices, unsigned& size) {
    auto logger = spdlog::stdout_color_mt("console");

    logger->info("Attempting to get cuda devices");
}
