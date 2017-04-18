

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


tmp/alpine-@VERSION@-@ARCH@.iso:
	URL="$(MIRROR_ALPINE)/@CODENAME@/releases/@ARCH@/alpine-extended-@VERSION@-@ARCH@.iso"; \
	   $(download_file)


tmp/alpine-@VERSION@-@ARCH@/.extracted: tmp/alpine-@VERSION@-@ARCH@.iso
	rm -Rf "tmp/alpine-@VERSION@-@ARCH@"
	bash src/scripts/extractiso.sh \
	   tmp/alpine-@VERSION@-@ARCH@.iso \
	   tmp/alpine-@VERSION@-@ARCH@ \
	   || { rm -Rf "tmp/alpine-@VERSION@-@ARCH@"; exit 1; }
	@touch "$(@)"


boot/alpine/@VERSION@/@ARCH@/vmlinuz: tmp/alpine-@VERSION@-@ARCH@/.extracted
	@rm -f "$(@)"
	@mkdir -p "$$(dirname "$(@)")"
	cp tmp/alpine-@VERSION@-@ARCH@/boot/vmlinuz-grsec "$(@)"
	@test -f "$(@)" && touch "$(@)"


boot/alpine/@VERSION@/@ARCH@/initrd: tmp/alpine-@VERSION@-@ARCH@/.extracted
	@rm -f "$(@)"
	@mkdir -p "$$(dirname "$(@)")"
	cp tmp/alpine-@VERSION@-@ARCH@/boot/initramfs-grsec "$(@)"
	@test -f "$(@)" && touch "$(@)"


boot/alpine/@VERSION@/@ARCH@/modloop: tmp/alpine-@VERSION@-@ARCH@/.extracted
	@rm -f "$(@)"
	@mkdir -p "$$(dirname "$(@)")"
	cp tmp/alpine-@VERSION@-@ARCH@/boot/modloop-grsec "$(@)"
	@test -f "$(@)" && touch "$(@)"


boot/alpine/@VERSION@/apks/@ARCH@/.iperd: tmp/alpine-@VERSION@-@ARCH@/.extracted
	@rm -Rf boot/alpine/@VERSION@/apks/@ARCH@
	@mkdir -p "$$(dirname "$(@)")"
	rsync -r \
	   tmp/alpine-@VERSION@-@ARCH@/apks/@ARCH@/ \
	   boot/alpine/@VERSION@/apks/@ARCH@/
	@touch "$(@)"

