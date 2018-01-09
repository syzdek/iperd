
ISOLINUX_CFG            += $(CONFIGDIR)/dban/dban.cfg
PXELINUX_CFG            += $(CONFIGDIR)/dban/dban.cfg
SYSLINUX_CFG            += $(CONFIGDIR)/dban/dban.cfg
FILES_DBAN		 = boot/dban/dban.bzi
DOWNLOAD_FILES          += $(FILES_DBAN)


$(CONFIGDIR)/dban/dban.cfg: Makefile $(DISTRODIR)/dban/dban.cfg
	@SRCFILE="$(DISTRODIR)/dban/dban.cfg"; \
	   DISTRO_CODENAME="@VERSION@"; \
	   DISTRO_VERSION="@VERSION@"; \
	   $(do_subst_dt)


tmp/boot/dban/dban-@VERSION@_@ARCH@/.iperd-extracted:
	./src/scripts/download.sh \
	   -H $(DBAN_HASHES)/dban-@VERSION@_@ARCH@.sha512 \
	   -e tmp/boot/dban/dban-@VERSION@_@ARCH@ \
	   boot/dban/dban-@VERSION@_@ARCH@.iso \
	   $(MIRROR_DBAN)/dban-@VERSION@/dban-@VERSION@_@ARCH@.iso


boot/dban/dban.bzi: tmp/boot/dban/dban-@VERSION@_@ARCH@/.iperd-extracted
	@mkdir -p "$$(dirname "$(@)")"
	cp tmp/boot/dban/dban-@VERSION@_@ARCH@/dban.bzi "$(@)"
	@test -f "$(@)" && touch "$(@)"


dban: $(CONFIGDIR)/dban.cfg $(FILES_DBAN)

