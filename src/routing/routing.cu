#include "routing/routing.h"

#include <iostream>
#include <algorithm>
#include <forward_list>
#include <unordered_set>

using namespace std;
using namespace routing;

inline double power_by_2(const double& x) {
    return pow(x, 2);
}

inline double** get_distances_matrix(vector<Node>& nodes) {
    const int n = nodes.size();
    double** distance_matrix = new double*[n];

    for (int i = 0; i < n; ++i) {
        distance_matrix[i] = new double[n];

        for (int j = 0; j < n; j++) {
            double d = sqrt(power_by_2(nodes[i].x - nodes[j].x) + power_by_2(nodes[i].y - nodes[j].y));

            distance_matrix[i][j] = d;
        }
    }

    return distance_matrix;
}

inline void calculate_savings(vector<Saving>& savings, double** distance_matrix, const int& size) {
    for (int i = 1; i < size; ++i) {
        for (int j = i + 1; j < size; ++j) {
            savings.push_back(Saving{
                i, j, distance_matrix[0][i] + distance_matrix[0][j] - distance_matrix[i][j]
            });
        }
    }
}

inline void append_new_node_to_route(forward_list<Route>& routes, long& found_node, long& new_node,
                                     unsigned& capacity, unsigned& node_demand, unordered_set<long>& added_nodes) {

    for (auto iterator = routes.begin(); iterator != routes.end(); ++iterator) {
        if (iterator->nodes.front() == found_node && iterator->met_demand + node_demand <= capacity) {
            iterator->met_demand += node_demand;
            iterator->nodes.push_front(new_node);
            added_nodes.insert(new_node);
            break;
        }
        if (iterator->nodes.back() == found_node && iterator->met_demand + node_demand <= capacity) {
            iterator->met_demand += node_demand;
            iterator->nodes.push_back(new_node);
            added_nodes.insert(new_node);
            break;
        }
    }
}

inline void add_unoptimized_routes(unordered_set<long>& added_nodes, forward_list<Route>& routes,
    vector<Node>& nodes, const int& size, const unsigned& capacity) {
    auto end = added_nodes.end();

    for (auto i = 1; i < size; ++i) {
        if (added_nodes.find(nodes[i].indice) == end
            && nodes[i].demand <= capacity) {
            routes.push_front(Route{ nodes[i].demand,{ nodes[i].indice } });
        }
    }
}

std::forward_list<Route> routing::route(vector<Node> nodes, unsigned vehicle_capacity) {
    const int n = nodes.size();
    double** distance_matrix = get_distances_matrix(nodes);
    vector<Saving> savings;
    forward_list<Route> routes;
    unordered_set<long> added_nodes;

    added_nodes.reserve(n);
    savings.reserve(power_by_2(n));

    calculate_savings(savings, distance_matrix, n);
    sort(savings.begin(), savings.end(), [&](auto& s1, auto& s2) -> bool { return s1.saving > s2.saving; });

    for (size_t i = 0, savings_n = savings.size(); added_nodes.size() != n && i != savings_n; i++) {
        const auto saving = savings[i];
        auto node_i = saving.node_i;
        auto node_j = saving.node_j;
        auto node_i_demand = nodes[node_i].demand;
        auto node_j_demand = nodes[node_j].demand;
        const auto found_i = added_nodes.find(node_i) != added_nodes.end();
        const auto found_j = added_nodes.find(node_j) != added_nodes.end();

        if (!found_i && !found_j && node_i_demand + node_j_demand <= vehicle_capacity) {
            added_nodes.insert(node_i);
            added_nodes.insert(node_j);
            routes.push_front(Route{node_i_demand + node_j_demand, {node_i, node_j}});
        }
        else if (found_i && !found_j) {
            append_new_node_to_route(routes, node_i, node_j, vehicle_capacity, node_j_demand, added_nodes);
        }
        else if (found_j && !found_i) {
            append_new_node_to_route(routes, node_j, node_i, vehicle_capacity, node_i_demand, added_nodes);
        }
    }

    if (added_nodes.size() != n) {
        add_unoptimized_routes(added_nodes, routes, nodes, n, vehicle_capacity);
    }

    for (auto i = 0; i < n; i++) {
        delete[] distance_matrix[i];
    }
    delete[] distance_matrix;

    return routes;
}

forward_list<Route> routing::route_parallel(vector<Node> nodes, unsigned vehicle_capacity) {
    return forward_list<Route>{};
}
