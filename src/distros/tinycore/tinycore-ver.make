
ISOLINUX_CFG            += $(CONFIGDIR)/tinycore/tinycore.cfg
PXELINUX_CFG            += $(CONFIGDIR)/tinycore/tinycore.cfg
SYSLINUX_CFG            += $(CONFIGDIR)/tinycore/tinycore.cfg
TINYCORE_FILES		=  boot/tinycore/@VERSION@/core.gz \
			   boot/tinycore/@VERSION@/vmlinuz \
			   cde/onboot.lst
CLEANFILES		+= $(TINYCORE_FILES) cde/ tmp/tinycore-@VERSION@
DOWNLOAD_FILES          += $(TINYCORE_FILES)


$(CONFIGDIR)/tinycore/tinycore.cfg: Makefile $(DISTRODIR)/tinycore/tinycore.cfg
	@SRCFILE="$(DISTRODIR)/tinycore/tinycore.cfg"; \
	   DISTRO_CODENAME="@VERSION@"; \
	   DISTRO_VERSION="@VERSION@"; \
	   $(do_subst_dt)


# http://tinycorelinux.net/7.x/x86/release/TinyCore-7.2.iso
tmp/tinycore-@VERSION@.iso:
	URL="$(MIRROR_TINYCORE)/@CODENAME@/x86/release/TinyCore-@VERSION@.iso"; \
	   $(download_file)
	@test -f "$(@)" && touch "$(@)"


tmp/tinycore-@VERSION@/boot/vmlinuz: tmp/tinycore-@VERSION@.iso
	bash src/scripts/extractiso.sh \
	   tmp/tinycore-@VERSION@.iso \
	   tmp/tinycore-@VERSION@
	@test -f "$(@)" && touch "$(@)"


cde/onboot.lst: tmp/tinycore-@VERSION@/boot/vmlinuz
	rsync -ra tmp/tinycore-@VERSION@/cde/ cde
	@chmod -R u+w cde
	@test -f "$(@)" && touch "$(@)"


boot/tinycore/@VERSION@/core.gz: tmp/tinycore-@VERSION@/boot/vmlinuz
	@mkdir -p "$$(dirname "$(@)")"
	cp tmp/tinycore-@VERSION@/boot/core.gz "$(@)"
	@test -f "$(@)" && touch "$(@)"
	

boot/tinycore/@VERSION@/vmlinuz: tmp/tinycore-@VERSION@/boot/vmlinuz
	@mkdir -p "$$(dirname "$(@)")"
	cp tmp/tinycore-@VERSION@/boot/vmlinuz "$(@)"
	@test -f "$(@)" && touch "$(@)"
	

tinycore: $(CONFIGDIR)/tinycore/tinycore.cfg $(TINYCORE_FILES)

