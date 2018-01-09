
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
	./src/scripts/download.sh \
	   -k \
	   -t tmp/$(@) \
	   "$(@)" \
	   "$(MIRROR_SLACKWARE)/slackware@ARCH@-@VERSION@/COPYRIGHT.TXT"


boot/slack@ARCH@/@VERSION@/bzImage:
	./src/scripts/download.sh \
	   -k \
	   -H $(SLACKWARE_HASHES)/bzImage@ARCH@-@VERSION@.sha512 \
	   -t tmp/$(@) \
	   "$(@)" \
	   "$(MIRROR_SLACKWARE)/slackware@ARCH@-@VERSION@/kernels/huge.s/bzImage"


boot/slack@ARCH@/@VERSION@/initrd:
	./src/scripts/download.sh \
	   -k \
	   -H $(SLACKWARE_HASHES)/initrd@ARCH@-@VERSION@.sha512 \
	   -t tmp/$(@) \
	   "$(@)" \
	   "$(MIRROR_SLACKWARE)/slackware@ARCH@-@VERSION@/isolinux/initrd.img"

