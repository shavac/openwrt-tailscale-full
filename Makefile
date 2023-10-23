#
# Copyright (C) 2021 CZ.NIC, z. s. p. o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=tailscale-full
PKG_VERSION:=1.50.1
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://codeload.github.com/tailscale/tailscale/tar.gz/v$(PKG_VERSION)?
PKG_HASH:=183a7d559590a759dd77aa9c2b65486ab6e13c26f3c07fad0b536e318ad5e233

PKG_MAINTAINER:=Kshava Lewis <knightmare1980@gmail.com>
PKG_LICENSE:=BSD-3-Clause
PKG_LICENSE_FILES:=LICENSE

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)
PKG_BUILD_DEPENDS:=golang/host
PKG_BUILD_PARALLEL:=1
PKG_BUILD_FLAGS:=no-mips16

GO_PKG:=\
	tailscale.com/cmd/tailscale \
	tailscale.com/cmd/tailscaled
GO_PKG_LDFLAGS:=-X 'tailscale.com/version.longStamp=$(PKG_VERSION)-$(PKG_RELEASE) (OpenWrt)'
GO_PKG_LDFLAGS_X:=tailscale.com/version.shortStamp=$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk
include ../../lang/golang/golang-package.mk

define Package/$(PKG_NAME)/Default
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=VPN
  TITLE:=tailscale VPN
  URL:=https://tailscale.com
  DEPENDS:=$(GO_ARCH_DEPENDS)
endef

define Package/$(PKG_NAME)
  $(call Package/$(PKG_NAME)/Default)
  DEPENDS+= +ca-bundle +kmod-tun
endef

define Package/$(PKG_NAME)/description
  It creates a secure network between your servers, computers,
  and cloud instances. Even when separated by firewalls or subnets.
endef

define Package/$(PKG_NAME)/conffiles
/etc/config/tailscale
/etc/tailscale/
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(GO_PKG_BUILD_BIN_DIR)/tailscale $(1)/usr/sbin
	$(INSTALL_DIR) $(1)/usr/sbin $(1)/etc/init.d $(1)/etc/config
        $(INSTALL_BIN) $(GO_PKG_BUILD_BIN_DIR)/tailscaled $(1)/usr/sbin
        $(INSTALL_BIN) ./files//tailscale.init $(1)/etc/init.d/tailscale
        $(INSTALL_DATA) ./files//tailscale.conf $(1)/etc/config/tailscale
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
