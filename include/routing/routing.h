#pragma once

#include "library_exports.h"
#include "routing_types.h"

#include <vector>
#include <forward_list>

namespace routing {

    /**
     * \brief routes
     * 
     * \param nodes nodes
     * \param vehicle_capacity ca
     */
    LIBRARY_EXPORT std::forward_list<Route> route(std::vector<Node> nodes, unsigned vehicle_capacity);
}
