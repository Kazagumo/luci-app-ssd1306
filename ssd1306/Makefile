# SPDX-License-Identifier: GPL-2.0-only 
# 
# Copyright (C) 2024 OpenWrt.org 
 
include $(TOPDIR)/rules.mk
 
PKG_NAME:=ssd1306
PKG_RELEASE:=1
 
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/Kazagumo/ssd1306.git
PKG_SOURCE_VERSION:=HEAD

PKG_MAINTAINER:=Kazagumo

PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk

define Package/ssd1306
  CATEGORY:=Utilities
  DEPENDS:=+bash +libstdcpp
  TITLE:=ssd1306 oled screen manager
endef

define Package/ssd1306/description
  manage your ssd1306 screen.
endef

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) \
		CC="$(TARGET_CC)" \
		CXX="$(TARGET_CXX)"
endef

define Package/ssd1306/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(CP) $(PKG_BUILD_DIR)/ssd1306 $(1)/usr/sbin/
endef

$(eval $(call BuildPackage,ssd1306))
