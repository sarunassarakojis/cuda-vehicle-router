#pragma once

namespace routing_types {
    
    struct Node {
        long x;
        long y;
        long unsigned demand;
    };

    struct Route {
        Node begin;
        Node end;
    };
}