#------------------------------------------------------
# tensorflow-lite
#
# This mk file is to build a static library from cloned tensorflow repository.
# To utilize and build a new version, you have to define the root directory and check Makefile to build tensorflow-lite.
# Now this file is to build tensorflow-lite from tizen tensorflow repository with version 1.15.2.
#------------------------------------------------------
LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := tensorflow-lite

# Need to set tensorflow root dir
ifndef TENSORFLOW_ROOT
$(error TENSORFLOW_ROOT is not defined!)
endif

# Set tensorflow-lite dir (TODO change this with tensorflow-lite version)
TF_LITE_DIR := $(TENSORFLOW_ROOT)/tensorflow/lite
DOWNLOADS_DIR := $(TF_LITE_DIR)/tools/make/downloads

# Set files to compile (TODO check Makefile to build tensorflow-lite)
CORE_CC_ALL_SRCS := \
    $(wildcard $(TF_LITE_DIR)/*.cc) \
    $(wildcard $(TF_LITE_DIR)/*.c) \
    $(wildcard $(TF_LITE_DIR)/c/*.c) \
    $(wildcard $(TF_LITE_DIR)/core/*.cc) \
    $(wildcard $(TF_LITE_DIR)/core/api/*.cc) \
    $(TF_LITE_DIR)/experimental/resource_variable/*.cc \
    $(TF_LITE_DIR)/experimental/ruy/allocator.cc \
    $(TF_LITE_DIR)/experimental/ruy/block_map.cc \
    $(TF_LITE_DIR)/experimental/ruy/blocking_counter.cc \
    $(TF_LITE_DIR)/experimental/ruy/context.cc \
    $(TF_LITE_DIR)/experimental/ruy/detect_dotprod.cc \
    $(TF_LITE_DIR)/experimental/ruy/kernel_arm32.cc \
    $(TF_LITE_DIR)/experimental/ruy/kernel_arm64.cc \
    $(TF_LITE_DIR)/experimental/ruy/pack_arm.cc \
    $(TF_LITE_DIR)/experimental/ruy/pmu.cc \
    $(TF_LITE_DIR)/experimental/ruy/thread_pool.cc \
    $(TF_LITE_DIR)/experimental/ruy/trace.cc \
    $(TF_LITE_DIR)/experimental/ruy/trmul.cc \
    $(TF_LITE_DIR)/experimental/ruy/tune.cc \
    $(TF_LITE_DIR)/experimental/ruy/wait.cc \
    $(wildcard $(TF_LITE_DIR)/kernels/*.cc) \
    $(wildcard $(TF_LITE_DIR)/kernels/internal/*.cc) \
    $(wildcard $(TF_LITE_DIR)/kernels/internal/optimized/*.cc) \
    $(wildcard $(TF_LITE_DIR)/kernels/internal/reference/*.cc) \
    $(TF_LITE_DIR)/profiling/time.cc \
    $(DOWNLOADS_DIR)/farmhash/src/farmhash.cc \
    $(DOWNLOADS_DIR)/fft2d/fftsg.c \
    $(DOWNLOADS_DIR)/flatbuffers/src/util.cpp

# NNAPI
CORE_CC_ALL_SRCS += \
    $(TF_LITE_DIR)/delegates/nnapi/nnapi_delegate.cc \
    $(TF_LITE_DIR)/delegates/nnapi/quant_lstm_sup.cc \
    $(TF_LITE_DIR)/nnapi/nnapi_implementation.cc

# Remove any duplicates.
CORE_CC_ALL_SRCS := $(sort $(CORE_CC_ALL_SRCS))
CORE_CC_EXCLUDE_SRCS := \
    $(wildcard $(TF_LITE_DIR)/*test.cc) \
    $(wildcard $(TF_LITE_DIR)/*/*test.cc) \
    $(wildcard $(TF_LITE_DIR)/*/*/*test.cc) \
    $(wildcard $(TF_LITE_DIR)/*/*/*/*test.cc) \
    $(wildcard $(TF_LITE_DIR)/kernels/*test_main.cc) \
    $(wildcard $(TF_LITE_DIR)/kernels/*test_util.cc) \
    $(TF_LITE_DIR)/examples/minimal/minimal.cc \
    $(TF_LITE_DIR)/mmap_allocation.cc \
    $(TF_LITE_DIR)/minimal_logging_default.cc \
    $(TF_LITE_DIR)/minimal_logging_ios.cc

# Filter out all the excluded files.
TF_LITE_CC_SRCS := $(filter-out $(CORE_CC_EXCLUDE_SRCS), $(CORE_CC_ALL_SRCS))
TF_LITE_INCLUDES := \
    $(ANDROID_NDK_ROOT)/../ \
    $(TENSORFLOW_ROOT) \
    $(DOWNLOADS_DIR)/ \
    $(DOWNLOADS_DIR)/eigen \
    $(DOWNLOADS_DIR)/absl \
    $(DOWNLOADS_DIR)/gemmlowp \
    $(DOWNLOADS_DIR)/neon_2_sse \
    $(DOWNLOADS_DIR)/farmhash/src \
    $(DOWNLOADS_DIR)/flatbuffers/include

LOCAL_SRC_FILES := $(TF_LITE_CC_SRCS)
LOCAL_C_INCLUDES := $(TF_LITE_INCLUDES)

LOCAL_CFLAGS += -O2 -DNDEBUG -fPIC
# std for toolchain in NDK
# rtti for typecast in tensorflow-lite
# exceptions to enable exception handling in tensorflow-lite
LOCAL_CXXFLAGS += -std=c++11 -frtti -fexceptions -O2 -DNDEBUG -fPIC

include $(BUILD_STATIC_LIBRARY)
