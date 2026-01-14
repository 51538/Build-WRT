git clone https://github.com/hanwckf/immortalwrt-mt798x.git
cd immortalwrt-mt798x
#sed -i '1i src-git passwall2_luci https://github.com/Openwrt-Passwall/openwrt-passwall2.git;main' feeds.conf.default
#sed -i '1i src-git passwall_packages https://github.com/Openwrt-Passwall/openwrt-passwall-packages.git;main' feeds.conf.default
./scripts/feeds update -a
./scripts/feeds install -a
cp ../deconfig/fur-602.config .config

rm -rf feeds/packages/net/{xray-core,v2ray-geodata,sing-box,chinadns-ng,dns2socks,hysteria,ipt2socks,microsocks,naiveproxy,shadowsocks-libev,shadowsocks-rust,shadowsocksr-libev,simple-obfs,tcping,trojan-plus,tuic-client,v2ray-plugin,xray-plugin,geoview,shadow-tls}
git clone https://github.com/Openwrt-Passwall/openwrt-passwall-packages package/passwall-packages

# 移除 openwrt feeds 过时的luci版本
rm -rf feeds/luci/applications/luci-app-passwall
git clone https://github.com/Openwrt-Passwall/openwrt-passwall2 package/passwall2


make defconfig
make download -j$(nproc)
make -j$(nproc) || make -j1 V=s

TARGET_DIR=bin/targets
FIRMWARE_DIR=../firmware
\rm -rf "$FIRMWARE_DIR"
mkdir -p "$FIRMWARE_DIR"
#find "$TARGET_DIR" -type f \( -name "*.bin" -o -name "*.manifest" -o -name "*.buildinfo" -o -name "*squashfs*" \) -exec cp -f {} "$FIRMWARE_DIR/" \;
find "$TARGET_DIR" -type f \( -name "*.*" -o -name "*.manifest" -o -name "*.buildinfo" -o -name "*squashfs*" \) -exec cp -f {} "$FIRMWARE_DIR/" \;
