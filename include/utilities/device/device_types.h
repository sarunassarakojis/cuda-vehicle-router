#pragma once

#include <string>

namespace device_types {

    /**
     * Provides various properties for the \p CUDA
     * capable device.
     */
    struct Device_properties {
        /**
         * ASCII string identifying the device.
         */
        std::string device_name;

        /**
         * Total global memory available in \p megabytes.
         */
        size_t global_memory_in_mb = 0;

        /**
         * Maximum number of threads per block.
         */
        int maximum_threads_per_block = 0;

        /**
         * Defines a version of the installed CUDA driver.
         */
        int driver_version = 0;

        /**
         * Defines a compute capability for the device
         * in the form of:\code [major].[minor]}
         */
        std::string compute_capability;
    };
}
