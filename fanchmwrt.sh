git clone -b main --single-branch --filter=blob:none https://github.com/VIKINGYFY/immortalwrt.git VIKINGYFY
#git clone -b openwrt-25.12 --single-branch --filter=blob:none https://github.com/immortalwrt/immortalwrt.git openwrt-25.12
#git clone -b openwrt-24.10-6.6 --single-branch --filter=blob:none https://github.com/padavanonly/immortalwrt-mt798x-6.6.git immortalwrt-mt798x-6.6
cd VIKINGYFY
echo "src-git momo https://github.com/nikkinikki-org/OpenWrt-momo.git;main" >> "feeds.conf.default"
#echo "src-git nikki https://github.com/nikkinikki-org/OpenWrt-nikki.git;main" >> "feeds.conf.default"
./scripts/feeds update -a
./scripts/feeds install -a
git clone https://github.com/eamonxg/luci-theme-aurora.git package/luci-theme-aurora
cp ../deconfig/ress01.config .config

make defconfig
make download -j$(nproc)
make -j$(nproc) || make -j1 V=s

TARGET_DIR=bin/targets
FIRMWARE_DIR=../firmware
\rm -rf "$FIRMWARE_DIR"
mkdir -p "$FIRMWARE_DIR"
find "$TARGET_DIR" -type f \( -name "*.bin" -o -name "*.itb" -o -name "*.buildinfo" -o -name "*squashfs*" \) -exec cp -f {} "$FIRMWARE_DIR/" \;
#find "$TARGET_DIR" -type f \( -name "*.*" -o -name "*.manifest" -o -name "*.buildinfo" -o -name "*squashfs*" \) -exec cp -f {} "$FIRMWARE_DIR/" \;
