# CUDA vehicle router

## Prerequisites
Required toolsets for _win64_:
 * _CUDA_ 9.1.85 Toolkit (x86_64);
 * Visual Studio 15 2017;
 * Platform toolset: Visual Studio 2015 _v140_ (v141 is not supported by the _nvcc_ yet);
 * CMake 3.10+
 
## Generating Visual Studio solution
Create a directory named _build_ in the project root:<br/>
```
mkdir build
```
_cd_ into new directory:
```
cd build/
```
Run _CMake_:
```
cmake "-DCMAKE_TOOLCHAIN_FILE=<path to vcpkg>\vcpkg\scripts\buildsystems\vcpkg.cmake" 
      -G "Visual Studio 15 2017 Win64"
      -T v140,host=x64 ..
```
