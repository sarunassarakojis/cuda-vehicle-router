#include <spdlog/spdlog.h>
#include "utilities/device/device_query.h"
#include "utilities/logging.h"

using namespace device_types;

void device_query::get_cuda_device_properties(Device_properties* devices, unsigned& size) {
    auto logger = logging::get_logger();

    logger->info("Attempting to get cuda devices");
    logger->error("ERRRRR neeeein! (*_*)");
    logger->warn("warned ya");
}
