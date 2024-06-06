#!/bin/bash
# Edit by Neko

KERNEL_DIR="$PWD"
KERNEL_IMG="$KERNEL_DIR/out/arch/arm64/boot/Image"
KERNEL_DTBO="$KERNEL_DIR/out/arch/arm64/boot/dtbo.img"
KERNEL_DTB="$KERNEL_DIR/out/arch/arm64/boot/dtb.img"
AK3_DIR="$KERNEL_DIR/AK3"
DEVICE="vayu"

# Copy Image/dtbo/dtb to AnyKernel3
for files in {"$KERNEL_IMG","$KERNEL_DTBO","$KERNEL_DTB"}; do
    if [ -f "$files" ]; then
        echo " Copy [$files] to AnyKernel3 directory""
	sleep 0.5
        if [ "$files" = "$KERNEL_DTB" ]; then
            cp -r "$files" "$AK3_DIR"/dtb.img
	sleep 0.5
        else
            cp -r "$files" "$AK3_DIR"
	sleep 0.5
        fi
    else
	echo -e ""
        echo -e " Image/dtb/dtbo is missing!"
        echo -e ""
        exit
    fi
done

# Compress to ZIP
echo -e " Done..."
echo -e ""
echo -e " Create ZIP..."
cd "$AK3_DIR" || exit
ZIP_NAME=Kurumi+_"$DEVICE"_"$(date +'%d%m%Y')"_"$(date +'%H%M')".zip
zip -r9 "$ZIP_NAME" ./*

# Upload
echo -e ""
echo -e "#####################"
echo -e "It's Time To Brick.."
echo -e "#####################"
echo -e ""
curl --progress-bar -T "$ZIP_NAME" https://pixeldrain.com/api/file/ | cat || exit
