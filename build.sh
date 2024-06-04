#!/bin/bash
# Thanks to https://t.me/itsclhex for build script and source
sudo apt update && sudo -H apt-get install bc python2 ccache binutils-aarch64-linux-gnu cpio
curl -LSs "https://raw.githubusercontent.com/tiann/KernelSU/main/kernel/setup.sh" | bash -s v0.9.5

kernel_dir="${PWD}"
CCACHE=$(command -v ccache)
objdir="${kernel_dir}/out"
CLANG_DIR=/workspace/ehhe/clang
ARCH_DIR=/workspace/ehhe/arch64
ARM_DIR=/workspace/ehhe/arm
export CONFIG_FILE="vayu_defconfig"
export ARCH="arm64"
export KBUILD_BUILD_HOST="NekoTuru"
export KBUILD_BUILD_USER="Weeaboo"

export PATH="$CLANG_DIR/bin:$ARCH_DIR/bin:$ARM_DIR/bin:$PATH"

make_defconfig()
{
    START=$(date +"%s")
    echo "########### Generating Defconfig ############"
    make -s ARCH=${ARCH} O=${objdir} ${CONFIG_FILE} -j$(nproc --all)
}
compile()
{
    cd ${kernel_dir}
    echo -"######### Compiling kernel #########"
    make -j$(nproc --all) \
    O=out \
    ARCH=arm64                              \
    SUBARCH=arm64                           \
    CLANG_TRIPLE=aarch64-linux-gnu-         \
    CROSS_COMPILE=aarch64-linux-gnu-        \
    CROSS_COMPILE_ARM32=arm-linux-gnueabi-  \
    CROSS_COMPILE_COMPAT=arm-linux-gnueabi- \
    LD=ld.lld                               \
    AR=llvm-ar                              \
    NM=llvm-nm                              \
    STRIP=llvm-strip                        \
    OBJCOPY=llvm-objcopy                    \
    OBJDUMP=llvm-objdump                    \
    READELF=llvm-readelf                    \
    HOSTCC=clang                            \
    HOSTCXX=clang++                         \
    HOSTAR=llvm-ar                          \
    HOSTLD=ld.lld                           \
    LLVM=1                                  \
    LLVM_IAS=1                              \
    CC="ccache clang"                       \
    $1
}

completion()
{
    cd ${objdir}
    COMPILED_IMAGE=arch/arm64/boot/Image
    COMPILED_DTBO=arch/arm64/boot/dtbo.img
    COMPILED_DTB=arch/arm64/boot/dtb.img
    if [[ -f ${COMPILED_IMAGE} && ${COMPILED_DTBO} && ${COMPILED_DTBO} ]]; then
        echo "############################################"
        echo "############# OkThisIsEpic!  ###############"
        echo "############################################"
        exit 0
    else
        echo "############################################"
        echo "##         This Is Not Epic :'(           ##"
        echo "############################################"
        exit 1
    fi
}
make_defconfig
compile
completion
cd ${kernel_dir}
