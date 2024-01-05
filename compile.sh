#!/bin/bash
# Edit by Neko
# Configure by Suzurui

# init
function init() {
    echo "==========================="
    echo "= START COMPILING KERNEL  ="
    echo "==========================="
}
# Main
function compile() {
KERNEL_DIR="$PWD"
KERNEL_IMG="$KERNEL_DIR/out/arch/arm64/boot/Image"
KERNEL_DTBO="$KERNEL_DIR/out/arch/arm64/boot/dtbo.img"
KERNEL_DTB="$KERNEL_DIR/out/arch/arm64/boot/dtb.img"
AK3_DIR="$KERNEL_DIR/AK3"
DEVICE="vayu"

curl -LSs "https://raw.githubusercontent.com/tiann/KernelSU/main/kernel/setup.sh" | bash -s main

    export KBUILD_BUILD_USER="NekoTuru"
    export KBUILD_BUILD_HOST="Weeaboo"

    export ARCH=arm64
    export SUBARCH=arm64

    export PATH="/workspace/ehhe/clang/bin:/workspace/ehhe/arch64:/workspace/ehhe/arm:$PATH"

    make -j$(nproc --all) O=out ARCH=arm64 vayu_defconfig
    make -j$(nproc --all) O=out \
                        ARCH=arm64 \
                        LLVM_IAS=1 \
                        LLVM=1 \
                       CLANG_TRIPLE=aarch64-linux-gnu- \
                       CROSS_COMPILE=aarch64-linux-android- \
                       CROSS_COMPILE_ARM32=arm-linux-androideabi-

# Copy Image/dtbo/dtb to AnyKernel3
for files in {"$KERNEL_IMG","$KERNEL_DTBO","$KERNEL_DTB"}; do
    if [ -f "$files" ]; then
        echo "* Copy [$files] to AnyKernel3 directory"
        if [ "$files" = "$KERNEL_DTB" ]; then
            cp -r "$files" "$AK3_DIR"/dtb.img
        else
            cp -r "$files" "$AK3_DIR"
        fi
    else
        echo "* Image/dtb/dtbo is missing!"
        echo ""
        exit
    fi
done

# Compress to ZIP
echo ""
echo "* Create ZIP"
cd "$AK3_DIR" || exit
ZIP_NAME=Kurumi+_"$DEVICE"_"$(date +'%d%m%Y')"_"$(date +'%H%M')".zip
zip -r9 "$ZIP_NAME" ./*
}
#end
function end(){
    echo "==========================="
    echo "=  COMPILE KERNEL COMPLETE    ="
    echo "=    Santai Dulu Ngga Sih    ="
    echo "==========================="
}

# execute
init
compile
end
