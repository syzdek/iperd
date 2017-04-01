
ISOLINUX_CFG            += $(CONFIGDIR)/ipxe/ipxe.cfg
SYSLINUX_CFG            += $(CONFIGDIR)/ipxe/ipxe.cfg
FILES_IPXE		 = boot/ipxe/ipxe.krn
DOWNLOAD_FILES          += $(FILES_IPXE)
CLEANFILES		+= $(FILES_IPXE) tmp/ipxe


$(CONFIGDIR)/ipxe/ipxe.cfg: Makefile $(DISTRODIR)/ipxe/ipxe.cfg
	@SRCFILE="$(DISTRODIR)/ipxe/ipxe.cfg"; \
	   DISTRO_CODENAME="@VERSION@"; \
	   DISTRO_VERSION="@VERSION@"; \
	   $(do_subst_dt)


tmp/ipxe.iso:
	URL="$(MIRROR_IPXE)"; \
	   $(download_file)
	@test -f "$(@)" && touch "$(@)"


tmp/ipxe/ipxe.krn: tmp/ipxe.iso
	bash src/scripts/extractiso.sh \
	   tmp/ipxe.iso \
	   tmp/ipxe
	@test -f "$(@)" && touch "$(@)"

boot/ipxe/ipxe.krn: tmp/ipxe/ipxe.krn
	@mkdir -p "$$(dirname "$(@)")"
	cp tmp/ipxe/ipxe.krn "$(@)"
	@test -f "$(@)" && touch "$(@)"


ipxe: $(CONFIGDIR)/ipxe.cfg $(FILES_IPXE)

