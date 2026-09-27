#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from universal2100
$(call inherit-product, device/samsung/universal2100-common/common.mk)

# Inherit from the proprietary version
$(call inherit-product, vendor/samsung/o1s/o1s-vendor.mk)

# Overlays
DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay

# Audio
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/audio/audio_board_info.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_board_info.xml \
    $(LOCAL_PATH)/configs/audio/mixer_paths.xml:$(TARGET_COPY_OUT_VENDOR)/etc/mixer_paths.xml

# Camera - ID=52 is telephoto
$(call soong_config_set,samsungCameraVars,extra_ids,52)

# Display
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/display/displayconfig.xml:$(TARGET_COPY_OUT_VENDOR)/etc/displayconfig/display_id_4633128672291735937.xml

# Recovery/vendor_boot firmware
PRODUCT_COPY_FILES += \
    vendor/samsung/o1s/proprietary/vendor/firmware/y792_o1.bin:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/firmware/y792_o1.bin \
    vendor/samsung/o1s/proprietary/vendor/firmware/y792_o1.bin:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/vendor/firmware/y792_o1.bin

# Sensors
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/sensors/hals.conf:$(TARGET_COPY_OUT_VENDOR)/etc/sensors/hals.conf

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)
