#include "routing/routing.h"
#include "utilities/logging.h"

#include <thrust/device_ptr.h>
#include <thrust/sort.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>
#include <algorithm>
#include <forward_list>
#include <unordered_set>

using namespace std;
using namespace routing;
using namespace logging;

struct Savings_ordering_desc {

    __host__ __device__ bool operator()(Saving& s1, Saving& s2) const {
        return s1.saving > s2.saving;
    }
};

inline float power_by_2(const float& x) {
    return powf(x, 2);
}

inline float** get_distances_matrix(vector<Node>& nodes) {
    const int n = nodes.size();
    float** distance_matrix = new float*[n];

    for (int i = 0; i < n; ++i) {
        distance_matrix[i] = new float[n];

        for (int j = 0; j < n; j++) {
            auto d = sqrtf(power_by_2(nodes[i].x - nodes[j].x) + power_by_2(nodes[i].y - nodes[j].y));

            distance_matrix[i][j] = d;
        }
    }

    return distance_matrix;
}

inline void calculate_savings(vector<Saving>& savings, float** distance_matrix, const int& size) {
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
                                   Node* nodes, int& size, unsigned& capacity) {
    auto end = added_nodes.end();

    for (auto i = 1; i < size; ++i) {
        if (added_nodes.find(nodes[i].indice) == end
            && nodes[i].demand <= capacity) {
            routes.push_front(Route{nodes[i].demand, {nodes[i].indice}});
        }
    }
}

std::forward_list<Route> routing::route(vector<Node> nodes, unsigned vehicle_capacity) {
    int size = nodes.size();
    float** distance_matrix = get_distances_matrix(nodes);
    vector<Saving> savings;
    forward_list<Route> routes;
    unordered_set<long> added_nodes;

    added_nodes.reserve(size);
    savings.reserve(power_by_2(size));

    calculate_savings(savings, distance_matrix, size);
    sort(savings.begin(), savings.end(), [&](auto& s1, auto& s2) -> bool { return s1.saving > s2.saving; });

    for (size_t i = 0, savings_n = savings.size(); added_nodes.size() != size - 1 && i != savings_n; i++) {
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

    if (added_nodes.size() != size - 1) {
        add_unoptimized_routes(added_nodes, routes, &nodes[0], size, vehicle_capacity);
    }

    for (auto i = 0; i < size; i++) {
        delete[] distance_matrix[i];
    }
    delete[] distance_matrix;

    return routes;
}

inline void log_cuda_error(cudaError_t error, char* message = "CUDA error: {}") {
    get_logger()->error(message, cudaGetErrorString(error));
}

__global__ void calculate_distance_matrix(Node* nodes, float* distance_matrix, int size) {
    int x = blockDim.x * blockIdx.x + threadIdx.x;
    int y = blockDim.y * blockIdx.y + threadIdx.y;

    if (x < size && y < size) {
        distance_matrix[size * y + x] = sqrtf(
            powf(nodes[x].x - nodes[y].x, 2) + powf(nodes[x].y - nodes[y].y, 2));
    }
}

__global__ void calculate_savings(float* distance_matrix, Saving* savings, int size) {
    int y = blockDim.x * blockIdx.x + threadIdx.x;
    int x = blockDim.y * blockIdx.y + threadIdx.y;

    if (y > 0 && x > 0 && x < size && y < size) {
        int array_index = (size - 1) * (y - 1) + (x - 1);
        Saving& saving = savings[array_index];

        saving.node_i = x;
        saving.node_j = y;
        saving.saving = x != y ? distance_matrix[y] + distance_matrix[x] - distance_matrix[size * x + y] : 0;
    }
}

inline void sort_savings_desc(Saving* savings, int& savings_size) {
    thrust::sort(thrust::device_ptr<Saving>(savings),
                 thrust::device_ptr<Saving>(savings + savings_size), Savings_ordering_desc());
}

forward_list<Route> routing::route_parallel(Node* nodes, int size, unsigned vehicle_capacity,
                                            Thread_config configuration) {
    auto savings_size = (size - 1) * (size - 1);
    float* distance_matrix_d;
    Node* nodes_d;
    Saving* savings_h = new Saving[savings_size];
    Saving* savings_d;
    forward_list<Route> routes;
    unordered_set<long> added_nodes;

    cudaError_t error = cudaMalloc((void**)&distance_matrix_d, size * size * sizeof(float));

    if (error != cudaSuccess) {
        log_cuda_error(error);
        goto cleanup;
    }

    error = cudaMalloc((void**)&nodes_d, size * sizeof(Node));

    if (error != cudaSuccess) {
        log_cuda_error(error);
        goto cleanup;
    }

    error = cudaMalloc((void**)&savings_d, savings_size * sizeof(Saving));

    if (error != cudaSuccess) {
        log_cuda_error(error);
        goto cleanup;
    }

    error = cudaMemcpy(nodes_d, nodes, size * sizeof(Node), cudaMemcpyHostToDevice);

    if (error != cudaSuccess) {
        log_cuda_error(error);
        goto cleanup;
    }

    dim3 threads_per_block(configuration.threads_per_block_x, configuration.threads_per_block_y);
    dim3 block_dim(size / threads_per_block.x + 1, size / threads_per_block.y + 1);

    calculate_distance_matrix<<<block_dim, threads_per_block>>>(nodes_d, distance_matrix_d, size);
    calculate_savings<<<block_dim, threads_per_block>>>(distance_matrix_d, savings_d, size);
    sort_savings_desc(savings_d, savings_size);

    error = cudaMemcpy(savings_h, savings_d, savings_size * sizeof(Saving), cudaMemcpyDeviceToHost);

    if (error != cudaSuccess) {
        log_cuda_error(error);
        goto cleanup;
    }

    for (auto i = 0; i < savings_size && added_nodes.size() != size - 1; ++i) {
        const auto saving = savings_h[i];
        auto node_i = saving.node_i;
        auto node_j = saving.node_j;
        auto node_i_demand = nodes[node_i].demand;
        auto node_j_demand = nodes[node_j].demand;
        const auto found_i = added_nodes.find(node_i) != added_nodes.end();
        const auto found_j = added_nodes.find(node_j) != added_nodes.end();

        if (node_i != node_j && !found_i && !found_j && node_i_demand + node_j_demand <= vehicle_capacity) {
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

    if (added_nodes.size() != size - 1) {
        add_unoptimized_routes(added_nodes, routes, nodes, size, vehicle_capacity);
    }

cleanup:
    delete[] savings_h;
    cudaFree(nodes_d);
    cudaFree(distance_matrix_d);
    cudaFree(savings_d);

    return routes;
}
