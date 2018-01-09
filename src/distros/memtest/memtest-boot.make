
ISOLINUX_CFG            += $(CONFIGDIR)/memtest/memtest.cfg
PXELINUX_CFG            += $(CONFIGDIR)/memtest/memtest.cfg
SYSLINUX_CFG            += $(CONFIGDIR)/memtest/memtest.cfg
DOWNLOAD_FILES          += boot/memtest/memtest.bin


$(CONFIGDIR)/memtest/memtest.cfg: Makefile $(DISTRODIR)/memtest/memtest.cfg
	@SRCFILE="$(DISTRODIR)/memtest/memtest.cfg"; \
	   DISTRO_CODENAME="@VERSION@"; \
	   DISTRO_VERSION="@VERSION@"; \
	   $(do_subst_dt)

boot/memtest/memtest.bin:
	@rm -f $(@)
	@mkdir -p $$(dirname "$(@)")
	./src/scripts/download.sh \
	   tmp/boot/memtest/memtest86-@VERSION@.bin.gz \
	   $(MIRROR_MEMTEST)/@VERSION@/memtest86+-@VERSION@.bin.gz
	gzip -cd tmp/boot/memtest/memtest86-@VERSION@.bin.gz > $(@)
	@touch "$(@)"

