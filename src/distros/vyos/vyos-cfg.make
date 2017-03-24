
ISOLINUX_CFG		+= $(CONFIGDIR)/vyos/vyos.cfg
PXELINUX_CFG		+= $(CONFIGDIR)/vyos/vyos.cfg
SYSLINUX_CFG		+= $(CONFIGDIR)/vyos/vyos.cfg
DOWNLOAD_FILES		+= $(VYOS_FILES)


$(CONFIGDIR)/vyos/vyos.cfg: $(VYOS_CFG) $(DISTRODIR)/vyos/vyos.header $(DISTRODIR)/vyos/vyos.footer
	@mkdir -p "$$(dirname "$(@)")"
	cat \
	   $(DISTRODIR)/vyos/vyos.header \
	   $(VYOS_CFG) \
	   $(DISTRODIR)/vyos/vyos.footer \
	   > "$(@)"

.PHONY: vyos

vyos: $(VYOS_FILES) $(CONFIGDIR)/vyos/vyos.cfg

