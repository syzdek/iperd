
UBUNTU_FILES		+= \
			   boot/ubuntu/@VERSION@/vmlinuz \
			   boot/ubuntu/@VERSION@/initrd
UBUNTU_CFG		+= \
			   $(CONFIGDIR)/ubuntu/ubuntu@VERSION@.cfg


$(CONFIGDIR)/ubuntu/ubuntu@VERSION@.cfg: Makefile Makefile.config $(DISTRODIR)/ubuntu/ubuntu.cfg
	SRCFILE="$(DISTRODIR)/ubuntu/ubuntu.cfg"; \
	   DISTRO_CODENAME="@CODENAME@"; \
	   DISTRO_VERSION="@VERSION@"; \
	   $(do_subst_dt)


boot/ubuntu/@VERSION@/vmlinuz:
	URL="$(MIRROR_UBUNTU)/dists/@CODENAME@/main/installer-amd64/current/images/cdrom/vmlinuz"; \
	   $(download_file)


boot/ubuntu/@VERSION@/initrd:
	URL="$(MIRROR_UBUNTU)/dists/@CODENAME@/main/installer-amd64/current/images/cdrom/initrd.gz"; \
	   $(download_file)


