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
# define required libraries for nnstreamer
#------------------------------------------------------
NNSTREAMER_LIBS := nnstreamer-native gst-android cpp-shared

ifeq ($(ENABLE_SNAP), true)
NNSTREAMER_LIBS += snap-sdk
endif
