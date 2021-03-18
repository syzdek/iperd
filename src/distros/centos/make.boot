

DOWNLOAD_FILES		+= \
			   boot/centos/@VERSION@/initrd \
			   boot/centos/@VERSION@/vmlinuz


boot/centos/@VERSION@/initrd:
	./src/scripts/download.sh \
	   -k \
	   -t tmp/$(@) \
	   "$(@)" \
	   "$(MIRROR_CENTOS)/@VERSION@/os/x86_64/isolinux/initrd.img"


boot/centos/@VERSION@/vmlinuz:
	./src/scripts/download.sh \
	   -k \
	   -t tmp/$(@) \
	   "$(@)" \
	   "$(MIRROR_CENTOS)/@VERSION@/os/x86_64/isolinux/vmlinuz"


