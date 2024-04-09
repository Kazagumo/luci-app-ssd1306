PKG_NAME:=ssd1306-theme-4gwifi
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

define Package/ssd1306-theme-4gwifi
  SECTION:=ssd1306-themes
  CATEGORY:=Utilities
  DEPENDS:=+jq +awk
  TITLE:=ssd1306 manager theme for 4g cpe
endef

$(eval $(call BuildPackage,ssd1306-theme-4gwifi))