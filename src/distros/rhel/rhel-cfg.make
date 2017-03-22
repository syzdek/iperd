
ISOLINUX_CFG		+= $(CONFIGDIR)/rhel/rhel.cfg
PXELINUX_CFG		+= $(CONFIGDIR)/rhel/rhel.cfg
SYSLINUX_CFG		+= $(CONFIGDIR)/rhel/rhel.cfg
DOWNLOAD_FILES		+= $(RHEL_FILES)


$(CONFIGDIR)/rhel/rhel.cfg: $(RHEL_CFG) $(DISTRODIR)/rhel/rhel.header $(DISTRODIR)/rhel/rhel.footer
	@mkdir -p "$$(dirname "$(@)")"
	cat \
	   $(DISTRODIR)/rhel/rhel.header \
	   $(RHEL_CFG) \
	   $(DISTRODIR)/rhel/rhel.footer \
	   > "$(@)"

.PHONY: rhel

rhel: $(RHEL_FILES) $(CONFIGDIR)/rhel/rhel.cfg

