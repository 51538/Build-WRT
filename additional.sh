#!/usr/bin/env bash

BUILD_DIR=$(cat BUILD_DIR)
BUILD_MODEL=$(cat BUILD_MODEL)
#run before ./scripts/feeds
if [[ -f "${BUILD_MODEL}_${BUILD_DIR}" ]]; then
   bash ${BUILD_MODEL}_${BUILD_DIR}
fi

cd $BUILD_DIR
sed -i '/^#/d' feeds.conf.default
echo -e "\nsrc-git passwall_packages https://github.com/xiaorouji/openwrt-passwall-packages.git;main" >> "feeds.conf.default"
echo "src-git passwall https://github.com/xiaorouji/openwrt-passwall.git;main" >> "feeds.conf.default"
echo "src-git passwall2 https://github.com/xiaorouji/openwrt-passwall2.git;main" >> "feeds.conf.default"
#echo "src-git mihomo https://github.com/morytyann/OpenWrt-mihomo.git;main" >> "feeds.conf.default"

./scripts/feeds clean && ./scripts/feeds update -a
./scripts/feeds install -a -f -p passwall_packages
./scripts/feeds install luci-app-passwall luci-app-passwall2
./scripts/feeds install -a

#run after ./scripts/feeds
cd ../
if [[ -f "${BUILD_MODEL}_${BUILD_DIR}_after" ]]; then
   bash ${BUILD_MODEL}_${BUILD_DIR}_after
fi
cd -

#OpenWrt golang latest version
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 23.x feeds/packages/lang/golang
# 更新luci-app-dockerman
rm -rf feeds/luci/applications/luci-app-dockerman
git clone https://github.com/lisaac/luci-app-dockerman.git package/luci-app-dockerman

#添加自定义插件
git clone https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone -b js --single-branch https://github.com/papagaye744/luci-theme-design.git package/luci-theme-design
# 添加 clouddrive2 插件
git clone https://github.com/kiddin9/openwrt-clouddrive2.git package/openwrt-clouddrive2
sed -i 's/0.7.21/0.8.3/g' package/openwrt-clouddrive2/clouddrive2/Makefile

rm -rf feeds/packages/libs/liburing
git clone https://github.com/sbwml/feeds_packages_libs_liburing feeds/packages/libs/liburing
rm -rf feeds/packages/net/samba4
git clone https://github.com/sbwml/feeds_packages_net_samba4 feeds/packages/net/samba4

#rm -rf feeds/packages/net/chinadns-ng
#cp -rf feeds/passwall_packages/chinadns-ng/ feeds/packages/net/
#rm -rf feeds/luci/applications/luci-app-passwall/
#cp -rf feeds/passwall/luci-app-passwall/ feeds/luci/applications

# TTYD 免登录
sed -i 's|/bin/login|/bin/login -f root|g' feeds/packages/utils/ttyd/files/ttyd.config

# 增固件连接数
sed -i '/customized in this file/a net.netfilter.nf_conntrack_max=165535' package/base-files/files/etc/sysctl.conf
