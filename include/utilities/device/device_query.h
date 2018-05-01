#pragma once

#include "library_exports.h"
#include "device_types.h"

namespace device_query {

    using namespace device_types;

    /// <summary>
    /// Returns an array of properties for each CUDA device.
    /// </summary>
    ///
    /// <param name="devices">an array of device properties</param>
    /// <param name="size">size of the array</param>
    LIBRARY_EXPORT void get_cuda_device_properties(Device_properties* devices, unsigned& size);
}
