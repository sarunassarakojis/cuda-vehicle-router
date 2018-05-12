#pragma once

#include <list>

namespace routing {

    /**
     * \brief Represents a node in the graph
     * or less formally - a single customer 
     * in a set of all customers.
     */
    struct LIBRARY_EXPORT Node {
        long indice;
        long x;
        long y;
        unsigned demand;
    };

    /**
     *\brief Represents a saving between adjacent
     * \p nodes.
     */
    struct LIBRARY_EXPORT Saving {
        long node_i;
        long node_j;
        double saving;

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
}
