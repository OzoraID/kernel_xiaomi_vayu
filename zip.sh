#!/bin/bash
# Edit by Neko

KERNEL_DIR="$PWD"
KERNEL_IMG="$KERNEL_DIR/out/arch/arm64/boot/Image"
KERNEL_DTBO="$KERNEL_DIR/out/arch/arm64/boot/dtbo.img"
KERNEL_DTB="$KERNEL_DIR/out/arch/arm64/boot/dtb.img"
AK3_DIR="$KERNEL_DIR/AK3"
DEVICE="vayu"

# Copy Image/dtbo/dtb to AnyKernel3
function copy() {
for files in {"$KERNEL_IMG","$KERNEL_DTBO","$KERNEL_DTB"}; do
    if [ -f "$files" ]; then
        echo -e " Copy [$files] to AnyKernel3 directory"
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
}

# Compress
function main() {
echo -e " Done..."
echo -e ""
echo -e " Create ZIP..."
cd "$AK3_DIR" || exit
ZIP_NAME=Astralprjkt_"$DEVICE"_"$(date +'%d%m%Y')"_"$(date +'%H%M')".zip
zip -r9 "$ZIP_NAME" ./*
}

# Upload
function end() {
echo  ""
echo  "#####################"
echo  "It's Time To Brick  "
echo  "#####################"
echo   ""

curl --progress-bar -T "$ZIP_NAME" https://oshi.at/"$ZIP_NAME"/1440
}

# execute
copy
main
end
