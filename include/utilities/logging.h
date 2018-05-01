#pragma once

#include <spdlog/spdlog.h>
#include "library_exports.h"

namespace logging {

    using namespace spdlog;
    using namespace std;

    const string logger_name = "cuda-vehicle-router-logger";

    LIBRARY_EXPORT void create_logger();

    shared_ptr<logger> get_logger();
}
