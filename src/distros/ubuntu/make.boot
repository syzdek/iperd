
DOWNLOAD_FILES		+= \
			   boot/ubuntu/@VERSION@/@ARCH@/vmlinuz \
			   boot/ubuntu/@VERSION@/@ARCH@/initrd


boot/ubuntu/@VERSION@/@ARCH@/vmlinuz:
	./src/scripts/download.sh \
	   -k \
	   -t tmp/$(@) \
	   $(@) \
	   $(MIRROR_UBUNTU)/dists/@CODENAME@/main/installer-@ARCH@/current/images/cdrom/vmlinuz


boot/ubuntu/@VERSION@/@ARCH@/initrd:
	./src/scripts/download.sh \
	   -k \
	   -t tmp/$(@) \
	   $(@) \
	   $(MIRROR_UBUNTU)/dists/@CODENAME@/main/installer-@ARCH@/current/images/cdrom/initrd.gz

