#
#   IP Engineering Rescue Disk
#   Copyright (C) 2017 David M. Syzdek <david@syzdek.net>.
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


DISTRODIR		= src/distros
CONFIGDIR		= var/config
SCRIPTDIR		= src/scripts
SYSLINDIR		= src/syslinux


IPERD_VERSION		= $(shell git describe --long --abbrev=7 HEAD |sed -e 's/\-/./g' -e 's/^v//g')
DATE			= $(shell date +%Y-%m-%d)


ALL_FILES		= \
			  $(SYSLINUX_CONFIGS) \
			  $(SYSLINUX_BINARIES) \
			  $(DOWNLOAD_FILES)
CLEANFILES		= \
			  $(SYSLINUX_CONFIGS) \
			  $(SYSLINUX_BINARIES) \
			  $(SYSLINUX_INCLUDES) \
			  Makefile.config \
			  boot \
			  EFI \
			  images \
			  syslinux


do_subst = sed \
	-e "s,[@]DISTRO[@],$${DISTRO},g" \
	-e "s,[@]CODENAME[@],$${DISTRO_CODENAME},g" \
	-e "s,[@]VERSION[@],$${DISTRO_VERSION},g" \
	-e "s,[@]LABEL[@],$${DISTRO_LABEL},g" \
	-e "s,[@]ARCH[@],$${DISTRO_ARCH},g" \
        -e 's,[@]IPERD_VERSION[@],$(IPERD_VERSION),g' \
        -e 's,[@]DATE[@],$(DATE),g' \
        -e 's,[@]NETBOOT[@],$(NETBOOT),g' \
        -e 's,[@]NETBOOT_HOST[@],$(NETBOOT_HOST),g' \
        -e 's,[@]NETBOOT_PATH[@],$(NETBOOT_PATH),g' \
        -e 's,[@]NETBOOT_HTTP[@],$(NETBOOT_HTTP),g' \
        -e 's,[@]NETBOOT_HTTP_SCHEME[@],$(NETBOOT_HTTP_SCHEME),g' \
        -e 's,[@]NETBOOT_HTTP_HOST[@],$(NETBOOT_HTTP_HOST),g' \
        -e 's,[@]NETBOOT_HTTP_PATH[@],$(NETBOOT_HTTP_PATH),g' \
        -e 's,[@]NETBOOT_NFS[@],$(NETBOOT_NFS),g' \
        -e 's,[@]NETBOOT_NFS_HOST[@],$(NETBOOT_NFS_HOST),g' \
        -e 's,[@]NETBOOT_NFS_PATH[@],$(NETBOOT_NFS_PATH),g' \
        -e 's,[@]NETBOOT_TFTP[@],$(NETBOOT_TFTP),g' \
        -e 's,[@]NETBOOT_TFTP_HOST[@],$(NETBOOT_TFTP_HOST),g' \
        -e 's,[@]NETBOOT_TFTP_PATH[@],$(NETBOOT_TFTP_PATH),g' \
	$(SUBST_EXPRESSIONS)
do_subst_fn = \
	echo "do_subst > $(@)"; \
	rm -f "$(@)"; \
	mkdir -p $$(dirname "$(@)") || exit 1; \
	${do_subst} < $${SRCFILE} > $(@) || exit 1; \
	chmod 0755 $(@); \
	touch $(@);
do_subst_dt = \
	echo "do_subst > $(@)"; \
	rm -f "$(@)"; \
	mkdir -p $$(dirname "$(@)") || exit 1; \
	${do_subst} < $${SRCFILE} > $(@) || exit 1; \
	chmod 0644 $(@); \
	touch $(@);


.PHONY: all clean configs configure distclean syslinux images deps


all:
	@echo " "
	@echo "Prepare directory:"
	@echo "   make configure"
	@echo "   make syslinux"
	@echo "   make download"
	@echo " "
	@echo "Build:"
	@echo "   make images"
	@echo "   make images/iperdboot.iso"
	@echo "   make images/iperdboot.gpt.img DISKSIZE=1900"
	@echo "   make images/iperdboot.hybrid.img DISKSIZE=1900"
	@echo "   make images/iperdboot.mbr.img DISKSIZE=1900"
	@echo "   make thumbdrive DISK=/dev/sdb PARTTYPE=hybrid PARTSIZE=1900M"
	@echo " "


Makefile.local:
	@touch "$(@)"


var/config/iperd.conf: $(SCRIPTDIR)/configure.sh $(SCRIPTDIR)/iperd.profile
	@mkdir -p var/config
	bash ./$(SCRIPTDIR)/configure.sh
	@touch "$(@)"


Makefile.config: var/config/iperd.conf $(SCRIPTDIR)/genfiles.sh
	bash ./$(SCRIPTDIR)/genfiles.sh Makefile.config
	@touch "$(@)"


-include Makefile.local
NETBOOT_HOST            ?= 10.0.109.254
NETBOOT_PATH            ?= /pub/iperd/iperd-current/
NETBOOT_HTTP_SCHEME     ?= http
NETBOOT_HTTP_HOST       ?= $(NETBOOT_HOST)
NETBOOT_HTTP_PATH       ?= $(NETBOOT_PATH)
NETBOOT_HTTP            ?= $(NETBOOT_HTTP_SCHEME)://$(NETBOOT_HTTP_HOST)$(NETBOOT_HTTP_PATH)
NETBOOT_NBD_HOST        ?= $(NETBOOT_HOST)
NETBOOT_NBD_PATH        ?= $(NETBOOT_PATH)
NETBOOT_NBD             ?= nbd://$(NETBOOT_NBD_HOST)$(NETBOOT_NBD_PATH)
NETBOOT_NFS_HOST        ?= $(NETBOOT_HOST)
NETBOOT_NFS_PATH        ?= $(NETBOOT_PATH)
NETBOOT_NFS             ?= nfs://$(NETBOOT_NFS_HOST)$(NETBOOT_NFS_HOST)
NETBOOT_TFTP_HOST       ?= $(NETBOOT_HOST)
NETBOOT_TFTP_PATH       ?= /
NETBOOT_TFTP            ?= tftp://$(NETBOOT_TFTP_HOST)$(NETBOOT_TFTP_PATH)
NETBOOT                 ?= $(NETBOOT_HTTP)
-include Makefile.config
include src/syslinux/Makefile.syslinux


images/iperdboot.gpt.img: $(ALL_FILES) $(SCRIPTDIR)/diskimage.sh $(SCRIPTDIR)/thumbdrive.sh
	@mkdir -p "$$(dirname "$(@)")"
	@rm -f "$(@)"
	bash ./$(SCRIPTDIR)/diskimage.sh -t gpt -s "$(DISKSIZE)" "." "$(@)"
	@touch "$(@)"


images/iperdboot.hybrid.img: $(ALL_FILES) $(SCRIPTDIR)/diskimage.sh $(SCRIPTDIR)/thumbdrive.sh
	@mkdir -p "$$(dirname "$(@)")"
	@rm -f "$(@)"
	bash ./$(SCRIPTDIR)/diskimage.sh -t hybrid -s "$(DISKSIZE)" "." "$(@)"
	@touch "$(@)"


images/iperdboot.mbr.img: $(ALL_FILES) $(SCRIPTDIR)/diskimage.sh $(SCRIPTDIR)/thumbdrive.sh
	@mkdir -p "$$(dirname "$(@)")"
	@rm -f "$(@)"
	bash ./$(SCRIPTDIR)/diskimage.sh -t mbr -s "$(DISKSIZE)" "." "$(@)"
	@touch "$(@)"


images/iperdboot.iso: $(ALL_FILES)
	@mkdir -p $$(dirname "$(@)")
	@rm -f "$(@)"
	mkisofs \
	   -o "$(@)" \
	   -R -J -v -d -N \
	   -x '.git' \
	   -m 'images' \
	   -m 'tmp' \
	   -hide-rr-moved \
	   -no-emul-boot \
	   -boot-load-size 4 \
	   -boot-info-table \
	   -b syslinux/isolinux.bin.mod \
	   -c syslinux/isolinux.boot \
	   -V "IPEngRescueDisk" \
	   -A "IP Engineering Rescue Disk"  \
	   ./
	@touch "$(@)"


thumbdrive: $(ALL_FILES)
	bash src/scripts/thumbdrive.sh -t "$(DISKTYPE)" -s "$(PARTSIZE)" . "$(DISK)"


images: images/iperdboot.$(DISKTYPE).img images/iperdboot.iso


syslinux: $(SYSLINUX_CONFIGS) $(SYSLINUX_BINARIES)


download: syslinux $(DOWNLOAD_FILES)


configure:
	@mkdir -p var/config
	bash ./$(SCRIPTDIR)/configure.sh


deps: $(SYSLINUX_CONFIGS) Makefile.config


clean:
	rm -Rf $(CLEANFILES)


distclean: clean
	rm -Rf boot
	rm -Rf src/config
	rm -Rf tmp


# end of makefile
