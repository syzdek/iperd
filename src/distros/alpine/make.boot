
DOWNLOAD_FILES		+= \
			   boot/alpine/@VERSION@/@ARCH@/vmlinuz \
			   boot/alpine/@VERSION@/@ARCH@/initrd \
			   boot/alpine/@VERSION@/@ARCH@/modloop \
			   boot/alpine/@VERSION@/apks/@ARCH@/.iperd


tmp/boot/alpine/alpine-@VERSION@-@ARCH@-iso/.iperd-extracted:
	./src/scripts/download.sh \
	   -k \
	   -H $(ALPINE_HASHES)/alpine-@VERSION@-@ARCH@-iso.sha512 \
	   -e tmp/boot/alpine/alpine-@VERSION@-@ARCH@-iso \
	   -t tmp/boot/alpine/alpine-@VERSION@-@ARCH@.iso.tmp \
	   tmp/boot/alpine/alpine-@VERSION@-@ARCH@.iso \
	   $(MIRROR_ALPINE)/@CODENAME@/releases/@ARCH@/alpine-standard-@VERSION@-@ARCH@.iso


tmp/boot/alpine/alpine-@VERSION@-@ARCH@/.iperd-extracted:
	./src/scripts/download.sh \
	   -k \
	   -H $(ALPINE_HASHES)/alpine-@VERSION@-@ARCH@.sha512 \
	   -e tmp/boot/alpine/alpine-@VERSION@-@ARCH@ \
	   -t tmp/boot/alpine/alpine-@VERSION@-@ARCH@.tar.gz.tmp \
	   tmp/boot/alpine/alpine-@VERSION@-@ARCH@.tar.gz \
	   $(MIRROR_ALPINE)/@CODENAME@/releases/@ARCH@/alpine-netboot-@VERSION@-@ARCH@.tar.gz


boot/alpine/@VERSION@/@ARCH@/vmlinuz: tmp/boot/alpine/alpine-@VERSION@-@ARCH@/.iperd-extracted
	@rm -f "$(@)"
	@mkdir -p "$$(dirname "$(@)")"
	cp tmp/boot/alpine/alpine-@VERSION@-@ARCH@/boot/vmlinuz-lts "$(@)"
	@chmod 644 "$(@)"
	@touch "$(@)"


boot/alpine/@VERSION@/@ARCH@/initrd: tmp/boot/alpine/alpine-@VERSION@-@ARCH@/.iperd-extracted
	@rm -f "$(@)"
	@mkdir -p "$$(dirname "$(@)")"
	cp tmp/boot/alpine/alpine-@VERSION@-@ARCH@/boot/initramfs-lts "$(@)"
	@chmod 644 "$(@)"
	@touch "$(@)"


boot/alpine/@VERSION@/@ARCH@/modloop: tmp/boot/alpine/alpine-@VERSION@-@ARCH@/.iperd-extracted
	@rm -f "$(@)"
	@mkdir -p "$$(dirname "$(@)")"
	cp tmp/boot/alpine/alpine-@VERSION@-@ARCH@/boot/modloop-lts "$(@)"
	@chmod 644 "$(@)"
	@test -f "$(@)" && touch "$(@)"


boot/alpine/@VERSION@/apks/@ARCH@/.iperd: tmp/boot/alpine/alpine-@VERSION@-@ARCH@-iso/.iperd-extracted
	@rm -Rf boot/alpine/@VERSION@/apks/@ARCH@
	@mkdir -p "$$(dirname "$(@)")"
	@rsync -rav tmp/boot/alpine/alpine-@VERSION@-@ARCH@-iso/apks/@ARCH@/ boot/alpine/@VERSION@/apks/@ARCH@
	@touch "$(@)"

