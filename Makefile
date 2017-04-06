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
CONFIGDIR		= src/config
SCRIPTDIR		= src/scripts
SYSLINDIR		= src/syslinux


SYSLINUX_VERSION	?= 6.03
MIRROR_SYSLINUX		?= https://www.kernel.org/pub/linux/utils/boot/syslinux/6.xx/syslinux-$(SYSLINUX_VERSION).tar.xz


IPERD_VERSION		= $(shell git describe --long --abbrev=7 HEAD |sed -e 's/\-/./g' -e 's/^v//g')
DATE			= $(shell date +%Y-%m-%d)


PREREQ_CNF		= \
			  syslinux/isolinux.cfg \
			  syslinux/pxelinux.cfg \
			  syslinux/syslinux.cfg
PREREQ_BIN		= \
			  syslinux/iperd.dep
CLEANFILES		= \
			  images \
			  syslinux


download_file = \
	rm -f "$(@)"; \
	mkdir -p "$$(dirname "$(@)")"; \
	wget \
	   -O "$(@)" \
	   "$${URL}" \
	   || { rm -f "$(@)"; exit 1; }; \
	touch "$(@)";
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
	@echo "   make images/iperdboot.img"
	@echo "   make thumbdrive DISK=/dev/sdb"
	@echo " "


Makefile.local:
	@touch "$(@)"

Makefile.config: $(SCRIPTDIR)/configure.sh
	bash ./$(SCRIPTDIR)/configure.sh configure
	@touch "$(@)"


-include Makefile.local
SYSLINUX_SRC		?= /usr/share/syslinux
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


images/iperdboot.img: $(PREREQ_CNF) $(DOWNLOAD_FILES) $(SCRIPTDIR)/diskimage.sh $(SCRIPTDIR)/thumbdrive.sh
	@mkdir -p $$(dirname "$(@)")
	@rm -f "$(@)"
	bash ./$(SCRIPTDIR)/diskimage.sh "." "$(@)"
	@touch "$(@)"


images/iperdboot.img.gz: images/iperdboot.img
	gzip --keep images/iperdboot.img


syslinux/isolinux.bin.mod: $(PREREQ_CNF)
	cp syslinux/isolinux.bin "$(@)"
	@touch "$(@)"


images/iperdboot.iso: $(DOWNLOAD_FILES) syslinux/isolinux.bin.mod
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


thumbdrive: $(PREREQ_CNF) $(DOWNLOAD_FILES)
	bash src/scripts/thumbdrive.sh . $(DISK)


images: images/iperdboot.img images/iperdboot.iso


compress: images/iperdboot.img.gz


tmp/syslinux-$(SYSLINUX_VERSION).tar.xz:
	@rm -Rf tmp/syslinux-$(SYSLINUX_VERSION)
	URL="$(MIRROR_SYSLINUX)"; \
	   $(download_file)


tmp/syslinux-$(SYSLINUX_VERSION)/iperd.dep: tmp/syslinux-$(SYSLINUX_VERSION).tar.xz
	@rm -Rf "tmp/syslinux-$(SYSLINUX_VERSION)"
	tar -C tmp -xf tmp/syslinux-$(SYSLINUX_VERSION).tar.xz
	@touch "$(@)"


syslinux/iperd.dep: tmp/syslinux-$(SYSLINUX_VERSION)/iperd.dep
	rm -Rf syslinux
	cd tmp/syslinux-$(SYSLINUX_VERSION); \
	   make -s install INSTALLROOT="$(PWD)/tmp/syslinux" \
	   || { rm -Rf tmp/syslinux-$(SYSLINUX_VERSION); exit 1; }
	rsync -ra "$(PWD)/tmp/syslinux/usr/share/syslinux/" syslinux
	rsync -ra "$(PWD)/tmp/syslinux/usr/bin/"            syslinux/bin
	rsync -ra "$(PWD)/tmp/syslinux/sbin/"               syslinux/sbin
	cp syslinux/efi32/syslinux.efi                      syslinux/efi32/syslinux.efi.0
	cp syslinux/efi32/ldlinux.e32                       syslinux/
	cp syslinux/efi64/ldlinux.e64                       syslinux/
	cp syslinux/efi64/syslinux.efi                      syslinux/efi64/syslinux.efi.0
	cp $(SYSLINDIR)/f1.txt                              syslinux/
	cp $(SYSLINDIR)/f2.txt                              syslinux/
	cp $(SYSLINDIR)/lpxelinux.cfg                       syslinux/efi32/
	cp $(SYSLINDIR)/efi32/pxelinux.cfg                  syslinux/efi32/
	cp $(SYSLINDIR)/efi64/pxelinux.cfg                  syslinux/efi32/
	cp /usr/share/hwdata/pci.ids                        syslinux/
	cp /lib/modules/$$(uname -r)/modules.alias          syslinux/modules.als
	@touch "$(@)"


syslinux/isolinux.cfg: Makefile.config $(ISOLINUX_CFG) $(PREREQ_BIN) $(SYSLINDIR)/common.cfg
	@rm -f "$(@)"
	@mkdir -p "$$(dirname "$(@)")"
	@echo 'do_subst $$(SYSLINDIR)/common.cfg $$(ISOLINUX_CFG) > $(@)'
	@$(do_subst) $(SYSLINDIR)/common.cfg $(ISOLINUX_CFG) > "$(@)"
	@touch "$(@)"


syslinux/pxelinux.cfg: Makefile.config $(PXELINUX_CFG) $(PREREQ_BIN) $(SYSLINDIR)/common.cfg
	@rm -f "$(@)"
	@mkdir -p "$$(dirname "$(@)")"
	@echo 'do_subst $$(SYSLINDIR)/common.cfg $$(PXELINUX_CFG) > $(@)'
	@$(do_subst) $(SYSLINDIR)/common.cfg $(PXELINUX_CFG) > "$(@)"
	@touch "$(@)"


syslinux/syslinux.cfg: Makefile.config $(SYSLINUX_CFG) $(PREREQ_BIN) $(SYSLINDIR)/common.cfg
	@rm -f "$(@)"
	@mkdir -p syslinux
	@echo 'do_subst $$(SYSLINDIR)/common.cfg $$(SYSLINUX_CFG) > $(@)'
	@$(do_subst) $(SYSLINDIR)/common.cfg $(SYSLINUX_CFG) > "$(@)"
	@touch "$(@)"


syslinux: $(PREREQ_CNF)


prune:
	find "./tmp" \
	   -type d \
	   -path "./tmp/*" \
	   -maxdepth 1 \
	   -mindepth 1 \
	   -exec echo rm -Rf {} \; \
	   -exec rm -Rf {} \;


download: $(PREREQ_CNF) $(DOWNLOAD_FILES)


configure:
	bash ./$(SCRIPTDIR)/configure.sh configure


deps:
	bash ./$(SCRIPTDIR)/configure.sh deps


clean:
	rm -Rf $(CLEANFILES)


distclean: clean
	rm -Rf boot
	rm -f  Makefile.config
	rm -Rf src/config
	rm -Rf tmp


# end of makefile
