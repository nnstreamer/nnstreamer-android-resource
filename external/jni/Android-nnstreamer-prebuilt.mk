#------------------------------------------------------
# nnstreamer
#
# This mk file defines nnstreamer module with prebuilt shared libraries.
# ABI: armeabi-v7a, arm64-v8a
#------------------------------------------------------
LOCAL_PATH := $(call my-dir)

NNSTREAMER_DIR := $(LOCAL_PATH)/nnstreamer

NNSTREAMER_INCLUDES := $(NNSTREAMER_DIR)/include
NNSTREAMER_LIB_PATH := $(NNSTREAMER_DIR)/lib/$(TARGET_ARCH_ABI)

ENABLE_SNAP := false
ENABLE_NNFW := false

#------------------------------------------------------
# nnstreamer native
#------------------------------------------------------
include $(CLEAR_VARS)

LOCAL_MODULE := nnstreamer-native

LOCAL_SRC_FILES := $(NNSTREAMER_LIB_PATH)/libnnstreamer-native.so

include $(PREBUILT_SHARED_LIBRARY)

#------------------------------------------------------
# gstreamer android
#------------------------------------------------------
include $(CLEAR_VARS)

LOCAL_MODULE := gst-android

LOCAL_SRC_FILES := $(NNSTREAMER_LIB_PATH)/libgstreamer_android.so

include $(PREBUILT_SHARED_LIBRARY)

#------------------------------------------------------
# c++ shared
#------------------------------------------------------
include $(CLEAR_VARS)

LOCAL_MODULE := cpp-shared

LOCAL_SRC_FILES := $(NNSTREAMER_LIB_PATH)/libc++_shared.so

include $(PREBUILT_SHARED_LIBRARY)

#------------------------------------------------------
# snap sdk (arm64-v8a only)
#------------------------------------------------------
ifeq ($(ENABLE_SNAP), true)
include $(CLEAR_VARS)

LOCAL_MODULE := snap-sdk

LOCAL_SRC_FILES := $(NNSTREAMER_LIB_PATH)/libsnap_vndk.so

include $(PREBUILT_SHARED_LIBRARY)
endif

#------------------------------------------------------
# NNFW prebuilt libraries (arm64-v8a only)
#------------------------------------------------------
ifeq ($(ENABLE_NNFW), true)
NNFW_PREBUILT_LIBS :=

include $(CLEAR_VARS)
NNFW_PREBUILT_LIBS += nnfw-libbackend_cpu
LOCAL_MODULE := nnfw-libbackend_cpu
LOCAL_SRC_FILES := $(NNSTREAMER_LIB_PATH)/libbackend_cpu.so
include $(PREBUILT_SHARED_LIBRARY)

include $(CLEAR_VARS)
NNFW_PREBUILT_LIBS += nnfw-libcircle_loader
LOCAL_MODULE := nnfw-libcircle_loader
LOCAL_SRC_FILES := $(NNSTREAMER_LIB_PATH)/libcircle_loader.so
include $(PREBUILT_SHARED_LIBRARY)

include $(CLEAR_VARS)
NNFW_PREBUILT_LIBS += nnfw-libneuralnetworks
LOCAL_MODULE := nnfw-libneuralnetworks
LOCAL_SRC_FILES := $(NNSTREAMER_LIB_PATH)/libneuralnetworks.so
include $(PREBUILT_SHARED_LIBRARY)

include $(CLEAR_VARS)
NNFW_PREBUILT_LIBS += nnfw-libneurun_core
LOCAL_MODULE := nnfw-libneurun_core
LOCAL_SRC_FILES := $(NNSTREAMER_LIB_PATH)/libneurun_core.so
include $(PREBUILT_SHARED_LIBRARY)

include $(CLEAR_VARS)
NNFW_PREBUILT_LIBS += nnfw-libnnfw-dev
LOCAL_MODULE := nnfw-libnnfw-dev
LOCAL_SRC_FILES := $(NNSTREAMER_LIB_PATH)/libnnfw-dev.so
include $(PREBUILT_SHARED_LIBRARY)

include $(CLEAR_VARS)
NNFW_PREBUILT_LIBS += nnfw-libtflite_loader
LOCAL_MODULE := nnfw-libtflite_loader
LOCAL_SRC_FILES := $(NNSTREAMER_LIB_PATH)/libtflite_loader.so
include $(PREBUILT_SHARED_LIBRARY)
endif

#------------------------------------------------------
# define required libraries for nnstreamer
#------------------------------------------------------
NNSTREAMER_LIBS := nnstreamer-native gst-android cpp-shared

ifeq ($(ENABLE_SNAP), true)
NNSTREAMER_LIBS += snap-sdk
endif

ifeq ($(ENABLE_NNFW), true)
NNSTREAMER_LIBS += $(NNFW_PREBUILT_LIBS)
endif
