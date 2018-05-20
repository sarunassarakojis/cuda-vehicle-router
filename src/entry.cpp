#include "utilities/device/device_query.h"
#include "utilities/logging.h"
#include "routing/routing.h"

#include <iostream>
#include <chrono>

using namespace device_types;
using namespace routing;
using namespace std;

std::vector<Node> get_dataset_1() {
    std::vector<Node> nodes;

    nodes.reserve(6);
    nodes.push_back(Node{0, 1, -1, 0});
    nodes.push_back(Node{1, 1, 1, 50});
    nodes.push_back(Node{2, 2, 2, 50});
    nodes.push_back(Node{3, 3, 3, 50});
    nodes.push_back(Node{4, -1, 1, 25});
    nodes.push_back(Node{5, -1, -2, 25});

    return nodes;
}

std::vector<Node> get_dataset_2() {
    std::vector<Node> nodes;

    nodes.reserve(6);
    nodes.push_back(Node{0, 1, -1, 0});
    nodes.push_back(Node{1, 1, 1, 50});
    nodes.push_back(Node{2, 2, 2, 50});
    nodes.push_back(Node{3, 3, 3, 50});
    nodes.push_back(Node{4, -1, 1, 25});
    nodes.push_back(Node{5, -1, -2, 25});
    nodes.push_back(Node{6, -5, -10, 100});
    nodes.push_back(Node{7, 0, 0, 25});

    return nodes;
}

int main(int argc, char* argv[]) {
    logging::create_logger();


    auto t1 = chrono::high_resolution_clock::now();
    auto set = get_dataset_2();
    auto routes = route_parallel(&set[0], set.size(), 100);
    auto t2 = chrono::high_resolution_clock::now();

    cout << chrono::duration_cast<chrono::milliseconds>(t2 - t1).count() << " mili sec\n";

    for (auto& iterator : routes) {
        cout << "Route: ";

        for (auto& node : iterator.nodes) {
            cout << node << " ";
        }
        cout << "| Total cost: " << iterator.met_demand << '\n';
    }

    /*std::vector<std::unique_ptr<Device_properties>> properties = device_query::get_cuda_device_properties();
    auto p = std::move(properties[0]);

    std::cout << p->device_name << '\n';
    std::cout << p->global_memory_in_mb << '\n';
    std::cout << p->maximum_threads_per_block << '\n';
    std::cout << p->compute_capability << '\n';*/
}
