#include "routing/routing.h"

#include <iostream>
#include <cuda_runtime.h>
#include <algorithm>
#include <forward_list>
#include <unordered_set>

inline double power_by_2(const double& x) {
    return pow(x, 2);
}

template <typename T>
void print_out(T** matrix, const int& size) {
    for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {
            std::cout << matrix[i][j] << " ";
        }
        std::cout << "\n";
    }
}

std::forward_list<routing::Route> routing::route(std::vector<Node> nodes, unsigned vehicle_capacity) {
    using namespace std;

    const int n = nodes.size();
    double** distance_matrix = new double*[n];
    vector<Saving> savings;
    forward_list<Route> routes;
    unordered_set<long> added_nodes_index;

    added_nodes_index.reserve(n);

    // distance matrix calculation
    for (int i = 0; i < n; i++) {
        distance_matrix[i] = new double[n];

        for (int j = 0; j < n; j++) {
            double d = sqrt(power_by_2(nodes[i].x - nodes[j].x) + power_by_2(nodes[i].y - nodes[j].y));

            distance_matrix[i][j] = d;
        }
    }

    cout << "Distance matrix:" << '\n';
    print_out(distance_matrix, n);

    // savings calculation
    savings.reserve(power_by_2(n));
    for (int i = 1; i < n; i++) {
        for (int j = 1; j < n; j++) {
            if (i != j) {
                double saving = distance_matrix[0][i] + distance_matrix[0][j] - distance_matrix[i][j];

                savings.push_back(Saving{i, j, saving});
            }
        }
    }

    // sort saving in descending order
    sort(savings.begin(), savings.end(), [&](auto& s1, auto& s2) -> bool { return s1.saving > s2.saving; });

    cout << "\nSavings sorted:" << '\n';
    for (auto& s : savings) {
        printf("s(%d, %d) = %f\n", s.node_i, s.node_j, s.saving);
    }

    // main algo
    for (auto& saving : savings) {
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
            // TODO also check if constraints are not violated
            // TODO update route_cost as well
            for (auto iterator = routes.begin(); iterator != routes.end(); ++iterator) {
                if (iterator->nodes.front() == saving.node_i) {
                    iterator->nodes.push_front(saving.node_j);
                    added_nodes_index.insert(saving.node_j);
                    break;
                }
                if (iterator->nodes.back() == saving.node_i) {
                    iterator->nodes.push_back(saving.node_j);
                    added_nodes_index.insert(saving.node_j);
                    break;
                }
            }
        }
        else if (found_j && !found_i) {
            // TODO refactor
            // TODO also check if constraints are not violated
            // TODO update route_cost as well
            for (auto iterator = routes.begin(); iterator != routes.end(); ++iterator) {
                if (iterator->nodes.front() == saving.node_j) {
                    iterator->nodes.push_front(saving.node_i);
                    added_nodes_index.insert(saving.node_i);
                    break;
                }
                if (iterator->nodes.back() == saving.node_j) {
                    iterator->nodes.push_back(saving.node_i);
                    added_nodes_index.insert(saving.node_i);
                    break;
                }
            }
        }

    }

    for (auto i = 0; i < n; i++) {
        delete[] distance_matrix[i];
    }
    delete[] distance_matrix;

    return routes;
}
