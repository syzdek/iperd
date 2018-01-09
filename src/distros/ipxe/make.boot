
ISOLINUX_CFG            += $(CONFIGDIR)/ipxe/ipxe.cfg
SYSLINUX_CFG            += $(CONFIGDIR)/ipxe/ipxe.cfg
FILES_IPXE		 = boot/ipxe/ipxe.krn
DOWNLOAD_FILES          += $(FILES_IPXE)


$(CONFIGDIR)/ipxe/ipxe.cfg: Makefile $(DISTRODIR)/ipxe/ipxe.cfg
	@SRCFILE="$(DISTRODIR)/ipxe/ipxe.cfg"; \
	   DISTRO_CODENAME="@VERSION@"; \
	   DISTRO_VERSION="@VERSION@"; \
	   $(do_subst_dt)


tmp/boot/ipxe/ipxe/.iperd-extracted:
	./src/scripts/download.sh \
	   -e tmp/boot/ipxe/ipxe \
	   tmp/boot/ipxe/ipxe.iso \
	   $(MIRROR_IPXE)


boot/ipxe/ipxe.krn: tmp/boot/ipxe/ipxe/.iperd-extracted
	@mkdir -p "$$(dirname "$(@)")"
	cp tmp/boot/ipxe/ipxe/ipxe.krn "$(@)"
	@test -f "$(@)" && touch "$(@)"


