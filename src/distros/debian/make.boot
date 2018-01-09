
DEBIAN_FILES		+= \
			   boot/debian/@VERSION@/@ARCH@/vmlinuz \
			   boot/debian/@VERSION@/@ARCH@/initrd
DEBIAN_CFG           += \
			   $(CONFIGDIR)/debian/debian@VERSION@@ARCH@.cfg


$(CONFIGDIR)/debian/debian@VERSION@@ARCH@.cfg: Makefile Makefile.config $(DISTRODIR)/debian/debian.cfg
	SRCFILE="$(DISTRODIR)/debian/debian.cfg"; \
	   DISTRO_CODENAME="@CODENAME@"; \
	   DISTRO_VERSION="@VERSION@"; \
	   $(do_subst_dt)


boot/debian/@VERSION@/@ARCH@/vmlinuz:
	./src/scripts/download.sh \
	   -k \
	   -t tmp/$(@) \
	   $(@) \
	   $(MIRROR_DEBIAN)/dists/@CODENAME@/main/installer-@ARCH@/current/images/cdrom/vmlinuz


boot/debian/@VERSION@/@ARCH@/initrd:
	./src/scripts/download.sh \
	   -k \
	   -t tmp/$(@) \
	   $(@) \
	   $(MIRROR_DEBIAN)/dists/@CODENAME@/main/installer-@ARCH@/current/images/cdrom/initrd.gz


