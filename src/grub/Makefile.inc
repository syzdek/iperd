#
#   IP Engineering Rescue Disk
#   Copyright (C) 2018 David M. Syzdek <david@syzdek.net>.
#
#   @SYZDEK_BSD_LICENSE_START@
#
#   Redistribution and use in source and binary forms, with or without
#   modification, are permitted provided that the following conditions are
#   met:
#
#      * Redistributions of source code must retain the above copyright
#        notice, this list of conditions and the following disclaimer.
#      * Redistributions in binary form must reproduce the above copyright
#        notice, this list of conditions and the following disclaimer in the
#        documentation and/or other materials provided with the distribution.
#      * Neither the name of David M. Syzdek nor the
#        names of its contributors may be used to endorse or promote products
#        derived from this software without specific prior written permission.
#
#   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
#   IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
#   THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
#   PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL DAVID M. SYZDEK BE LIABLE FOR
#   ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
#   DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
#   SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
#   CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
#   LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
#   OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
#   SUCH DAMAGE.
#
#   @SYZDEK_BSD_LICENSE_END@
#

DISTCLEANFILES		+= src/grub/grub-*.tar.xz \
			   src/grub/source/ \
			   src/grub/.iperd
CLEANFILES              += src/grub/grub-*.tar.xz.new


GRUB_VERSION		:= 2.14
GRUB_MIRROR		:= https://ftp.gnu.org/gnu/grub/grub-$(GRUB_VERSION).tar.xz
GRUB_SHA1		:= b8370fa991f63027764f41d58b90aa8a0871f1e9
GRUB_SHA256		:= bc8d3c73535b8838d8c8e2654d73edc4e6ae8c8acdb45d5df5dc9a1547446d43
GRUB_SHA512		:= 5008e3b70072798d2b34301219fe174cc6bcfead40a9ab25fe32f30c62a392ffb7bf2eb629d481f4a6c19c2925324af3f08d7043e62623e746be2d8b3cbd1182
GRUB_ROOT		:= $(IPERD_ROOT)/src/grub


GRUB_BUILDDIR		:= src/grub/source/build
GRUB_DEPENDENCIES 	:= src/grub/grub-$(GRUB_VERSION).tar.xz \
			   src/dejavu/.iperd \
			   src/unifont/.iperd
GRUB_PLATFORMS		:= tools/iperd/grub_i386_pc \
			   tools/iperd/grub_i386_efi \
			   tools/iperd/grub_x86_64_efi \
			   tools/iperd/grub
GRUB_CONFIGURE		:= ../configure\
			      --prefix="$(IPERD_ROOT)/tools" \
			      --enable-grub-mkfont \
			      --enable-grub-themes \
			      --enable-grub-mount \
			      --enable-device-mapper \
			      --enable-liblzma \
			      --enable-grub-protect \
			      --enable-boot-time \
			      --enable-cache-stats \
			      --with-dejavufont=$(DEJAVU_ROOT)/source/ttf/DejaVuSansMono.ttf \
			      --with-unifont=$(UNIFONT_ROOT)/unifont.bdf


GRUB_CONFIGS		= \
			  boot/grub/grub.cfg
GRUB_INCLUDES		= \
			  var/config/grub.inc
GRUB_BINARIES		= \
			  EFI/BOOT/efiboot.img
GRUB_MODULES		= \
			  efi_gop efi_uga \
			  all_video video video_bochs video_cirrus video_fb \
			  videoinfo \
			  serial terminfo terminal \
			  search search_fs_file search_fs_uuid search_label \
			  udf iso9660 ext2 fat exfat ntfs hfsplus lvm \
			  part_gpt part_msdos msdospart \
			  diskfilter \
			  parttool \
			  probe \
			  normal \
			  acpi ohci uhci ahci ehci \
			  cat ls chain configfile echo halt reboot \
			  ls lsefimmap lsefisystab lsmmap lspci lsacpi lssal \
			  linux


src/grub/grub-$(GRUB_VERSION).tar.xz:
	@rm -f $(@) $(@).new
	wget -q -O $(@).new "$(GRUB_MIRROR)"
	@echo "$(GRUB_SHA1) $(@).new"   |sha1sum   --check > /dev/null
	@echo "$(GRUB_SHA256) $(@).new" |sha256sum --check > /dev/null
	@echo "$(GRUB_SHA512) $(@).new" |sha512sum --check > /dev/null
	mv $(@).new $(@)
	@touch $(@)


src/grub/source/.iperd: $(GRUB_DEPENDENCIES)
	@rm -Rf src/grub/source
	@mkdir  src/grub/source
	tar -C  src/grub/source -xf src/grub/grub-$(GRUB_VERSION).tar.xz --strip-components=1
	( cd src/grub/source && patch -p1 < ../grub-title.patch )
	@touch $(@)


#
# make front-end tools
#
$(GRUB_BUILDDIR)/.iperd: src/grub/source/.iperd
	@rm -Rf $(GRUB_BUILDDIR)
	mkdir   $(GRUB_BUILDDIR)
	( cd    $(GRUB_BUILDDIR) && $(GRUB_CONFIGURE) --target=i386 --with-platform=pc )
	make -C $(GRUB_BUILDDIR) clean
	make -C $(GRUB_BUILDDIR) -j 4
	@touch $(@)
tools/iperd/grub: $(GRUB_BUILDDIR)/.iperd
	@rm -f $(@)
	@mkdir -p tools/iperd/
	make -C $(GRUB_BUILDDIR) install
	@touch $(@)


#
# build for i386-pc
#
$(GRUB_BUILDDIR)_i386_pc/.iperd: src/grub/source/.iperd
	@rm -Rf $(GRUB_BUILDDIR)_i386_pc
	mkdir   $(GRUB_BUILDDIR)_i386_pc
	( cd    $(GRUB_BUILDDIR)_i386_pc && $(GRUB_CONFIGURE) --target=i386 --with-platform=pc )
	make -C $(GRUB_BUILDDIR)_i386_pc clean
	make -C $(GRUB_BUILDDIR)_i386_pc -j 4
	@touch $(@)
tools/iperd/grub_i386_pc: $(GRUB_BUILDDIR)_i386_pc/.iperd
	@rm -f $(@)
	@mkdir -p tools/iperd/
	make -C $(GRUB_BUILDDIR)_i386_pc install
	@touch $(@)


#
# build for i386-efi
#
$(GRUB_BUILDDIR)_i386_efi/.iperd: src/grub/source/.iperd
	@rm -Rf $(GRUB_BUILDDIR)_i386_efi
	mkdir   $(GRUB_BUILDDIR)_i386_efi
	( cd    $(GRUB_BUILDDIR)_i386_efi && $(GRUB_CONFIGURE) --target=i386 --with-platform=efi )
	make -C $(GRUB_BUILDDIR)_i386_efi clean
	make -C $(GRUB_BUILDDIR)_i386_efi -j 4
	@touch $(@)
tools/iperd/grub_i386_efi: $(GRUB_BUILDDIR)_i386_efi/.iperd
	@rm -f $(@)
	@mkdir -p tools/iperd/
	make -C $(GRUB_BUILDDIR)_i386_efi install
	@touch $(@)


#
# build for x86_64-efi
#
$(GRUB_BUILDDIR)_x86_64_efi/.iperd: src/grub/source/.iperd
	@rm -Rf $(GRUB_BUILDDIR)_x86_64_efi
	mkdir   $(GRUB_BUILDDIR)_x86_64_efi
	( cd    $(GRUB_BUILDDIR)_x86_64_efi && $(GRUB_CONFIGURE) --target=x86_64 --with-platform=efi )
	make -C $(GRUB_BUILDDIR)_x86_64_efi clean
	make -C $(GRUB_BUILDDIR)_x86_64_efi -j 4
	@touch $(@)
tools/iperd/grub_x86_64_efi: $(GRUB_BUILDDIR)_x86_64_efi/.iperd
	@rm -f $(@)
	@mkdir -p tools/iperd/
	make -C $(GRUB_BUILDDIR)_x86_64_efi install
	@touch $(@)


#
# create TFTP boot directory
#
grub/.iperd: $(GRUB_PLATFORMS)
	@rm -Rf grub
	./tools/bin/grub-mknetdir \
	   --modules="all_video http net gzio echo serial syslinuxcfg terminal tftp" \
	   --core-compress=xz \
	   --net-directory=$(IPERD_ROOT) \
	   --subdir=/grub
	@touch $(@)


src/grub/.iperd: grub/.iperd
	@touch $(@)


var/config/grub.inc: Makefile.config $(SYSLINUX_INC_DEPS)
	bash ./src/scripts/genfiles.sh "$(@)"
	@touch "$(@)"


boot/grub/grub.cfg: Makefile var/config/grub.inc src/grub/grub-header.cfg
	@mkdir -p boot/grub
	@echo 'do_subst src/grub/grub-header.cfg var/config/grub.inc > $(@)';
	@$(do_subst) \
	   src/grub/grub-header.cfg \
	   var/config/grub.inc \
	   | sed -e "s,[@]SYSLINUX_FLAVOR[@],iso/UEFI,g" \
	   > "$(@)" \
	   || { rm -f "$(@)"; exit 1; }
	@touch "$(@)"


boot/grub/images/bootia32.efi: Makefile
	@mkdir -p boot/grub/images
	grub-mkimage \
	   -o "$(@)" \
	   -c src/grub/grub-stub.cfg \
	   -p /boot/grub \
	   -O i386-efi \
	   $(GRUB_MODULES)


boot/grub/images/bootx64.efi: Makefile
	@mkdir -p boot/grub/images
	grub-mkimage \
	   -o "$(@)" \
	   -c src/grub/grub-stub.cfg \
	   -p /boot/grub \
	   -O x86_64-efi \
	   $(GRUB_MODULES)


EFI/BOOT/efiboot.img: boot/grub/images/bootx64.efi
	@rm -f "$(@)"
	dd \
	   if=/dev/zero \
	   of="$(@)" \
	   bs=512 \
	   count=2880 \
	   || { rm -f "$(@)"; exit 1; }
	mkfs.msdos \
	   -F 12 \
	   -n 'EFIBOOT' \
	   "$(@)" \
	   || { rm -f $(@); exit 1; }
	mmd \
	   -i "$(@)" \
	   ::EFI \
	   || { rm -f $(@); exit 1; }
	mmd \
	   -i "$(@)" \
	   ::EFI/BOOT \
	   || { rm -f $(@); exit 1; }
	mcopy \
	   -i "$(@)" \
	   boot/grub/images/bootx64.efi \
	   ::EFI/BOOT/BOOTX64.EFI \
	   || { rm -f $(@); exit 1; }
	@touch "$(@)"


# end of makefile
