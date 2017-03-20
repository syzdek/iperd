

ISOLINUX_CFG            += $(CONFIGDIR)/debian/debian.cfg
PXELINUX_CFG            += $(CONFIGDIR)/debian/debian.cfg
SYSLINUX_CFG            += $(CONFIGDIR)/debian/debian.cfg
DOWNLOAD_FILES          += $(DEBIAN_FILES)


$(CONFIGDIR)/debian/debian.cfg: $(DISTRODIR)/debian/debian.header $(DISTRODIR)/debian/debian.footer $(DEBIAN_CFG)
	cat \
	   $(DISTRODIR)/debian/debian.header \
	   $(DEBIAN_CFG) \
	   $(DISTRODIR)/debian/debian.footer \
	   > "$(@)"

.PHONY: debian

debian: $(DEBIAN_FILES) $(CONFIGDIR)/debian.cfg

