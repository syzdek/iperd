

CENTOS_FILES		+= \
			   boot/centos/@VERSION@/initrd \
			   boot/centos/@VERSION@/vmlinuz
CENTOS_CFG		+= \
			   $(CONFIGDIR)/centos/centos@VERSION@.cfg


$(CONFIGDIR)/centos/centos@VERSION@.cfg: Makefile Makefile.config $(DISTRODIR)/centos/centos.cfg
	@SRCFILE="$(DISTRODIR)/centos/centos.cfg"; \
	   DISTRO_CODENAME="@VERSION@"; \
	   DISTRO_VERSION="@VERSION@"; \
	   $(do_subst_dt)


boot/centos/@VERSION@/initrd:
	URL="$(MIRROR_CENTOS)/@VERSION@/os/x86_64/isolinux/initrd.img"; \
	   $(download_file)


boot/centos/@VERSION@/vmlinuz:
	URL="$(MIRROR_CENTOS)/@VERSION@/os/x86_64/isolinux/vmlinuz"; \
	   $(download_file)


