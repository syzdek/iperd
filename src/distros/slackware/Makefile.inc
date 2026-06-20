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


DISTRO_SLACKWARE_CFG		:=
DISTRO_SLACKWARE_BOOT		:=


DEFAULT_SLACKWARE		?= y
DEFAULT_SLACKWARE_URL		?= https://mirrors.edge.kernel.org/slackware
DEFAULT_SLACKWARE_GRUB		?= (http,mirrors.edge.kernel.org)/slackware
DEFAULT_SLACKWARE_APPEND	?=
DEFAULT_SLACKWARE_OPT		:= n
DEFAULT_SLACKWARE64_OPT		:= $(DEFAULT_SLACKWARE)
DEFAULT_SLACKWARE_VERSIONS	:= 14.0 \
				   14.1 \
				   14.2 \
				   15.0


DISTRO_SLACKWARE		?= $(DEFAULT_SLACKWARE)
DISTRO_SLACKWARE_URL		?= $(DEFAULT_SLACKWARE_URL)
DISTRO_SLACKWARE_GRUB		?= $(DEFAULT_SLACKWARE_GRUB)
DISTRO_SLACKWARE_APPEND		?= $(DEFAULT_SLACKWARE_APPEND)
DISTRO_SLACKWARE_LOCAL_URL	?= $(DISTRO_SLACKWARE_URL)
DISTRO_SLACKWARE_LOCAL_GRUB	?= $(DISTRO_SLACKWARE_GRUB)
DISTRO_SLACKWARE_LOCAL_APPEND	?= $(DISTRO_SLACKWARE_APPEND)


DISTRO_SLACKWARE_KEYWORDS	:= DISTRO_PUB_APPEND='$(DISTRO_SLACKWARE_APPEND)'; \
				   DISTRO_PUB_GRUB='$(DISTRO_SLACKWARE_GRUB)'; \
				   DISTRO_PUB_URL='$(DISTRO_SLACKWARE_URL)'; \
				   DISTRO_LOCAL_APPEND='$(DISTRO_SLACKWARE_LOCAL_APPEND)'; \
				   DISTRO_LOCAL_GRUB='$(DISTRO_SLACKWARE_LOCAL_GRUB)'; \
				   DISTRO_LOCAL_URL='$(DISTRO_SLACKWARE_LOCAL_URL)';


.PHONY: slackware-clean slackware-distclean slackware-download slackware-defconfig


build/distros/slackware/Makefile.versions.inc: .config src/distros/slackware/Makefile.version.inc.in
	@if test "x$(IPERD_DEFCONFIG)" != "x1"; then \
	   echo "  GEN      $(@)"; \
	fi
	@rm -f "$(@)"
	@mkdir -p "$(@D)"
	@for REL in $(DEFAULT_SLACKWARE_VERSIONS); do \
	   TAG="$$(echo "$${REL}" |sed -e 's/\.//g')"; \
	   sed \
	      -e "s/[@]DISTRO_VERSION[@]/$${REL}/g" \
	      -e "s/[@]DISTRO_TAG[@]/$${TAG}/g" \
	      src/distros/slackware/Makefile.version.inc.in; \
	done > "$(@)";
	@touch "$(@)"


GRUB_CFG_INCLUDES		+= build/distros/slackware/grub.inc
DISTRO_SLACKWARE_CFG		+= src/distros/slackware/grub-header.inc.in
-include build/distros/slackware/Makefile.versions.inc
DISTRO_SLACKWARE_CFG		+= src/distros/slackware/grub-footer.inc.in
IPERD_DOWNLOADS			+= $(DISTRO_SLACKWARE_BOOT)


build/distros/slackware/grub.inc: $(DISTRO_SLACKWARE_CFG)
	@$(do_subst_files_dt)


#
# Distro downloads
#
boot/slackware/%/initrd.img:
	@mkdir -p "$(@D)"
	@WGET_FILE="$(@)"; WGET_URL="$(DISTRO_SLACKWARE_URL)/$(*)/$(@F)"; $(do_wget);


boot/slackware/%/bzImage:
	@mkdir -p "$(@D)"
	@WGET_FILE="$(@)"; WGET_URL="$(DISTRO_SLACKWARE_URL)/$(*)/$(@F)"; $(do_wget);


slackware-download: $(DISTRO_SLACKWARE_BOOT)


slackware-clean:
	rm -Rf build/distros/slackware
	rm -Rf boot/slackware
        

slackware-distclean: slackware-clean


#
# IPERD config  targets
#
slackware-defconfig:
	@echo "#"
	@echo "# Slackware Linux"
	@echo "DISTRO_SLACKWARE=$(DEFAULT_SLACKWARE)"
	@echo "DISTRO_SLACKWARE_URL=$(DEFAULT_SLACKWARE_URL)"
	@echo "DISTRO_SLACKWARE_GRUB=$(DEFAULT_SLACKWARE_GRUB)"
	@echo "DISTRO_SLACKWARE_APPEND=$(DEFAULT_SLACKWARE_APPEND)"
	@echo "DISTRO_SLACKWARE_LOCAL_URL=$(DEFAULT_SLACKWARE_URL)"
	@echo "DISTRO_SLACKWARE_LOCAL_GRUB=$(DEFAULT_SLACKWARE_GRUB)"
	@echo "DISTRO_SLACKWARE_LOCAL_APPEND=$(DEFAULT_SLACKWARE_APPEND)"
	@for REL in $(DEFAULT_SLACKWARE_VERSIONS); do \
	   TAG="$$(echo "$${REL}" |sed -e 's/\.//g')"; \
	   echo "DISTRO_SLACKWARE_$${TAG}=$(DEFAULT_SLACKWARE_OPT)"; \
	   echo "DISTRO_SLACKWARE64_$${TAG}=$(DEFAULT_SLACKWARE64_OPT)"; \
	done;


# end of Makefile.inc
