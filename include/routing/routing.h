#pragma once

#include "library_exports.h"
#include "routing_types.h"

#include <vector>
#include <forward_list>

namespace routing {

    /**
     * \brief Attempts to optimize routes that visit all of the specified \p nodes. All of the
     * returned routes visit each node at least and at most once. Constraints, such as
     * \p vehicle_capacity are taken into account when merging routes.
     * This is a sequential implementation of Clarke and Wright algorithm that calculates distances
     * between all \p nodes, savings and performs one iteration from the biggest saving in
     * the list.
     * 
     * \param nodes             represents a list of customers - delivery endpoints
     * \param vehicle_capacity  a non - negative maximum vehicle capacity per route
     */
    LIBRARY_API std::forward_list<Route> route(std::vector<Node> nodes, unsigned vehicle_capacity);

    /**
     * \brief Attempts to optimize routes that visit all of the specified \p nodes. All of the
     * returned routes visit each node at least and at most once. Constraints, such as
     * \p vehicle_capacity are taken into account when merging routes.
     * This is a parallel implementation of Clarke and Wright algorithm where the most intensive
     * floating point calculations are executed on a parallel device (\p CUDA - capable device) 
     * such as distances matrix computations, savings and sorting.
     * 
     * \param nodes             represents a list of customers - delivery endpoints
     * \param size              amount of nodes
     * \param vehicle_capacity  a non - negative maximum vehicle capacity per route
     * \param configuration     'threads per block' configuration, default is 16x16 per block.
     *                          If data does not fit in a single block, additional blocks 
     *                          are added as neccessary
     */
    LIBRARY_API std::forward_list<Route> route_parallel(Node* nodes, int size, unsigned vehicle_capacity,
                                                        Thread_config configuration = {16, 16});
}
