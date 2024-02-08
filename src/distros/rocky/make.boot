

DOWNLOAD_FILES		+= \
			   boot/rocky/@VERSION@/initrd \
			   boot/rocky/@VERSION@/vmlinuz


boot/rocky/@VERSION@/initrd:
	./src/scripts/download.sh \
	   -k \
	   -t tmp/$(@) \
	   "$(@)" \
	   "$(MIRROR_ROCKY)/@VERSION@/BaseOS/x86_64/os/images/pxeboot/initrd.img"


boot/rocky/@VERSION@/vmlinuz:
	./src/scripts/download.sh \
	   -k \
	   -t tmp/$(@) \
	   "$(@)" \
	   "$(MIRROR_ROCKY)/@VERSION@/BaseOS/x86_64/os/images/pxeboot/vmlinuz"


