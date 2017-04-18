
ISOLINUX_CFG		+= $(CONFIGDIR)/alpine/alpine.cfg
PXELINUX_CFG		+= $(CONFIGDIR)/alpine/alpine.pxe.cfg
SYSLINUX_CFG		+= $(CONFIGDIR)/alpine/alpine.cfg
DOWNLOAD_FILES		+= $(ALPINE_FILES)

ALPINE_CFG_ALL		 = $(ALPINE_CFG)
ALPINE_CFG_ALL		 = $(ALPINE_PXE_CFG)
ALPINE_CFG_ALL		+= $(DISTRODIR)/alpine/alpine-header.cfg
ALPINE_CFG_ALL		+= $(DISTRODIR)/alpine/alpine-footer.cfg


$(CONFIGDIR)/alpine/alpine.cfg: $(ALPINE_CFG_ALL)
	@mkdir -p "$$(dirname "$(@)")"
	cat \
	   $(DISTRODIR)/alpine/alpine-header.cfg \
	   $(ALPINE_CFG) \
	   $(DISTRODIR)/alpine/alpine-footer.cfg \
	   > "$(@)"

$(CONFIGDIR)/alpine/alpine.pxe.cfg: $(ALPINE_CFG_ALL)
	@mkdir -p "$$(dirname "$(@)")"
	cat \
	   $(DISTRODIR)/alpine/alpine-header.cfg \
	   $(ALPINE_PXE_CFG) \
	   $(DISTRODIR)/alpine/alpine-footer.cfg \
	   > "$(@)"

.PHONY: alpine

alpine: $(ALPINE_FILES) $(CONFIGDIR)/alpine/alpine.cfg

