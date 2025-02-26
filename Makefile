include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-blockclient
PKG_VERSION:=1.0
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:=LuCI Support for Blocking Clients by IP/MAC
  PKGARCH:=all
  DEPENDS:=+luci-base +iptables
endef

define Package/$(PKG_NAME)/description
  LuCI interface to block clients by IP or MAC address.
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
	po2lmo ./po/zh_Hans/blockclient.po $(PKG_BUILD_DIR)/blockclient.zh-cn.lmo
endef

define Package/$(PKG_NAME)/install
	# 安装配置文件
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) $(CURDIR)/root/etc/config/blockclient $(1)/etc/config/blockclient
	
	# 安装初始化脚本
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) $(CURDIR)/root/etc/init.d/blockclient $(1)/etc/init.d/blockclient
	
	# 安装UCI提交钩子
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) $(CURDIR)/root/etc/uci-defaults/99-blockclient-rules $(1)/etc/uci-defaults/99-blockclient-rules
	
	# 安装LuCI组件
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(INSTALL_DATA) $(CURDIR)/root/usr/lib/lua/luci/controller/blockclient.lua $(1)/usr/lib/lua/luci/controller/
	
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi
	$(INSTALL_DATA) $(CURDIR)/root/usr/lib/lua/luci/model/cbi/blockclient.lua $(1)/usr/lib/lua/luci/model/cbi/
	
	# 安装ACL权限文件
	$(INSTALL_DIR) $(1)/usr/share/rpcd/acl.d
	$(INSTALL_DATA) $(CURDIR)/root/usr/share/rpcd/acl.d/blockclient.json $(1)/usr/share/rpcd/acl.d/
	
	# 安装国际化文件
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/blockclient.zh-cn.lmo $(1)/usr/lib/lua/luci/i18n/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
