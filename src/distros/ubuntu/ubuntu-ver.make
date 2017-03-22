
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
	@rm -f $(@)
	@mkdir -p $$(dirname "$(@)")
	wget \
	   -O "$(@)" \
           "$(MIRROR_UBUNTU)/dists/@CODENAME@/main/installer-amd64/current/images/cdrom/vmlinuz" \
	   || { rm -f "$(@)}"; exit 1; }
	@touch "$(@)"


boot/ubuntu/@VERSION@/initrd:
	@rm -f $(@)
	@mkdir -p $$(dirname "$(@)")
	wget \
	   -O "$(@)" \
           "$(MIRROR_UBUNTU)/dists/@CODENAME@/main/installer-amd64/current/images/cdrom/initrd.gz" \
	   || { rm -f "$(@)}"; exit 1; }
	@touch "$(@)"


