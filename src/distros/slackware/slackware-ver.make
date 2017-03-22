
SLACKWARE_FILES		+= \
			   boot/slack@ARCH@/@VERSION@/COPYING \
			   boot/slack@ARCH@/@VERSION@/bzImage \
			   boot/slack@ARCH@/@VERSION@/initrd
SLACKWARE_CFG           += \
			   $(CONFIGDIR)/slackware/slackware@ARCH@-@VERSION@.cfg


$(CONFIGDIR)/slackware/slackware@ARCH@-@VERSION@.cfg: Makefile Makefile.config $(DISTRODIR)/slackware/slackware.cfg
	SRCFILE="$(DISTRODIR)/slackware/slackware.cfg"; \
	   DISTRO_CODENAME="@CODENAME@"; \
	   DISTRO_VERSION="@VERSION@"; \
	   DISTRO_ARCH="@ARCH@"; \
	   $(do_subst_dt)

boot/slack@ARCH@/@VERSION@/COPYING:
	@rm -f $(@)
	@mkdir -p $$(dirname "$(@)")
	wget \
	   -O "$(@)" \
	   "$(MIRROR_SLACKWARE)/slackware@ARCH@-@VERSION@/COPYRIGHT.TXT" \
	   || { rm -f "$(@)}"; exit 1; }
	@touch "$(@)"


boot/slack@ARCH@/@VERSION@/bzImage:
	@rm -f $(@)
	@mkdir -p $$(dirname "$(@)")
	wget \
	   -O "$(@)" \
	   "$(MIRROR_SLACKWARE)/slackware@ARCH@-@VERSION@/kernels/huge.s/bzImage" \
	   || { rm -f "$(@)}"; exit 1; }
	@touch "$(@)"


boot/slack@ARCH@/@VERSION@/initrd:
	@rm -f $(@)
	@mkdir -p $$(dirname "$(@)")
	wget \
	   -O "$(@)" \
	   "$(MIRROR_SLACKWARE)/slackware@ARCH@-@VERSION@/isolinux/initrd.img" \
	   || { rm -f "$(@)}"; exit 1; }
	@touch "$(@)"


