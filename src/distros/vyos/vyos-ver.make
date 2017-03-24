

VYOS_FILES		+= boot/vyos/@VERSION@/@ARCH@/iperd.dep
VYOS_CFG		+= $(CONFIGDIR)/vyos/vyos@VERSION@@ARCH@.cfg
CLEANFILES		+= vyos-@VERSION@-@ARCH@


$(CONFIGDIR)/vyos/vyos@VERSION@@ARCH@.cfg: Makefile Makefile.config $(DISTRODIR)/vyos/vyos.cfg
	@SRCFILE="$(DISTRODIR)/vyos/vyos.cfg"; \
	   DISTRO_ARCH="@ARCH@"; \
	   DISTRO_CODENAME="@CODENAME@"; \
	   DISTRO_VERSION="@VERSION@"; \
	   $(do_subst_dt)


tmp/vyos-@VERSION@-@ARCH@.iso:
	URL="$(MIRROR_VYOS)/@VERSION@/vyos-@VERSION@-@ARCH@.iso"; \
	   $(download_file)
	@test -f "$(@)" && touch "$(@)"


tmp/vyos-@VERSION@-@ARCH@/live/vmlinuz: tmp/vyos-@VERSION@-@ARCH@.iso
	bash src/scripts/extractiso.sh \
	   tmp/vyos-@VERSION@-@ARCH@.iso \
	   tmp/vyos-@VERSION@-@ARCH@
	@test -f "$(@)" && touch "$(@)"


boot/vyos/@VERSION@/@ARCH@/iperd.dep: tmp/vyos-@VERSION@-@ARCH@/live/vmlinuz
	@rm -Rf "$$(dirname "$(@)")"
	@mkdir -p "$$(dirname "$(@)")"
	rsync -ra tmp/vyos-@VERSION@-@ARCH@/live/ "$$(dirname "$(@)")"
	@touch "$(@)"


