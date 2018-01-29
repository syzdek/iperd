
DOWNLOAD_FILES		+= \
			   boot/archboot/@VERSION@/@ARCH@/vmlinuz \
			   boot/archboot/@VERSION@/@ARCH@/initrd


boot/archboot/@VERSION@/@ARCH@/vmlinuz:
	./src/scripts/download.sh \
	   -k \
	   -H $(ARCHBOOT_HASHES)/vmlinuz-@VERSION@-@ARCH@.sha512 \
	   -t tmp/$(@) \
	   "$(@)" \
	   "$(MIRROR_ARCHBOOT)/@VERSION@/boot/vmlinuz_@ARCH@"


boot/archboot/@VERSION@/@ARCH@/initrd:
	./src/scripts/download.sh \
	   -k \
	   -H $(ARCHBOOT_HASHES)/initrd-@VERSION@-@ARCH@.sha512 \
	   -t tmp/$(@) \
	   "$(@)" \
	   "$(MIRROR_ARCHBOOT)/@VERSION@/boot/initramfs_@ARCH@.img"

