
ISOLINUX_CFG            += $(CONFIGDIR)/tinycore/tinycore.cfg
PXELINUX_CFG            += $(CONFIGDIR)/tinycore/tinycore.cfg
SYSLINUX_CFG            += $(CONFIGDIR)/tinycore/tinycore.cfg
TINYCORE_FILES		=  boot/tinycore/@VERSION@/core.gz \
			   boot/tinycore/@VERSION@/vmlinuz
CLEANFILES		+= cde/
DOWNLOAD_FILES          += $(TINYCORE_FILES)


$(CONFIGDIR)/tinycore/tinycore.cfg: Makefile $(DISTRODIR)/tinycore/tinycore.cfg
	@SRCFILE="$(DISTRODIR)/tinycore/tinycore.cfg"; \
	   DISTRO_CODENAME="@VERSION@"; \
	   DISTRO_VERSION="@VERSION@"; \
	   $(do_subst_dt)


# http://tinycorelinux.net/7.x/x86/release/TinyCore-7.2.iso
tmp/boot/tinycore/tinycore-@VERSION@/.iperd-extracted:
	./src/scripts/download.sh \
	   -H src/distros/tinycore/hashes//tinycore-@VERSION@.sha512 \
	   -e tmp/boot/tinycore/tinycore-@VERSION@ \
	   tmp/boot/tinycore/tinycore-@VERSION@.iso \
	   $(MIRROR_TINYCORE)/@CODENAME@/x86/release/TinyCore-@VERSION@.iso


cde/iperd-synced: tmp/boot/tinycore/tinycore-@VERSION@/.iperd-extracted
	rsync -ra tmp/boot/tinycore/tinycore-@VERSION@/cde/ cde
	@chmod -R u+w cde
	@touch "$(@)"


boot/tinycore/@VERSION@/core.gz: cde/iperd-synced
	@mkdir -p "$$(dirname "$(@)")"
	cp tmp/boot/tinycore/tinycore-@VERSION@/boot/core.gz "$(@)"
	@test -f "$(@)" && touch "$(@)"
	

boot/tinycore/@VERSION@/vmlinuz: cde/iperd-synced
	@mkdir -p "$$(dirname "$(@)")"
	cp tmp/boot/tinycore/tinycore-@VERSION@/boot/vmlinuz "$(@)"
	@test -f "$(@)" && touch "$(@)"
	

#tinycore: $(CONFIGDIR)/tinycore/tinycore.cfg $(TINYCORE_FILES)

