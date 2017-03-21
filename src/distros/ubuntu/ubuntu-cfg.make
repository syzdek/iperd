

ISOLINUX_CFG            += $(CONFIGDIR)/ubuntu/ubuntu.cfg
PXELINUX_CFG            += $(CONFIGDIR)/ubuntu/ubuntu.cfg
SYSLINUX_CFG            += $(CONFIGDIR)/ubuntu/ubuntu.cfg
DOWNLOAD_FILES          += $(UBUNTU_FILES)


$(CONFIGDIR)/ubuntu/ubuntu.cfg: $(DISTRODIR)/ubuntu/ubuntu.header $(DISTRODIR)/ubuntu/ubuntu.footer $(UBUNTU_CFG)
	cat \
	   $(DISTRODIR)/ubuntu/ubuntu.header \
	   $(UBUNTU_CFG) \
	   $(DISTRODIR)/ubuntu/ubuntu.footer \
	   > "$(@)"

.PHONY: ubuntu

ubuntu: $(UBUNTU_FILES) $(CONFIGDIR)/ubuntu.cfg

