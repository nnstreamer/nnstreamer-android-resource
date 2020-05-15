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

ENABLE_TF_LITE := false
ENABLE_SNAP := false
ENABLE_NNFW := false
ENABLE_SNPE := false

#------------------------------------------------------
# define required libraries for nnstreamer
#------------------------------------------------------
NNSTREAMER_LIBS := nnstreamer nnstreamer-native gst-android cpp-shared

#------------------------------------------------------
# nnstreamer
#------------------------------------------------------
include $(CLEAR_VARS)
LOCAL_MODULE := nnstreamer
LOCAL_SRC_FILES := $(NNSTREAMER_LIB_PATH)/libnnstreamer.so
include $(PREBUILT_SHARED_LIBRARY)

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
# tensorflow-lite
#------------------------------------------------------
ifeq ($(ENABLE_TF_LITE),true)
include $(CLEAR_VARS)
LOCAL_MODULE := tensorflow-lite-subplugin
LOCAL_SRC_FILES := $(NNSTREAMER_LIB_PATH)/libtensorflow-lite-subplugin.so
include $(PREBUILT_SHARED_LIBRARY)

NNSTREAMER_LIBS += tensorflow-lite-subplugin
endif

#------------------------------------------------------
# SNAP (arm64-v8a only)
#------------------------------------------------------
ifeq ($(ENABLE_SNAP),true)
SNAP_LIB_PATH := $(NNSTREAMER_LIB_PATH)
include $(LOCAL_PATH)/Android-snap-prebuilt.mk

include $(CLEAR_VARS)
LOCAL_MODULE := snap-subplugin
LOCAL_SRC_FILES := $(NNSTREAMER_LIB_PATH)/libsnap-subplugin.so
include $(PREBUILT_SHARED_LIBRARY)

NNSTREAMER_LIBS += $(SNAP_PREBUILT_LIBS) snap-subplugin
endif

#------------------------------------------------------
# NNFW (arm64-v8a only)
#------------------------------------------------------
ifeq ($(ENABLE_NNFW),true)
NNFW_LIB_PATH := $(NNSTREAMER_LIB_PATH)
include $(LOCAL_PATH)/Android-nnfw-prebuilt.mk

include $(CLEAR_VARS)
LOCAL_MODULE := nnfw-subplugin
LOCAL_SRC_FILES := $(NNSTREAMER_LIB_PATH)/libnnfw-subplugin.so
include $(PREBUILT_SHARED_LIBRARY)

NNSTREAMER_LIBS += $(NNFW_PREBUILT_LIBS) nnfw-subplugin
endif

#------------------------------------------------------
# SNPE
#------------------------------------------------------
ifeq ($(ENABLE_SNPE),true)
SNPE_LIB_PATH := $(NNSTREAMER_LIB_PATH)
include $(LOCAL_PATH)/Android-snpe-prebuilt.mk

include $(CLEAR_VARS)
LOCAL_MODULE := snpe-subplugin
LOCAL_SRC_FILES := $(NNSTREAMER_LIB_PATH)/libsnpe-subplugin.so
include $(PREBUILT_SHARED_LIBRARY)

NNSTREAMER_LIBS += $(SNPE_PREBUILT_LIBS) snpe-subplugin
endif

# Remove any duplicates.
NNSTREAMER_LIBS := $(sort $(NNSTREAMER_LIBS))
