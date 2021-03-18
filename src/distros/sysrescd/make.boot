
DOWNLOAD_FILES          += boot/sysrescd/@VERSION@/@ARCH@/airootfs.sfs \
			   boot/sysrescd/@VERSION@/@ARCH@/airootfs.sha512 \
			   boot/sysrescd/@VERSION@/@ARCH@/amd_ucode.img \
			   boot/sysrescd/@VERSION@/@ARCH@/intel_ucode.img \
			   boot/sysrescd/@VERSION@/@ARCH@/sysresccd.img \
			   boot/sysrescd/@VERSION@/@ARCH@/vmlinuz


tmp/boot/sysrescd/sysrescd-@VERSION@-@ARCH@/.iperd-extracted:
	./src/scripts/download.sh \
	   -H $(SYSRESCD_HASHES)/sysrescd-@VERSION@-@ARCH@.sha512 \
	   -e tmp/boot/sysrescd/sysrescd-@VERSION@-@ARCH@ \
	   tmp/boot/sysrescd/sysrescd-@VERSION@-@ARCH@.iso \
	   $(MIRROR_SYSRESCD)/@VERSION@/systemrescue-@VERSION@-@ARCH@.iso


boot/sysrescd/@VERSION@/@ARCH@/airootfs.sfs: tmp/boot/sysrescd/sysrescd-@VERSION@-@ARCH@/.iperd-extracted
	@mkdir -p "$$(dirname "$(@)")"
	cp tmp/boot/sysrescd/sysrescd-@VERSION@-@ARCH@/sysresccd/@ARCH@/airootfs.sfs "$(@)"
	@touch "$(@)"


boot/sysrescd/@VERSION@/@ARCH@/airootfs.sha512: tmp/boot/sysrescd/sysrescd-@VERSION@-@ARCH@/.iperd-extracted
	@mkdir -p "$$(dirname "$(@)")"
	cp tmp/boot/sysrescd/sysrescd-@VERSION@-@ARCH@/sysresccd/@ARCH@/airootfs.sha512 "$(@)"
	@touch "$(@)"


boot/sysrescd/@VERSION@/@ARCH@/amd_ucode.img: tmp/boot/sysrescd/sysrescd-@VERSION@-@ARCH@/.iperd-extracted
	@mkdir -p "$$(dirname "$(@)")"
	cp tmp/boot/sysrescd/sysrescd-@VERSION@-@ARCH@/sysresccd/boot/intel_ucode.img "$(@)"
	@touch "$(@)"


boot/sysrescd/@VERSION@/@ARCH@/intel_ucode.img: tmp/boot/sysrescd/sysrescd-@VERSION@-@ARCH@/.iperd-extracted
	@mkdir -p "$$(dirname "$(@)")"
	cp tmp/boot/sysrescd/sysrescd-@VERSION@-@ARCH@/sysresccd/boot/intel_ucode.img "$(@)"
	@touch "$(@)"


boot/sysrescd/@VERSION@/@ARCH@/sysresccd.img: tmp/boot/sysrescd/sysrescd-@VERSION@-@ARCH@/.iperd-extracted
	@mkdir -p "$$(dirname "$(@)")"
	cp tmp/boot/sysrescd/sysrescd-@VERSION@-@ARCH@/sysresccd/boot/@ARCH@/sysresccd.img "$(@)"
	@touch "$(@)"

	
boot/sysrescd/@VERSION@/@ARCH@/vmlinuz: tmp/boot/sysrescd/sysrescd-@VERSION@-@ARCH@/.iperd-extracted
	@mkdir -p "$$(dirname "$(@)")"
	cp tmp/boot/sysrescd/sysrescd-@VERSION@-@ARCH@/sysresccd/boot/@ARCH@/vmlinuz "$(@)"
	@touch "$(@)"
	

