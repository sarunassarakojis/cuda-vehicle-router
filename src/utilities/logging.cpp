#include "utilities/logging.h"

void logging::create_logger() {
    stdout_color_st(logger_name);
}

std::shared_ptr<spdlog::logger> logging::get_logger() {
    return get(logger_name);
}
