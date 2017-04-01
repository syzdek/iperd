
ISOLINUX_CFG		+= $(CONFIGDIR)/centos/centos.cfg
PXELINUX_CFG		+= $(CONFIGDIR)/centos/centos.cfg
SYSLINUX_CFG		+= $(CONFIGDIR)/centos/centos.cfg
DOWNLOAD_FILES		+= $(CENTOS_FILES)


$(CONFIGDIR)/centos/centos.cfg: $(CENTOS_CFG) $(DISTRODIR)/centos/centos.header $(DISTRODIR)/centos/centos.footer
	@mkdir -p "$$(dirname "$(@)")"
	cat \
	   $(DISTRODIR)/centos/centos.header \
	   $(CENTOS_CFG) \
	   $(DISTRODIR)/centos/centos.footer \
	   > "$(@)"

.PHONY: centos

centos: $(CENTOS_FILES) $(CONFIGDIR)/centos/centos.cfg

