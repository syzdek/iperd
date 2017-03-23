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

MIRROR_FREEDOS		?= http://www.freedos.org/download/download/
SYSLINUX_SRC		?= /usr/share/syslinux


DISTRODIR		= src/distros
CONFIGDIR		= src/config
SCRIPTDIR		= src/scripts
SYSLINDIR		= src/syslinux


IPERD_VERSION		= $(shell git describe --long --abbrev=7 HEAD |sed -e 's/\-/./g' -e 's/^v//g')
DATE			= $(shell date +%Y-%m-%d)


PREREQ_CNF		= \
			  isolinux/isolinux.cfg \
			  pxelinux.cfg/default \
			  syslinux/syslinux.cfg
PREREQ_BIN		= \
			  isolinux/isolinux.bin \
			  syslinux/syslinux.com


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
-include Makefile.config


images/iperdboot.img: $(PREREQ_CNF) $(DOWNLOAD_FILES) $(SCRIPTDIR)/diskimage.sh $(SCRIPTDIR)/thumbdrive.sh
	@mkdir -p $$(dirname "$(@)")
	@rm -f "$(@)"
	bash ./$(SCRIPTDIR)/diskimage.sh "." "$(@)"
	@touch "$(@)"


isolinux/isolinux.bin.mod: $(PREREQ_CNF)
	cp isolinux/isolinux.bin "$(@)"
	@touch "$(@)"

images/iperdboot.iso: $(DOWNLOAD_FILES) isolinux/isolinux.bin.mod
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
	   -b isolinux/isolinux.bin.mod \
	   -c isolinux/isolinux.boot \
	   -V "IPEngRescueDisk" \
	   -A "IP Engineering Rescue Disk"  \
	   ./
	@touch "$(@)"


images: images/iperdboot.img images/iperdboot.iso


isolinux/isolinux.bin: syslinux/syslinux.com
	rsync -ra syslinux/ isolinux
	@touch "$(@)"


syslinux/syslinux.com:
	rsync -ra "$(SYSLINUX_SRC)/" syslinux
	cp $(SYSLINDIR)/f1.txt syslinux/
	cp $(SYSLINDIR)/f2.txt syslinux/
	cp syslinux/pxelinux.0 pxelinux.0
	cp /usr/share/hwdata/pci.ids syslinux/
	@touch "$(@)"


isolinux/isolinux.cfg: Makefile.config $(ISOLINUX_CFG) $(PREREQ_BIN) $(SYSLINDIR)/common.cfg
	@rm -f "$(@)"
	@mkdir -p isolinux
	@echo 'do_subst $$(SYSLINDIR)/common.cfg $$(ISOLINUX_CFG) > $(@)'
	@$(do_subst) $(SYSLINDIR)/common.cfg $(ISOLINUX_CFG) > "$(@)"
	@touch "$(@)"


pxelinux.cfg/default: Makefile.config $(PXELINUX_CFG) $(PREREQ_BIN) $(SYSLINDIR)/common.cfg
	@rm -f "$(@)"
	@mkdir -p pxelinux.cfg
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


download: $(PREREQ_CNF) $(DOWNLOAD_FILES)


configure:
	bash ./$(SCRIPTDIR)/configure.sh configure

deps:
	bash ./$(SCRIPTDIR)/configure.sh deps


clean:
	rm -Rf syslinux isolinux pxelinux.0 pxelinux.cfg
	rm -Rf images
	rm -Rf tmp


distclean: clean
	rm -Rf boot
	rm -f  Makefile.config
	rm -Rf src/config


# end of makefile
