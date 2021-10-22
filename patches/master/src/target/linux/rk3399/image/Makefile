include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

define Image/Prepare
	cp $(LINUX_DIR)/arch/arm64/boot/Image $(KDIR)/Image
endef

define Image/BuildKernel
	cp $(KDIR)/Image $(BIN_DIR)/rockchip-$(BOARD)-uImage
endef
define Image/Build/ext4
	dd if=$(KDIR)/root.$(1) of=$(BIN_DIR)/rockchip-$(BOARD)-$(1).img
endef

define Image/Build
	$(call Image/Build/$(1),$(1))
endef

define Image/Build/firmware/RK3399/uboot
	$(CP) $(BIN_DIR)/rockchip-$(BOARD)-uboot.bin $(BIN_DIR)/RK3399/rockchip-rk3399-uboot.bin
endef
define Image/Build/firmware/kernel
	mkdir -p $(BIN_DIR)/$(1)
	$(CP) $(BIN_DIR)/rockchip-$(BOARD)-uImage $(BIN_DIR)/$(1)/rockchip-$(1)-uImage
endef
define Image/Build/firmware/ext4
	$(CP) $(BIN_DIR)/rockchip-$(BOARD)-ext4.img $(BIN_DIR)/$(1)/rockchip-$(1)-ext4.img
	(dd if=$(BIN_DIR)/$(1)/rockchip-$(1)-uImage bs=6M conv=sync; dd if=$(BIN_DIR)/$(1)/rockchip-$(1)-ext4.img) > $(BIN_DIR)/$(1)/rockchip-$(1)-ext4-sysupgrade.bin
endef
define Image/Build/firmware
	mkdir -p $(BIN_DIR)/$(PROFILE)
	$(call Image/Build/firmware/$(PROFILE)/uboot)
	$(call Image/Build/firmware/kernel,$(PROFILE))
	$(if $(CONFIG_TARGET_ROOTFS_EXT4FS), $(call Image/Build/firmware/ext4,$(PROFILE)))	
endef

$(eval $(call BuildImage))
