
UBUNTU_FILES		+= \
			   boot/ubuntu/@VERSION@/@ARCH@/vmlinuz \
			   boot/ubuntu/@VERSION@/@ARCH@/initrd
UBUNTU_CFG		+= \
			   $(CONFIGDIR)/ubuntu/ubuntu@VERSION@@ARCH@.cfg


$(CONFIGDIR)/ubuntu/ubuntu@VERSION@@ARCH@.cfg: Makefile Makefile.config $(DISTRODIR)/ubuntu/ubuntu.cfg
	SRCFILE="$(DISTRODIR)/ubuntu/ubuntu.cfg"; \
	   DISTRO_CODENAME="@CODENAME@"; \
	   DISTRO_VERSION="@VERSION@"; \
	   $(do_subst_dt)


boot/ubuntu/@VERSION@/@ARCH@/vmlinuz:
	./src/scripts/download.sh \
	   -k \
	   -t tmp/$(@) \
	   $(@) \
	   $(MIRROR_UBUNTU)/dists/@CODENAME@/main/installer-@ARCH@/current/images/cdrom/vmlinuz


boot/ubuntu/@VERSION@/@ARCH@/initrd:
	./src/scripts/download.sh \
	   -k \
	   -t tmp/$(@) \
	   $(@) \
	   $(MIRROR_UBUNTU)/dists/@CODENAME@/main/installer-@ARCH@/current/images/cdrom/initrd.gz


