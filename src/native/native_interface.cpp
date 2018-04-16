#include <cstdio>
#include <jni.h>
#include "native_interface.h"
#include "../router_library.h"

JNIEXPORT void JNICALL Java_com_vehicle_router_NativeLibraryRunner_helloNative(JNIEnv* env, jobject object) {
	printf("Launching kernel!\n");

	vr::executeInParallel();
}
