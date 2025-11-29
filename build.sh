#! /bin/bash

rm -rf .repo/local_manifests
repo init -u https://github.com/AxionAOSP/android.git -b lineage-23.0 --git-lfs
rm -rf prebuilts/clang/host/linux-x86

echo "==> Syncing sources..."
if [ -f /opt/crave/resync.sh ]; then
    /opt/crave/resync.sh
else
    repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j$(nproc --all)
fi

mf=(
device/xiaomi/marble
kernel/xiaomi/marble
vendor/xiaomi/marble
hardware/xiaomi
kernel/xiaomi/marble-modules
kernel/xiaomi/marble-devicetrees
)

rm -rf "${mf[@]}"


echo "==> Cleaning old outputs and device/vendor/hardware trees..."
dirs_to_remove=(
    out/target/product/marble
    out/target/product/gapps
    out/target/product/vanilla
    device/xiaomi/marble
    kernel/xiaomi/marble
    vendor/xiaomi/marble
    hardware/xiaomi
    kernel/xiaomi/marble-modules
    kernel/xiaomi/marble-devicetrees
)
rm -rf "${dirs_to_remove[@]}"

echo "=== Cloning device trees ==="
git clone https://github.com/marinoalfonse748-cyber/device_xiaomi_marble device/xiaomi/marble
git clone https://github.com/marinoalfonse748-cyber/vendor_xiaomi_marble vendor/xiaomi/marble
git clone https://github.com/LineageOS/android_kernel_xiaomi_sm8450 kernel/xiaomi/marble
git clone https://github.com/fiqri19102002/android_hardware_xiaomi hardware/xiaomi
git clone https://github.com/LineageOS/android_kernel_xiaomi_sm8450-devicetrees kernel/xiaomi/marble-devicetrees
git clone https://github.com/LineageOS/android_kernel_xiaomi_sm8450-modules kernel/xiaomi/marble-modules

echo "=== Starting GMS (Pico) build ==="
. build/envsetup.sh
gk -s
axion marble user gms pico
ax -br
mv out/target/product/marble out/target/product/gapps

echo "=== All builds completed successfully! ==="
