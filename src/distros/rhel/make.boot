
DOWNLOAD_FILES		+= \
			   boot/rhel/@VERSION@/initrd \
			   boot/rhel/@VERSION@/vmlinuz


boot/rhel/@VERSION@/initrd:
	./src/scripts/download.sh \
	   -k \
	   -t tmp/$(@) \
	   $(@) \
	   $(MIRROR_RHEL)/@VERSION@/isos/x86_64/rhel-server-@VERSION@-@ARCH@-boot/isolinux/initrd.img


boot/rhel/@VERSION@/vmlinuz:
	./src/scripts/download.sh \
	   -k \
	   -t tmp/$(@) \
	   $(@) \
	   $(MIRROR_RHEL)/@VERSION@/isos/x86_64/rhel-server-@VERSION@-@ARCH@-boot/isolinux/vmlinuz

