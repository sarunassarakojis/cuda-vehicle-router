#include "utilities/device/device_query.h"
#include "utilities/logging.h"
#include "routing/routing.h"

#include <iostream>
#include <chrono>

int main(int argc, char* argv[]) {
    using namespace device_types;
    using namespace routing;
    using namespace std;

    logging::create_logger();

    std::vector<Node> nodes;
    const Node n0{0, 1, -1, 0};
    const Node n1{1, 1, 1, 50};
    const Node n2{2, 2, 2, 50};
    const Node n3{3, 3, 3, 50};
    const Node n4{4, -1, 1, 25};
    const Node n5{5, -1, -2, 25};

    nodes.reserve(6);
    nodes.push_back(n0);
    nodes.push_back(n1);
    nodes.push_back(n2);
    nodes.push_back(n3);
    nodes.push_back(n4);
    nodes.push_back(n5);

    auto t1 = chrono::high_resolution_clock::now();
    auto routes = route(nodes, 50);
    auto t2 = chrono::high_resolution_clock::now();

    cout << chrono::duration_cast<chrono::milliseconds>(t2 - t1).count() << " mili sec\n";

    for (auto& iterator : routes) {
        cout << "Route: ";

        for (auto& node : iterator.nodes) {
            cout << node << " ";
        }
        cout << "| Total cost: " << iterator.met_demand << '\n';
    }

    // std::vector<std::unique_ptr<Device_properties>> properties = device_query::get_cuda_device_properties();
    // auto p = std::move(properties[0]);

    // std::cout << p->device_name << '\n';
    // std::cout << p->global_memory_in_mb << '\n';
    // std::cout << p->compute_capability << '\n';
}
