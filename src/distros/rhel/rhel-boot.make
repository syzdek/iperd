

RHEL_FILES		+= \
			   boot/rhel/@VERSION@/initrd \
			   boot/rhel/@VERSION@/vmlinuz
RHEL_CFG		+= \
			   $(CONFIGDIR)/rhel/rhel@VERSION@.cfg


$(CONFIGDIR)/rhel/rhel@VERSION@.cfg: Makefile Makefile.config $(DISTRODIR)/rhel/rhel.cfg
	@SRCFILE="$(DISTRODIR)/rhel/rhel.cfg"; \
	   DISTRO_CODENAME="@VERSION@"; \
	   DISTRO_VERSION="@VERSION@"; \
	   $(do_subst_dt)


boot/rhel/@VERSION@/initrd:
	URL="$(MIRROR_RHEL)/@VERSION@/isos/x86_64/rhel-server-@VERSION@-@ARCH@-boot/isolinux/initrd.img"; \
	   $(download_file)


boot/rhel/@VERSION@/vmlinuz:
	URL="$(MIRROR_RHEL)/@VERSION@/isos/x86_64/rhel-server-@VERSION@-@ARCH@-boot/isolinux/vmlinuz"; \
	   $(download_file)


