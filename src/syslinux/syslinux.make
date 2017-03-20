

.PHONY: syslinux


isolinux/isolinux.bin:
	rsync -ra "$(SYSLINUX_SRC)/" isolinux
	@cp /usr/share/hwdata/pci.ids isolinux/
	@touch "$(@)"


syslinux/syslinux.com:
	@mkdir -p boot/null
	rsync -ra "$(SYSLINUX_SRC)/" syslinux
	cp sudsboot/distros/syslinux/f1.txt syslinux/
	cp sudsboot/distros/syslinux/f2.txt syslinux/
	cp syslinux/pxelinux.0 pxelinux.0
	cp /usr/share/hwdata/pci.ids isolinux/
	@touch boot/null/null.iso.cfg
	@touch boot/null/null.pxe.cfg
	@touch boot/null/null.sys.cfg
	mkdir -p pxelinux.cfg
	@touch "$(@)"


syslinux: $(PREREQ_BIN)


# end of makefile
