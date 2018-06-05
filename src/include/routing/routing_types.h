#pragma once

#include <list>

namespace routing {

    /**
     * \brief Represents a node in the graph
     * or less formally - a single customer 
     * in a set of all customers.
     */
    struct LIBRARY_API Node {
        long indice;
        long x;
        long y;
        unsigned demand;
    };

    /**
     *\brief Represents a saving between adjacent
     * \p nodes.
     */
    struct LIBRARY_API Saving {
        long node_i;
        long node_j;
        float saving;

        bool operator<(Saving& other) const {
            return this->saving < other.saving;
        }
    };

    /**
     * \brief 
     */
    struct Route {
        unsigned met_demand;
        std::list<long> nodes;
    };

    /**
     * \brief 
     */
    struct Thread_config {
        int threads_per_block_x;
        int threads_per_block_y;
    };
}
