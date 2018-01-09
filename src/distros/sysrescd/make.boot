
ISOLINUX_CFG            += $(CONFIGDIR)/sysrescd/@VERSION@/sysrescd.cfg
PXELINUX_CFG            += $(CONFIGDIR)/sysrescd/@VERSION@/sysrescd.pxe.cfg
SYSLINUX_CFG            += $(CONFIGDIR)/sysrescd/@VERSION@/sysrescd.cfg
DOWNLOAD_FILES          += boot/sysrescd/@VERSION@/sysrcd.dat \
			   boot/sysrescd/@VERSION@/sysrcd.md5 \
			   boot/sysrescd/@VERSION@/vmlinuz.32 \
			   boot/sysrescd/@VERSION@/vmlinuz.64 \
			   boot/sysrescd/@VERSION@/vmlinuz.nt \
			   boot/sysrescd/@VERSION@/initrd.cgz \
			   boot/sysrescd/@VERSION@/initram.igz \
			   boot/sysrescd/@VERSION@/scsi.cgz


$(CONFIGDIR)/sysrescd/@VERSION@/sysrescd.pxe.cfg: Makefile $(DISTRODIR)/sysrescd/sysrescd.pxe.cfg
	@SRCFILE="$(DISTRODIR)/sysrescd/sysrescd.pxe.cfg"; \
	   DISTRO_CODENAME="@VERSION@"; \
	   DISTRO_VERSION="@VERSION@"; \
	   $(do_subst_dt)


$(CONFIGDIR)/sysrescd/@VERSION@/sysrescd.cfg: Makefile $(DISTRODIR)/sysrescd/sysrescd.cfg
	@SRCFILE="$(DISTRODIR)/sysrescd/sysrescd.cfg"; \
	   DISTRO_CODENAME="@VERSION@"; \
	   DISTRO_VERSION="@VERSION@"; \
	   $(do_subst_dt)


tmp/boot/sysrescd/sysrescd-@VERSION@/.iperd-extracted:
	./src/scripts/download.sh \
	   -H $(SYSRESCD_HASHES)/sysrescd-@VERSION@.sha512 \
	   -e tmp/boot/sysrescd/sysrescd-@VERSION@ \
	   tmp/boot/sysrescd/sysrescd-@VERSION@.iso \
	   $(MIRROR_SYSRESCD)/@VERSION@/systemrescuecd-x86-@VERSION@.iso


boot/sysrescd/@VERSION@/sysrcd.md5: tmp/boot/sysrescd/sysrescd-@VERSION@/.iperd-extracted
	@mkdir -p "$$(dirname "$(@)")"
	cp tmp/boot/sysrescd/sysrescd-@VERSION@/sysrcd.md5 "$(@)"
	@touch "$(@)"


boot/sysrescd/@VERSION@/initram.igz: tmp/boot/sysrescd/sysrescd-@VERSION@/.iperd-extracted
	@mkdir -p "$$(dirname "$(@)")"
	cp tmp/boot/sysrescd/sysrescd-@VERSION@/isolinux/initram.igz "$(@)"
	@touch "$(@)"
	

boot/sysrescd/@VERSION@/initrd.cgz: tmp/boot/sysrescd/sysrescd-@VERSION@/.iperd-extracted
	@mkdir -p "$$(dirname "$(@)")"
	cp tmp/boot/sysrescd/sysrescd-@VERSION@/ntpasswd/initrd.cgz "$(@)"
	@touch "$(@)"
	

boot/sysrescd/@VERSION@/scsi.cgz: tmp/boot/sysrescd/sysrescd-@VERSION@/.iperd-extracted
	@mkdir -p "$$(dirname "$(@)")"
	cp tmp/boot/sysrescd/sysrescd-@VERSION@/ntpasswd/scsi.cgz "$(@)"
	@touch "$(@)"
	

boot/sysrescd/@VERSION@/vmlinuz.32: tmp/boot/sysrescd/sysrescd-@VERSION@/.iperd-extracted
	@mkdir -p "$$(dirname "$(@)")"
	cp tmp/boot/sysrescd/sysrescd-@VERSION@/isolinux/rescue32 "$(@)"
	@touch "$(@)"
	

boot/sysrescd/@VERSION@/vmlinuz.64: tmp/boot/sysrescd/sysrescd-@VERSION@/.iperd-extracted
	@mkdir -p "$$(dirname "$(@)")"
	cp tmp/boot/sysrescd/sysrescd-@VERSION@/isolinux/rescue64 "$(@)"
	@touch "$(@)"
	

boot/sysrescd/@VERSION@/vmlinuz.nt: tmp/boot/sysrescd/sysrescd-@VERSION@/.iperd-extracted
	@mkdir -p "$$(dirname "$(@)")"
	cp tmp/boot/sysrescd/sysrescd-@VERSION@/ntpasswd/vmlinuz "$(@)"
	@touch "$(@)"


boot/sysrescd/@VERSION@/sysrcd.dat: tmp/boot/sysrescd/sysrescd-@VERSION@/.iperd-extracted
	@mkdir -p "$$(dirname "$(@)")"
	cp tmp/boot/sysrescd/sysrescd-@VERSION@/sysrcd.dat "$(@)"
	@touch "$(@)"


#sysrescd: $(CONFIGDIR)/sysrescd.cfg boot/sysrescd/sysrescd.bin

