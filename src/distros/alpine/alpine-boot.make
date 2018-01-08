

ALPINE_FILES		+= \
			   boot/alpine/@VERSION@/@ARCH@/vmlinuz \
			   boot/alpine/@VERSION@/@ARCH@/initrd \
			   boot/alpine/@VERSION@/@ARCH@/modloop \
			   boot/alpine/@VERSION@/apks/@ARCH@/.iperd
ALPINE_CFG		+= \
			   $(CONFIGDIR)/alpine/alpine@VERSION@@ARCH@.cfg
ALPINE_PXE_CFG		+= \
			   $(CONFIGDIR)/alpine/alpine@VERSION@@ARCH@.pxe.cfg


$(CONFIGDIR)/alpine/alpine@VERSION@@ARCH@.cfg: Makefile Makefile.config $(DISTRODIR)/alpine/alpine-boot.cfg
	@SRCFILE="$(DISTRODIR)/alpine/alpine-boot.cfg"; \
	   DISTRO_CODENAME="@CODENAME@"; \
	   DISTRO_VERSION="@VERSION@"; \
	   DISTRO_ARCH="@ARCH@"; \
	   $(do_subst_dt)


$(CONFIGDIR)/alpine/alpine@VERSION@@ARCH@.pxe.cfg: Makefile Makefile.config $(DISTRODIR)/alpine/alpine-boot.pxe.cfg
	@SRCFILE="$(DISTRODIR)/alpine/alpine-boot.pxe.cfg"; \
	   DISTRO_CODENAME="@CODENAME@"; \
	   DISTRO_VERSION="@VERSION@"; \
	   DISTRO_ARCH="@ARCH@"; \
	   $(do_subst_dt)


tmp/boot/alpine/alpine-@VERSION@-@ARCH@/.iperd-extracted:
	./src/scripts/download.sh \
	   -k \
	   -H $(ALPINE_HASHES)/alpine-@VERSION@-@ARCH@.sha512 \
	   -e tmp/boot/alpine/alpine-@VERSION@-@ARCH@ \
	   -t tmp/boot/alpine/alpine-@VERSION@-@ARCH@.iso.tmp \
	   boot/alpine/alpine-@VERSION@-@ARCH@.iso \
	   $(MIRROR_ALPINE)/@CODENAME@/releases/@ARCH@/alpine-standard-@VERSION@-@ARCH@.iso


boot/alpine/@VERSION@/@ARCH@/vmlinuz: tmp/boot/alpine/alpine-@VERSION@-@ARCH@/.iperd-extracted
	@rm -f "$(@)"
	@mkdir -p "$$(dirname "$(@)")"
	cp tmp/boot/alpine/alpine-@VERSION@-@ARCH@/boot/vmlinuz-hardened "$(@)"
	@touch "$(@)"


boot/alpine/@VERSION@/@ARCH@/initrd: tmp/boot/alpine/alpine-@VERSION@-@ARCH@/.iperd-extracted
	@rm -f "$(@)"
	@mkdir -p "$$(dirname "$(@)")"
	cp tmp/boot/alpine/alpine-@VERSION@-@ARCH@/boot/initramfs-hardened "$(@)"
	@touch "$(@)"


boot/alpine/@VERSION@/@ARCH@/modloop: tmp/boot/alpine/alpine-@VERSION@-@ARCH@/.iperd-extracted
	@rm -f "$(@)"
	@mkdir -p "$$(dirname "$(@)")"
	cp tmp/boot/alpine/alpine-@VERSION@-@ARCH@/boot/modloop-hardened "$(@)"
	@test -f "$(@)" && touch "$(@)"


boot/alpine/@VERSION@/apks/@ARCH@/.iperd: tmp/boot/alpine/alpine-@VERSION@-@ARCH@/.iperd-extracted
	@rm -Rf boot/alpine/@VERSION@/apks/@ARCH@
	@mkdir -p "$$(dirname "$(@)")"
	rsync -r \
           tmp/boot/alpine/alpine-@VERSION@-@ARCH@/apks/@ARCH@/ \
	   boot/alpine/@VERSION@/apks/@ARCH@
	@touch "$(@)"


