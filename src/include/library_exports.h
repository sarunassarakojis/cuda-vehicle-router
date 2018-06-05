
#ifndef LIBRARY_API_H
#define LIBRARY_API_H

#ifdef CUDA_VEHICLE_ROUTER_LIB_STATIC_DEFINE
#  define LIBRARY_API
#  define CUDA_VEHICLE_ROUTER_LIB_NO_EXPORT
#else
#  ifndef LIBRARY_API
#    ifdef cuda_vehicle_router_lib_EXPORTS
        /* We are building this library */
#      define LIBRARY_API __declspec(dllexport)
#    else
        /* We are using this library */
#      define LIBRARY_API __declspec(dllimport)
#    endif
#  endif

#  ifndef CUDA_VEHICLE_ROUTER_LIB_NO_EXPORT
#    define CUDA_VEHICLE_ROUTER_LIB_NO_EXPORT 
#  endif
#endif

#ifndef CUDA_VEHICLE_ROUTER_LIB_DEPRECATED
#  define CUDA_VEHICLE_ROUTER_LIB_DEPRECATED __declspec(deprecated)
#endif

#ifndef CUDA_VEHICLE_ROUTER_LIB_DEPRECATED_EXPORT
#  define CUDA_VEHICLE_ROUTER_LIB_DEPRECATED_EXPORT LIBRARY_API CUDA_VEHICLE_ROUTER_LIB_DEPRECATED
#endif

#ifndef CUDA_VEHICLE_ROUTER_LIB_DEPRECATED_NO_EXPORT
#  define CUDA_VEHICLE_ROUTER_LIB_DEPRECATED_NO_EXPORT CUDA_VEHICLE_ROUTER_LIB_NO_EXPORT CUDA_VEHICLE_ROUTER_LIB_DEPRECATED
#endif

#if 0 /* DEFINE_NO_DEPRECATED */
#  ifndef CUDA_VEHICLE_ROUTER_LIB_NO_DEPRECATED
#    define CUDA_VEHICLE_ROUTER_LIB_NO_DEPRECATED
#  endif
#endif

#endif
