#include "utilities/device/device_query.h"
#include "utilities/logging.h"
#include <cuda_runtime_api.h>

using namespace device_types;
using namespace logging;

Device_properties* map_to_device_properties(cudaDeviceProp& properties, int& driver_version) {
    auto device_properties{new Device_properties};

    device_properties->device_name = properties.name;
    device_properties->global_memory_in_mb = properties.totalGlobalMem / 1e6;
    device_properties->maximum_threads_per_block = properties.maxThreadsPerBlock;
    device_properties->compute_capability = to_string(properties.major) + "." + to_string(properties.minor);
    device_properties->driver_version = driver_version;

    return device_properties;
}

std::vector<std::unique_ptr<Device_properties>> device_query::get_cuda_device_properties() {
    auto device_count = 0;
    const cudaError_t error_id = cudaGetDeviceCount(&device_count);
    vector<std::unique_ptr<Device_properties>> devices;

    if (error_id != cudaSuccess) {
        get_logger()->info("Error retrieving cuda device count: {}", cudaGetErrorString(error_id));
    }

    devices.reserve(device_count);
    for (auto device = 0; device < device_count; ++device) {
        devices.push_back(get_cuda_device_properties(&device));
    }

    return devices;
}

std::unique_ptr<Device_properties> device_query::get_cuda_device_properties(const int* device_indice) {
    int driver_version = 0;
    cudaDeviceProp properties{};
    const cudaError_t error_id = cudaGetDeviceProperties(&properties, *device_indice);

    if (error_id != cudaSuccess) {
        get_logger()->info("Invalid cuda device at: {0}, error: {1}", *device_indice, cudaGetErrorString(error_id));
        return nullptr;
    }
    cudaDriverGetVersion(&driver_version);

    return unique_ptr<Device_properties>(map_to_device_properties(properties, driver_version));
}
