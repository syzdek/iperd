

ISOLINUX_CFG            += $(CONFIGDIR)/slackware/slackware.cfg
PXELINUX_CFG            += $(CONFIGDIR)/slackware/slackware.cfg
SYSLINUX_CFG            += $(CONFIGDIR)/slackware/slackware.cfg
DOWNLOAD_FILES          += $(SLACKWARE_FILES)


$(CONFIGDIR)/slackware/slackware.cfg: $(DISTRODIR)/slackware/slackware.header $(DISTRODIR)/slackware/slackware.footer $(SLACKWARE_CFG)
	@mkdir -p "$$(dirname "$(@)")"
	cat \
	   $(DISTRODIR)/slackware/slackware.header \
	   $(SLACKWARE_CFG) \
	   $(DISTRODIR)/slackware/slackware.footer \
	   > "$(@)"

.PHONY: slackware

slackware: $(SLACKWARE_FILES) $(CONFIGDIR)/slackware/slackware.cfg

