#pragma once

#include <spdlog/spdlog.h>
#include "library_exports.h"

namespace logging {

    using namespace spdlog;
    using namespace std;

    const std::string logger_name = "cuda-vehicle-router-logger";

    LIBRARY_EXPORT void create_logger();

    LIBRARY_EXPORT void drop_logger();

    shared_ptr<logger> get_logger();
}
