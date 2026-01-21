#git clone -b openwrt-24.10 --single-branch --filter=blob:none https://github.com/immortalwrt/immortalwrt
git clone https://github.com/x-wrt/x-wrt.git
cd x-wrt
echo "src-git momo https://github.com/nikkinikki-org/OpenWrt-momo.git;main" >> "feeds.conf.default"
./scripts/feeds update -a
./scripts/feeds install -a
git clone https://github.com/eamonxg/luci-theme-aurora.git package/luci-theme-aurora
cp ../deconfig/fur-602.config .config

make defconfig
make download -j$(nproc)
make -j$(nproc) || make -j1 V=s

TARGET_DIR=bin/targets
FIRMWARE_DIR=../firmware
\rm -rf "$FIRMWARE_DIR"
mkdir -p "$FIRMWARE_DIR"
find "$TARGET_DIR" -type f \( -name "*.bin" -o -name "*.itb" -o -name "*.buildinfo" -o -name "*squashfs*" \) -exec cp -f {} "$FIRMWARE_DIR/" \;
#find "$TARGET_DIR" -type f \( -name "*.*" -o -name "*.manifest" -o -name "*.buildinfo" -o -name "*squashfs*" \) -exec cp -f {} "$FIRMWARE_DIR/" \;
