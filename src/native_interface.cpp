#include <cstdio>
#include <jni.h>
#include "native_interface.h"

JNIEXPORT void JNICALL Java_com_vehicle_router_NativeLibraryRunner_helloNative(JNIEnv* env, jobject object) {
	printf("Hello world !\n");
}
