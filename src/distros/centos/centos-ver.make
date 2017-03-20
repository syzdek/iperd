

CENTOS_FILES		+= \
			    boot/centos@VERSION@/initrd \
			    boot/centos@VERSION@/vmlinuz
CENTOS_CFG		+= \
			   $(CONFIGDIR)/centos/centos@VERSION@.cfg


$(CONFIGDIR)/centos/centos@VERSION@.cfg: Makefile Makefile.config $(DISTRODIR)/centos/centos.cfg
	@SRCFILE="$(DISTRODIR)/centos/centos.cfg"; \
	   DISTRO_CODENAME="@VERSION@"; \
	   DISTRO_VERSION="@VERSION@"; \
	   $(do_subst_dt)


boot/centos@VERSION@/initrd:
	@rm -f $(@)
	@mkdir -p $$(dirname "$(@)")
	wget \
	   -O "$(@)" \
	   "$(MIRROR_CENTOS)/@VERSION@/os/x86_64/isolinux/initrd.img" \
	   || { rm -f "$(@)}"; exit 1; }
	@touch "$(@)"


boot/centos@VERSION@/vmlinuz:
	@rm -f $(@)
	@mkdir -p $$(dirname "$(@)")
	wget \
	   -O "$(@)" \
	   "$(MIRROR_CENTOS)/@VERSION@/os/x86_64/isolinux/vmlinuz" \
	   || { rm -f "$(@)}"; exit 1; }
	@touch "$(@)"


