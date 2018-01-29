
DOWNLOAD_FILES		+= \
			   boot/debian/@VERSION@/@ARCH@/vmlinuz \
			   boot/debian/@VERSION@/@ARCH@/initrd


boot/debian/@VERSION@/@ARCH@/vmlinuz:
	./src/scripts/download.sh \
	   -k \
	   -t tmp/$(@) \
	   $(@) \
	   $(MIRROR_DEBIAN)/dists/@CODENAME@/main/installer-@ARCH@/current/images/cdrom/vmlinuz


boot/debian/@VERSION@/@ARCH@/initrd:
	./src/scripts/download.sh \
	   -k \
	   -t tmp/$(@) \
	   $(@) \
	   $(MIRROR_DEBIAN)/dists/@CODENAME@/main/installer-@ARCH@/current/images/cdrom/initrd.gz


