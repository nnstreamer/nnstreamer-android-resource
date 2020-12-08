#! /bin/bash
# SPDX-License-Identifier: Apache-2.0
##
# Copyright (C) 2020 Jihoon Lee <jhoon.it.lee@samsung.com>
#
# @file build_blas.sh
# @date 08 December 2020
# @brief This file is a helper tool to build android
# @author Jihoon lee <jhoon.it.lee@samsung.com>
#
# usage: ./build_blas.sh src_root ndk_root <install_path>
# if install path is not given, it is installed in $(pwd)
# src should be prepared before running this script
# this script is competible with https://github.com/xianyi/OpenBLAS/tree/v0.2.20
# not gauranteed to work for other versions

function _verify_dir {
    for var in "$@"
    do
      [ ! -d $var ] && echo "${var} does not exist, aborting" && exit 1
    done
}

function _verify_file {
    for var in "$@"
    do
      [ ! -f $var ] && echo "${var} does not exist, aborting" && exit 1
    done
}


# verification
[ -z $1 ] && echo "usage: ./build_blas.sh src_root ndk_root <install_path>" && exit 1
_verify_dir $1 $2

SRC_ROOT=$1
NDK_ROOT=$2

[ -z $3 ] && INSTALL_ROOT=$3 || INSTALL_ROOT=$(pwd)
_verify_dir $3

echo "building using ${NDK_ROOT} from ${SRC_ROOT}"

echo "setting up env variables"

TOOL_PATH=${NDK_ROOT}/toolchains/llvm/prebuilt/linux-x86_64
PLATFORM=aarch64-linux-android

pushd $SRC_ROOT
make clean

CC_PATH=$TOOL_PATH/bin/${PLATFORM}21-clang
AR_PATH=$TOOL_PATH/bin/${PLATFORM}-ar

_verify_file $CC_PATH $AR_PATH

# todo: verify below statement
# TARGET=CORTEXA57 is competible with armv8 with more optimization
make \
  TARGET=CORTEXA57 \
  ONLY_CBLAS=1 \
  CC=$CC_PATH \
  AR=$AR_PATH \
  HOSTCC=gcc \
  -j$(nproc)

make PREFIX=$INSTALL_ROOT install
popd
