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

std::forward_list<Route> routing::route(vector<Node> nodes, unsigned vehicle_capacity) {
    const int n = nodes.size();
    double** distance_matrix = get_distances_matrix(nodes);
    vector<Saving> savings;
    forward_list<Route> routes;
    unordered_set<long> added_nodes_index;

    added_nodes_index.reserve(n);
    savings.reserve(power_by_2(n));

    calculate_savings(savings, distance_matrix, n);
    sort(savings.begin(), savings.end(), [&](auto& s1, auto& s2) -> bool { return s1.saving > s2.saving; });

    // main algo
    for (size_t i = 0, savings_n = savings.size(); added_nodes_index.size() != n && i != savings_n; i++) {
        const auto saving = savings[i];
        const auto found_i = added_nodes_index.find(saving.node_i) != added_nodes_index.end();
        const auto found_j = added_nodes_index.find(saving.node_j) != added_nodes_index.end();

        if (!found_i && !found_j && nodes[saving.node_i].demand + nodes[saving.node_j].demand <= vehicle_capacity) {

            added_nodes_index.insert(saving.node_i);
            added_nodes_index.insert(saving.node_j);
            routes.push_front(Route{
                nodes[saving.node_i].demand + nodes[saving.node_j].demand,
                {saving.node_i, saving.node_j}
            });
        }
        else if (found_i && !found_j) {
            // TODO refactor
            for (auto iterator = routes.begin(); iterator != routes.end(); ++iterator) {
                if (iterator->nodes.front() == saving.node_i
                    && iterator->met_demand + saving.node_j <= vehicle_capacity) {
                    iterator->met_demand += nodes[saving.node_j].demand;
                    iterator->nodes.push_front(saving.node_j);
                    added_nodes_index.insert(saving.node_j);
                    break;
                }
                if (iterator->nodes.back() == saving.node_i
                    && iterator->met_demand + saving.node_j <= vehicle_capacity) {
                    iterator->met_demand += nodes[saving.node_j].demand;
                    iterator->nodes.push_back(saving.node_j);
                    added_nodes_index.insert(saving.node_j);
                    break;
                }
            }
        }
        else if (found_j && !found_i) {
            // TODO refactor
            for (auto iterator = routes.begin(); iterator != routes.end(); ++iterator) {
                if (iterator->nodes.front() == saving.node_j
                    && iterator->met_demand + saving.node_i <= vehicle_capacity) {
                    iterator->met_demand += nodes[saving.node_i].demand;
                    iterator->nodes.push_front(saving.node_i);
                    added_nodes_index.insert(saving.node_i);
                    break;
                }
                if (iterator->nodes.back() == saving.node_j
                    && iterator->met_demand + saving.node_i <= vehicle_capacity) {
                    iterator->met_demand += nodes[saving.node_i].demand;
                    iterator->nodes.push_back(saving.node_i);
                    added_nodes_index.insert(saving.node_i);
                    break;
                }
            }
        }
    }

    if (added_nodes_index.size() != n) {
        auto end = added_nodes_index.end();

        for (auto i = 1; i < n; ++i) {
            if (added_nodes_index.find(nodes[i].indice) == end) {
                routes.push_front(Route{nodes[i].demand, {nodes[i].indice}});
            }
        }
    }

    for (auto i = 0; i < n; i++) {
        delete[] distance_matrix[i];
    }
    delete[] distance_matrix;

    return routes;
}

std::forward_list<routing::Route> routing::route_parallel(std::vector<Node> nodes, unsigned vehicle_capacity) {
    return forward_list<Route>{};
}
