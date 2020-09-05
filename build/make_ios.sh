#!/bin/bash

CMAKE=cmake

function make_for() {
	ROOT=$1
	BUILD_DIR=$ROOT/$2
	TOOLCHAIN=$ROOT/cmake/ios/ios.toolchain.cmake

	if [ ! -d $BUILD_DIR ]; then
		mkdir $BUILD_DIR
	fi

	cd $BUILD_DIR

	$CMAKE -DCMAKE_TOOLCHAIN_FILE=$TOOLCHAIN   \
		   -DIOS_PLATFORM="OS"                 \
		   -DIOS_DEPLOYMENT_TARGET="8.0"       \
		   -DENABLE_BITCODE="true"             \
		   -G Xcode                            \
		   $ROOT

	cd $ROOT

	$CMAKE --build $BUILD_DIR --config Release
}

make_for `pwd` build_ios

if [ "$?" == "0" ]; then
	cp -v build_ios/Release-iphoneos/libslua.a ../Assets/Plugins/iOS/libslua.a
fi

