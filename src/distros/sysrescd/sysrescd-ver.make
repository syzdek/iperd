
ISOLINUX_CFG            += $(CONFIGDIR)/sysrescd/sysrescd.cfg
PXELINUX_CFG            += $(CONFIGDIR)/sysrescd/sysrescd.cfg
SYSLINUX_CFG            += $(CONFIGDIR)/sysrescd/sysrescd.cfg
DOWNLOAD_FILES          += boot/sysrescd/sysrcd.dat \
			   boot/sysrescd/vmlinuz.32 \
			   boot/sysrescd/vmlinuz.64 \
			   boot/sysrescd/vmlinuz.nt \
			   boot/sysrescd/initrd.cgz \
			   boot/sysrescd/initram.igz \
			   boot/sysrescd/scsi.cgz
CLEANFILES		+= boot/sysrescd tmp/sysrescd-@VERSION@


$(CONFIGDIR)/sysrescd/sysrescd.cfg: Makefile $(DISTRODIR)/sysrescd/sysrescd.cfg
	@SRCFILE="$(DISTRODIR)/sysrescd/sysrescd.cfg"; \
	   DISTRO_CODENAME="@VERSION@"; \
	   DISTRO_VERSION="@VERSION@"; \
	   $(do_subst_dt)


# /sysresccd-x86/4.9.4/systemrescuecd-x86-4.9.4.iso
tmp/sysrescd-@VERSION@.iso:
	URL="$(MIRROR_SYSRESCD)/@VERSION@/systemrescuecd-x86-@VERSION@.iso"; \
	   $(download_file)
	test -f "$(@)" && touch "$(@)"


tmp/sysrescd-@VERSION@/sysrcd.dat: tmp/sysrescd-@VERSION@.iso
	bash src/scripts/extractiso.sh \
	   tmp/sysrescd-@VERSION@.iso \
	   tmp/sysrescd-@VERSION@
	test -f "$(@)" && touch "$(@)"


boot/sysrescd/initram.igz: tmp/sysrescd-@VERSION@/sysrcd.dat
	@mkdir -p "$$(dirname "$(@)")"
	cp tmp/sysrescd-@VERSION@/isolinux/initram.igz "$(@)"
	test -f "$(@)" && touch "$(@)"
	

boot/sysrescd/initrd.cgz: tmp/sysrescd-@VERSION@/sysrcd.dat
	@mkdir -p "$$(dirname "$(@)")"
	cp tmp/sysrescd-@VERSION@/ntpasswd/initrd.cgz "$(@)"
	test -f "$(@)" && touch "$(@)"
	

boot/sysrescd/scsi.cgz: tmp/sysrescd-@VERSION@/sysrcd.dat
	@mkdir -p "$$(dirname "$(@)")"
	cp tmp/sysrescd-@VERSION@/ntpasswd/scsi.cgz "$(@)"
	test -f "$(@)" && touch "$(@)"
	

boot/sysrescd/vmlinuz.32: tmp/sysrescd-@VERSION@/sysrcd.dat
	@mkdir -p "$$(dirname "$(@)")"
	cp tmp/sysrescd-@VERSION@/isolinux/rescue32 "$(@)"
	test -f "$(@)" && touch "$(@)"
	

boot/sysrescd/vmlinuz.64: tmp/sysrescd-@VERSION@/sysrcd.dat
	@mkdir -p "$$(dirname "$(@)")"
	cp tmp/sysrescd-@VERSION@/isolinux/rescue64 "$(@)"
	test -f "$(@)" && touch "$(@)"
	

boot/sysrescd/vmlinuz.nt: tmp/sysrescd-@VERSION@/sysrcd.dat
	@mkdir -p "$$(dirname "$(@)")"
	cp tmp/sysrescd-@VERSION@/ntpasswd/vmlinuz "$(@)"
	test -f "$(@)" && touch "$(@)"


boot/sysrescd/sysrcd.dat: tmp/sysrescd-@VERSION@/sysrcd.dat
	@mkdir -p "$$(dirname "$(@)")"
	cp tmp/sysrescd-@VERSION@/sysrcd.dat "$(@)"
	test -f "$(@)" && touch "$(@)"


sysrescd: $(CONFIGDIR)/sysrescd.cfg boot/sysrescd/sysrescd.bin

