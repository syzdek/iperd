

CENTOS_FILES		+= \
			   boot/centos/@VERSION@/EULA \
			   boot/centos/@VERSION@/GPL \
			   boot/centos/@VERSION@/RELEASE-NOTES-en \
			   boot/centos/@VERSION@/initrd \
			   boot/centos/@VERSION@/vmlinuz
CENTOS_CFG		+= \
			   $(CONFIGDIR)/centos/centos@VERSION@.cfg


$(CONFIGDIR)/centos/centos@VERSION@.cfg: Makefile Makefile.config $(DISTRODIR)/centos/centos.cfg
	@SRCFILE="$(DISTRODIR)/centos/centos.cfg"; \
	   DISTRO_CODENAME="@VERSION@"; \
	   DISTRO_VERSION="@VERSION@"; \
	   $(do_subst_dt)


boot/centos/@VERSION@/EULA:
	URL="$(MIRROR_CENTOS)/@VERSION@/os/x86_64/EULA"; \
	   $(download_file)


boot/centos/@VERSION@/GPL:
	URL="$(MIRROR_CENTOS)/@VERSION@/os/x86_64/GPL"; \
	   $(download_file)


boot/centos/@VERSION@/RELEASE-NOTES-en:
	URL="$(MIRROR_CENTOS)/@VERSION@/os/x86_64/RELEASE-NOTES-en"; \
	   $(download_file)


boot/centos/@VERSION@/initrd:
	URL="$(MIRROR_CENTOS)/@VERSION@/os/x86_64/isolinux/initrd.img"; \
	   $(download_file)


boot/centos/@VERSION@/vmlinuz:
	URL="$(MIRROR_CENTOS)/@VERSION@/os/x86_64/isolinux/vmlinuz"; \
	   $(download_file)


