#include "utilities/logging.h"
#include <spdlog/spdlog.h>

void logging::create_logger() {
    stdout_color_st(logger_name);
}


void logging::drop_logger() {
    drop(logger_name);
}

std::shared_ptr<spdlog::logger> logging::get_logger() {
    return get(logger_name);
}
