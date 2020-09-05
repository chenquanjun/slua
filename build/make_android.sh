#!/bin/bash

if [ -z "$NDKPATH" ]; then
    echo "Android NDK not detected'"
    exit 1
fi

CMAKE=$CMAKE_PATH
NDK=$NDKPATH

function make_for() {
	ROOT=$1
	BUILD_DIR=$ROOT/$2
	ANDROID_ABI=$3
	TOOLCHAIN=$ROOT/cmake/android/android.toolchain.cmake

	if [ ! -d $BUILD_DIR ]; then
		mkdir $BUILD_DIR
	fi

	cd $BUILD_DIR

	$CMAKE -DCMAKE_TOOLCHAIN_FILE=$TOOLCHAIN        \
		   -DANDROID_NDK=$NDK                       \
		   -DANDROID_FORCE_ARM_BUILD="ON"           \
		   -DANDROID_NATIVE_API_LEVEL=18            \
		   -DANDROID_ABI=$ANDROID_ABI               \
	       $ROOT

	cd $ROOT

	$CMAKE --build $BUILD_DIR --config Release
}

make_for `pwd` build_android_v7a "armeabi-v7a with NEON"
make_for `pwd` build_android_x86 "x86"
make_for `pwd` build_android_arm64 "arm64-v8a"

if [ "$?" == "0" ]; then
	cp -v build_android_v7a/libslua.so ../Assets/Plugins/Android/libs/armeabi-v7a/libslua.so
	cp -v build_android_x86/libslua.so ../Assets/Plugins/Android/libs/x86/libslua.so
	cp -v build_android_arm64/libslua.so ../Assets/Plugins/Android/libs/armeabi-arm64/libslua.so
fi

