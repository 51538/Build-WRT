

source /etc/profile
BASE_PATH=$(cd $(dirname $0) && pwd)
BUILD_DIR=$(cat BUILD_DIR)
BUILD_MODEL=$(cat BUILD_MODEL)
CONFIG_FILE=$BASE_PATH/$BUILD_MODEL.config

cd $BASE_PATH/$BUILD_DIR
aa=$(grep -lri $BUILD_MODEL target | awk -F'[/.]' '{print $3}')
bb=$(grep -lri $BUILD_MODEL target | awk -F'[/.]' '{print $5}')
cd -
if [[ ! -f "$CONFIG_FILE" ]]; then
    cat>$BASE_PATH/$BUILD_DIR/.config<<EOF
CONFIG_TARGET_${aa}=y
CONFIG_TARGET_${aa}_${bb}=y
CONFIG_TARGET_${aa}_${bb}_DEVICE_${BUILD_MODEL}=y
EOF
    else
    \cp -f $BASE_PATH/$BUILD_MODEL.config $BASE_PATH/$BUILD_DIR/.config
fi

DEVICE_NAME=$(grep '^CONFIG_TARGET.*DEVICE.*=y' $BASE_PATH/$BUILD_DIR/.config | sed -r 's/.*DEVICE_(.*)=y/\1/')
if [[ "$DEVICE_NAME" != "jdcloud_ax1800-pro" ]] && [[ "$DEVICE_NAME" != "jdcloud_re-ss-01" ]]; then
    sed -i "s/FK20100010/$DEVICE_NAME/g" $BASE_PATH/999-customized-settings
    sed -i '/.encryption=/d' $BASE_PATH/999-customized-settings
    sed -i '/.key=/d' $BASE_PATH/999-customized-settings
    sed -i '/_core/d' $BASE_PATH/999-customized-settings
    sed -i '/\/etc\/shadow/d' $BASE_PATH/999-customized-settings
    chmod 775 $BASE_PATH/999-customized-settings
fi

cp -f $BASE_PATH/999-customized-settings $BASE_PATH/$BUILD_DIR/package/base-files/files/etc/uci-defaults

TARGET_DIR="$BASE_PATH/$BUILD_DIR/bin/targets"
if [[ -d $TARGET_DIR ]]; then
    find "$TARGET_DIR" -type f \( -name "*.bin" -o -name "*.manifest" \) -exec rm -f {} +
fi

cd $BASE_PATH/$BUILD_DIR
make defconfig
make download -j$(nproc)
make -j$(nproc) || make -j1 || make -j1 V=s

FIRMWARE_DIR="$BASE_PATH/firmware"
\rm -rf "$FIRMWARE_DIR"
mkdir -p "$FIRMWARE_DIR"
find "$TARGET_DIR" -type f \( -name "*.bin" -o -name "*.manifest" -o -name "*.buildinfo" -o -name "*squashfs*" \) -exec cp -f {} "$FIRMWARE_DIR/" \;
cp -f $BASE_PATH/$BUILD_DIR/.config $FIRMWARE_DIR/123.config
#\rm -f "$BASE_PATH/firmware/Packages.manifest" 2>/dev/null
for file in $FIRMWARE_DIR/*openwrt*; do
    mv "$file" "${file//openwrt/$BUILD_DIR}" 2>/dev/null
done
exit 0
