#pragma once

#include "library_exports.h"
#include "device_types.h"
#include <vector>
#include <memory>

namespace device_query {

    using namespace device_types;

    /**
     * \brief Returns an array of properties for each CUDA.
     * 
     * \return a vector of CUDA capable device properties.
     */
    LIBRARY_EXPORT std::vector<std::unique_ptr<Device_properties>> get_cuda_device_properties();

    /**
    * \brief Returns a single properties unit for CUDA capable 
    * device at \p device_indice or \p nullptr if device at given
    * indice does not exist.
    *
    * \param device_indice  indice of the device in range of: 
    * [0, ::cudaGetDeviceCount(int*)).
    * 
    * \return pointer to a device properties or nullptr if such 
    * device at given index does not exist.
    */
    LIBRARY_EXPORT std::unique_ptr<Device_properties> get_cuda_device_properties(const int* device_indice);
}
