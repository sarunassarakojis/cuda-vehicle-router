#pragma once

#include "library_exports.h"
#include "device_types.h"
#include <vector>

namespace device_query {

    using namespace device_types;

    /**
     * \brief Returns an array of properties for each CUDA.
     * 
     */
    LIBRARY_EXPORT std::vector<Device_properties> get_cuda_device_properties();

    /**
    * \brief Returns a single properties unit for CUDA capable 
    * device at \p device_indice or \p nullptr if device at given
    * indice does not exist.
    *
    * \param device_indice indice of the device in range of: 
    * \code [0, ::cudaGetDeviceCount(int*))
    */
    LIBRARY_EXPORT Device_properties* get_cuda_device_properties(int* device_indice);
}
