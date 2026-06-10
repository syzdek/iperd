#
#   IP Engineering Rescue Disk
#   Copyright (C) 2026 David M. Syzdek <david@syzdek.net>.
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

DISTCLEANFILES			+=
CLEANFILES			+=


IPERD_PRUNE			+= grub-prune


GRUB_VERSION			:= 2.14
GRUB_MIRROR			:= https://ftp.gnu.org/gnu/grub/grub-$(GRUB_VERSION).tar.xz
GRUB_SHA1			:= b8370fa991f63027764f41d58b90aa8a0871f1e9
GRUB_SHA256			:= bc8d3c73535b8838d8c8e2654d73edc4e6ae8c8acdb45d5df5dc9a1547446d43
GRUB_SHA512			:= 5008e3b70072798d2b34301219fe174cc6bcfead40a9ab25fe32f30c62a392ffb7bf2eb629d481f4a6c19c2925324af3f08d7043e62623e746be2d8b3cbd1182
GRUB_ROOT			:= $(IPERD_ROOT)/src/grub


GRUB_BUILDDIR			:= var/grub/source/build
GRUB_DEPENDENCIES 		:= var/grub/grub-$(GRUB_VERSION).tar.xz \
				   src/dejavu/.iperd \
				   src/unifont/.iperd
GRUB_PLATFORMS			:= tools/iperd/grub_i386_pc \
				   tools/iperd/grub_i386_efi \
				   tools/iperd/grub_x86_64_efi
GRUB_CONFIGURE			:= ../configure\
				      --prefix="$(IPERD_ROOT)/tools" \
				      --enable-grub-mkfont \
				      --enable-grub-themes \
				      --enable-grub-mount \
				      --enable-device-mapper \
				      --enable-mm-debug \
				      --enable-liblzma \
				      --enable-grub-protect \
				      --enable-boot-time \
				      --enable-cache-stats \
				      --with-dejavufont=$(DEJAVU_ROOT)/source/ttf/DejaVuSansMono.ttf \
				      --with-unifont=$(UNIFONT_ROOT)/unifont.bdf


#
# unpack source
#
var/grub/grub-$(GRUB_VERSION).tar.xz:
	@mkdir -p "$(@D)"
	@WGET_FILE="$(@)"; \
		WGET_URL="$(GRUB_MIRROR)"; \
		WGET_SHA1="$(GRUB_SHA1)"; \
		WGET_SHA256="$(GRUB_SHA256)"; \
		WGET_SHA512="$(GRUB_SHA512)"; \
		$(do_wget);


var/grub/source/.iperd: $(GRUB_DEPENDENCIES)
	@TAR_FILE="var/grub/grub-$(GRUB_VERSION).tar.xz"; \
		TAR_DIR="$(@D)"; \
		$(do_tar);
	@touch $(@)
	@PATCH_FILE="$(IPERD_ROOT)/src/grub/grub-title.patch"; \
		PATCH_DIR="$(@D)"; \
		$(do_patch);
	@CHMOD_DIR="$(@D)"; $(do_chmod);
	@touch $(@)


#
# build for i386-pc
#
$(GRUB_BUILDDIR)_i386_pc/.iperd: var/grub/source/.iperd
	@rm -Rf $(GRUB_BUILDDIR)_i386_pc
	@mkdir   $(GRUB_BUILDDIR)_i386_pc
	( cd    $(GRUB_BUILDDIR)_i386_pc && $(GRUB_CONFIGURE) --target=i386 --with-platform=pc )
	$(MAKE) -C $(GRUB_BUILDDIR)_i386_pc -j $(IPERD_NUMJOBS) V=$(V)
	@touch $(@)


tools/iperd/grub_i386_pc: $(GRUB_BUILDDIR)_i386_pc/.iperd
	@rm -f $(@)
	@mkdir -p tools/iperd/
	$(MAKE) -C $(GRUB_BUILDDIR)_i386_pc V=$(V) install
	@touch $(@)


#
# build for i386-efi
#
$(GRUB_BUILDDIR)_i386_efi/.iperd: var/grub/source/.iperd
	@rm -Rf $(GRUB_BUILDDIR)_i386_efi
	@mkdir   $(GRUB_BUILDDIR)_i386_efi
	( cd    $(GRUB_BUILDDIR)_i386_efi && $(GRUB_CONFIGURE) --target=i386 --with-platform=efi )
	$(MAKE) -C $(GRUB_BUILDDIR)_i386_efi -j $(IPERD_NUMJOBS) V=$(V)
	@touch $(@)


tools/iperd/grub_i386_efi: $(GRUB_BUILDDIR)_i386_efi/.iperd
	@rm -f $(@)
	@mkdir -p tools/iperd/
	$(MAKE) -C $(GRUB_BUILDDIR)_i386_efi V=$(V) install
	@touch $(@)


#
# build for x86_64-efi
#
$(GRUB_BUILDDIR)_x86_64_efi/.iperd: var/grub/source/.iperd
	@rm -Rf $(GRUB_BUILDDIR)_x86_64_efi
	@mkdir   $(GRUB_BUILDDIR)_x86_64_efi
	( cd    $(GRUB_BUILDDIR)_x86_64_efi && $(GRUB_CONFIGURE) --target=x86_64 --with-platform=efi )
	$(MAKE) -C $(GRUB_BUILDDIR)_x86_64_efi -j $(IPERD_NUMJOBS) V=$(V)
	@touch $(@)


tools/iperd/grub_x86_64_efi: $(GRUB_BUILDDIR)_x86_64_efi/.iperd
	@rm -f $(@)
	@mkdir -p tools/iperd/
	$(MAKE) -C $(GRUB_BUILDDIR)_x86_64_efi V=$(V) install
	@touch $(@)


#
# default grub target
#
var/grub/.iperd: $(GRUB_PLATFORMS)
	@touch $(@)


grub-prune:
	test -f var/grub/source/build_i386_efi/Makefile \
		&& $(MAKE) -C var/grub/source/build_i386_efi clean
	test -f var/grub/source/build_i386_pc/Makefile \
		&& $(MAKE) -C var/grub/source/build_i386_pc clean
	test -f var/grub/source/build_x86_64_efi/Makefile \
		&& $(MAKE) -C var/grub/source/build_x86_64_efi clean

# end of makefile
