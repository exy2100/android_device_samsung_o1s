# LineageOS device tree for the Samsung Galaxy S21 (Exynos)

| Basic         | Spec sheet                                    |
| ------------- | --------------------------------------------- |
| Model         | SM-G991B                                      |
| Codename      | o1s                                           |
| SoC           | Samsung Exynos 2100 (universal2100)           |
| Kernel        | 5.4 (`kernel/samsung/universal2100`)          |
| Partitions    | non-A/B, dynamic partitions (super), vendor_boot |

This tree depends on
[android_device_samsung_universal2100-common](https://github.com/exy2100/android_device_samsung_universal2100-common).

## Building

The trees in [github.com/exy2100](https://github.com/exy2100) include forks of
some LineageOS projects. `lineage.dependencies` can only pull unmodified
projects from github.com/LineageOS, so the device, common, kernel, vendor and
forked repositories have to come from a local manifest.

1. Initialize a LineageOS 23.2 source tree:

   ```sh
   repo init -u https://github.com/LineageOS/android.git -b lineage-23.2 --git-lfs --no-clone-bundle
   ```

2. Create `.repo/local_manifests/o1s.xml`:

   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <manifest>
     <remote name="exy2100" fetch="https://github.com/exy2100" revision="lineage-23.2" />

     <!-- LineageOS projects replaced by exy2100 forks -->
     <remove-project name="LineageOS/android_device_lineage_sepolicy" />
     <remove-project name="LineageOS/android_hardware_lineage_interfaces" />
     <remove-project name="LineageOS/android_lineage-sdk" />
     <remove-project name="LineageOS/android_packages_apps_Settings" />

     <!-- Device, kernel and vendor -->
     <project path="device/samsung/o1s" name="android_device_samsung_o1s" remote="exy2100" />
     <project path="device/samsung/universal2100-common" name="android_device_samsung_universal2100-common" remote="exy2100" />
     <project path="kernel/samsung/universal2100" name="android_kernel_samsung_universal2100" remote="exy2100" />
     <project path="vendor/samsung/o1s" name="proprietary_vendor_samsung_o1s" remote="exy2100" />
     <project path="vendor/samsung/universal2100-common" name="proprietary_vendor_samsung_universal2100-common" remote="exy2100" />

     <!-- exy2100 forks -->
     <project path="device/lineage/sepolicy" name="android_device_lineage_sepolicy" remote="exy2100" />
     <project path="device/samsung_slsi/sepolicy" name="android_device_samsung_slsi_sepolicy" remote="exy2100" />
     <project path="hardware/lineage/interfaces" name="android_hardware_lineage_interfaces" remote="exy2100" />
     <project path="hardware/samsung" name="android_hardware_samsung" remote="exy2100" />
     <project path="hardware/samsung_slsi-linaro/exynos" name="android_hardware_samsung_slsi-linaro_exynos" remote="exy2100" />
     <project path="lineage-sdk" name="android_lineage-sdk" remote="exy2100" />
     <project path="packages/apps/Settings" name="android_packages_apps_Settings" remote="exy2100" />
   </manifest>
   ```

   The remaining LineageOS dependencies (`hardware/samsung_slsi-linaro/{codec2,config,exynos5,graphics,interfaces,openmax,sgpu}`)
   are added automatically by `breakfast` through `lineage.dependencies`.

3. Sync and build:

   ```sh
   repo sync -c -j$(nproc)
   source build/envsetup.sh
   breakfast o1s
   m bacon
   ```

   The flashable package (`lineage-23.2-*-o1s.zip`) and `recovery.img` are
   placed in `out/target/product/o1s/`.

## Installing

Installing LineageOS wipes all data on the device and permanently trips Knox.

Requirements:

* The bootloader must be unlocked (Settings → Developer options → OEM
  unlocking, then long press Volume Up in download mode to unlock).
* Stock firmware **G991BXXSJHZC2** (Android 15) must be installed first.
  Older firmware (e.g. G991BXXSJHZA6) is known to hang at the boot logo.
  Flash all of BL/AP/CP/CSC with Odin (or `odin4` on Linux); the firmware can
  be downloaded with e.g. [samloader](https://github.com/topjohnwu/samloader-rs).

Steps:

1. Pack the recovery image into a tar that Odin accepts:

   ```sh
   tar --format=ustar -cf recovery.tar recovery.img
   ```

2. Boot into download mode (power off, hold Volume Up + Volume Down and plug in
   a USB cable connected to the computer).
3. Flash `recovery.tar` in the AP slot with **Auto Reboot disabled**.
4. Leave download mode by holding Volume Down + Power, and as soon as the
   screen turns off switch to Volume Up + Power (USB cable connected) to boot
   straight into LineageOS recovery. If stock Android boots instead, it
   restores the stock recovery and this step has to be repeated.
5. In recovery, select *Factory reset* → *Format data/factory reset*.
6. Select *Apply update* → *Apply from ADB* and run on the computer:

   ```sh
   adb sideload lineage-23.2-*-o1s.zip
   ```

   The package writes the dynamic partitions as well as `dtbo`, `vbmeta` and
   `vendor_boot`.
7. Select *Reboot system now*. The first boot takes a few minutes.

Later updates (full or incremental OTA packages) can be installed from
recovery with *Apply from ADB* without wiping data.
