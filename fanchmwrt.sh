#git clone https://github.com/hanwckf/immortalwrt-mt798x.git
#cd immortalwrt-mt798x
#sed -i '1i src-git passwall2_luci https://github.com/Openwrt-Passwall/openwrt-passwall2.git;main' feeds.conf.default
#sed -i '1i src-git passwall_packages https://github.com/Openwrt-Passwall/openwrt-passwall-packages.git;main' feeds.conf.default
#./scripts/feeds update -a
#./scripts/feeds install -a
#cp ../deconfig/fur-602.config .config

git clone -b openwrt-25.12 --single-branch --filter=blob:none https://github.com/immortalwrt/immortalwrt
cd immortalwrt
echo "src-git momo https://github.com/nikkinikki-org/OpenWrt-momo.git;main" >> "feeds.conf.default"
./scripts/feeds update -a
./scripts/feeds install -a
cp ../deconfig/imm.config .config

make defconfig
make download -j$(nproc)
make -j$(nproc) || make -j1 V=s

TARGET_DIR=bin/targets
FIRMWARE_DIR=../firmware
\rm -rf "$FIRMWARE_DIR"
mkdir -p "$FIRMWARE_DIR"
find "$TARGET_DIR" -type f \( -name "*.bin" -o -name "*.manifest" -o -name "*.buildinfo" -o -name "*squashfs*" \) -exec cp -f {} "$FIRMWARE_DIR/" \;
#find "$TARGET_DIR" -type f \( -name "*.*" -o -name "*.manifest" -o -name "*.buildinfo" -o -name "*squashfs*" \) -exec cp -f {} "$FIRMWARE_DIR/" \;
