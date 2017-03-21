
DEBIAN_FILES		+= \
			   boot/debian@VERSION@/vmlinuz \
			   boot/debian@VERSION@/initrd
DEBIAN_CFG           += \
			   $(CONFIGDIR)/debian/debian@VERSION@.cfg


$(CONFIGDIR)/debian/debian@VERSION@.cfg: Makefile Makefile.config $(DISTRODIR)/debian/debian.cfg
	SRCFILE="$(DISTRODIR)/debian/debian.cfg"; \
	   DISTRO_CODENAME="@CODENAME@"; \
	   DISTRO_VERSION="@VERSION@"; \
	   $(do_subst_dt)


boot/debian@VERSION@/vmlinuz:
	@rm -f $(@)
	@mkdir -p $$(dirname "$(@)")
	wget \
	   -O "$(@)" \
           "$(MIRROR_DEBIAN)/dists/@CODENAME@/main/installer-amd64/current/images/cdrom/vmlinuz" \
	   || { rm -f "$(@)}"; exit 1; }
	@touch "$(@)"


boot/debian@VERSION@/initrd:
	@rm -f $(@)
	@mkdir -p $$(dirname "$(@)")
	wget \
	   -O "$(@)" \
           "$(MIRROR_DEBIAN)/dists/@CODENAME@/main/installer-amd64/current/images/cdrom/initrd.gz" \
	   || { rm -f "$(@)}"; exit 1; }
	@touch "$(@)"


