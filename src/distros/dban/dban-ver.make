
ISOLINUX_CFG            += $(CONFIGDIR)/dban/dban.cfg
PXELINUX_CFG            += $(CONFIGDIR)/dban/dban.cfg
SYSLINUX_CFG            += $(CONFIGDIR)/dban/dban.cfg
DOWNLOAD_FILES          += boot/dban/dban.bzi


$(CONFIGDIR)/dban/dban.cfg: Makefile $(DISTRODIR)/dban/dban.cfg
	@SRCFILE="$(DISTRODIR)/dban/dban.cfg"; \
	   DISTRO_CODENAME="@VERSION@"; \
	   DISTRO_VERSION="@VERSION@"; \
	   $(do_subst_dt)


tmp/dban-@VERSION@_i586.iso:
	URL="$(MIRROR_DBAN)/dban-@VERSION@/dban-@VERSION@_i586.iso"; \
	   $(download_file)
	@touch "$(@)"


tmp/dban-@VERSION@_i586/dban.bzi: tmp/dban-@VERSION@_i586.iso
	bash src/scripts/extractiso.sh \
	   tmp/dban-@VERSION@_i586.iso \
	   tmp/dban-@VERSION@_i586
	@touch "$(@)"

boot/dban/dban.bzi: tmp/dban-@VERSION@_i586/dban.bzi
	@mkdir -p "$$(dirname "$(@)")"
	cp tmp/dban-@VERSION@_i586/dban.bzi "$(@)"
	@touch "$(@)"


dban: $(CONFIGDIR)/dban.cfg boot/dban/dban.bin

