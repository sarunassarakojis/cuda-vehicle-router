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
    LIBRARY_API std::forward_list<Route> route(std::vector<Node> nodes, unsigned vehicle_capacity);

    /**
    * \brief routes
    *
    * \param nodes nodes
    * \param vehicle_capacity ca
    * \param configuration
    */
    LIBRARY_API std::forward_list<Route> route_parallel(Node* nodes, int size, unsigned vehicle_capacity,
                                                        Thread_config configuration = {16, 16});
}
