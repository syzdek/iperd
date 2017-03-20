
DEBIAN_FILES		+= \
			   boot/deb@VERSION@/vmlinuz \
			   boot/deb@VERSION@/initrd
DEBIAN_CFG           += \
			   $(CONFIGDIR)/debian/debian@VERSION@.cfg


$(CONFIGDIR)/debian/debian@VERSION@.cfg: Makefile Makefile.config $(DISTRODIR)/debian/debian.cfg
	SRCFILE="$(DISTRODIR)/debian/debian.cfg"; \
	   DISTRO_CODENAME="@CODENAME@"; \
	   DISTRO_VERSION="@VERSION@"; \
	   $(do_subst_dt)


boot/deb@VERSION@/vmlinuz:
	@rm -f $(@)
	@mkdir -p $$(dirname "$(@)")
	wget \
	   -O "$(@)" \
           "$(MIRROR_DEBIAN)/dists/@CODENAME@/main/installer-amd64/current/images/cdrom/vmlinuz" \
	   || { rm -f "$(@)}"; exit 1; }
	@touch "$(@)"


boot/deb@VERSION@/initrd:
	@rm -f $(@)
	@mkdir -p $$(dirname "$(@)")
	wget \
	   -O "$(@)" \
           "$(MIRROR_DEBIAN)/dists/@CODENAME@/main/installer-amd64/current/images/cdrom/initrd.gz" \
	   || { rm -f "$(@)}"; exit 1; }
	@touch "$(@)"


