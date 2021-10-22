include $(TOPDIR)/rules.mk

ARCH:=aarch64
BOARD:=rk3399
BOARDNAME:=Rockchip RK3399
FEATURES:=fpu ext4
CPU_TYPE:=cortex-a53
CFLAGS:=-Os -pipe -march=armv8-a -mabi=lp64 -mcpu=cortex-a53

KERNEL_PATCHVER=5.4

KERNELNAME:=Image dtbs

define Target/Description
	Build firmware image for Rockchip SoC devices.
endef

include $(INCLUDE_DIR)/target.mk

$(eval $(call BuildTarget))
