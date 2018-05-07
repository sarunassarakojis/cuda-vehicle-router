#pragma once

namespace routing {
    
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