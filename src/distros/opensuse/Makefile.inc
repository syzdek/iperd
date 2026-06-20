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


DISTRO_OPENSUSE_CFG		:=
DISTRO_OPENSUSE_BOOT		:=


DEFAULT_OPENSUSE		:= y
DEFAULT_OPENSUSE_URL		:= https://mirrors.edge.kernel.org/opensuse
DEFAULT_OPENSUSE_GRUB		:= (http,mirrors.edge.kernel.org)/opensuse
#DEFAULT_OPENSUSE_URL		:= https://download.opensuse.org
#DEFAULT_OPENSUSE_GRUB		:= (http,download.opensuse.org)
DEFAULT_OPENSUSE_APPEND		:=
DEFAULT_OPENSUSE_OPT		:= $(DEFAULT_OPENSUSE)
DEFAULT_OPENSUSE_VERSIONS	:= 15.6 \
				   16.0 \
				   16.1


DISTRO_OPENSUSE			?= $(DEFAULT_OPENSUSE)
DISTRO_OPENSUSE_URL		?= $(DEFAULT_OPENSUSE_URL)
DISTRO_OPENSUSE_GRUB		?= $(DEFAULT_OPENSUSE_GRUB)
DISTRO_OPENSUSE_APPEND		?= $(DEFAULT_OPENSUSE_APPEND)
DISTRO_OPENSUSE_EXTRA_URL	?=
DISTRO_OPENSUSE_EXTRA_GRUB	?=
DISTRO_OPENSUSE_EXTRA_APPEND	?=
DISTRO_OPENSUSE_LOCAL_URL	?= $(DISTRO_OPENSUSE_URL)
DISTRO_OPENSUSE_LOCAL_GRUB	?= $(DISTRO_OPENSUSE_GRUB)
DISTRO_OPENSUSE_LOCAL_APPEND	?= $(DISTRO_OPENSUSE_APPEND)


DISTRO_OPENSUSE_KEYWORDS	:= DISTRO_APPEND='$(DISTRO_OPENSUSE_APPEND)'; \
				   DISTRO_PUB_GRUB='$(DISTRO_OPENSUSE_GRUB)'; \
				   DISTRO_PUB_URL='$(DISTRO_OPENSUSE_URL)'; \
				   DISTRO_EXTRA_APPEND='$(DISTRO_OPENSUSE_EXTRA_APPEND)'; \
				   DISTRO_EXTRA_URL='$(DISTRO_OPENSUSE_EXTRA_URL)'; \
				   DISTRO_LOCAL_APPEND='$(DISTRO_OPENSUSE_LOCAL_APPEND)'; \
				   DISTRO_LOCAL_GRUB='$(DISTRO_OPENSUSE_LOCAL_GRUB)'; \
				   DISTRO_LOCAL_URL='$(DISTRO_OPENSUSE_LOCAL_URL)';


.PHONY: opensuse-clean opensuse-distclean opensuse-download opensuse-defconfig


build/distros/opensuse/Makefile.versions.inc: .config src/distros/opensuse/Makefile.version.inc.in
	@if test "x$(IPERD_DEFCONFIG)" != "x1"; then \
	   echo "  GEN      $(@)"; \
	fi
	@rm -f "$(@)"
	@mkdir -p "$(@D)"
	@for REL in $(DEFAULT_OPENSUSE_VERSIONS); do \
	   TAG="$$(echo "$${REL}" |sed -e 's/\.//g')"; \
	   sed \
	      -e "s/[@]DISTRO_VERSION[@]/$${REL}/g" \
	      -e "s/[@]DISTRO_TAG[@]/$${TAG}/g" \
	      src/distros/opensuse/Makefile.version.inc.in; \
	done >> "$(@)";
	@touch "$(@)"


GRUB_CFG_INCLUDES		+= build/distros/opensuse/grub.inc
DISTRO_OPENSUSE_CFG		+= src/distros/opensuse/grub-header.inc.in
-include build/distros/opensuse/Makefile.versions.inc
DISTRO_OPENSUSE_CFG		+= src/distros/opensuse/grub-footer.inc.in
IPERD_DOWNLOADS			+= $(DISTRO_OPENSUSE_BOOT)


build/distros/opensuse/grub.inc: $(DISTRO_OPENSUSE_CFG)
	@$(do_subst_files_dt)


#
# Distro downloads
#
boot/opensuse/%/initrd:
	@mkdir -p "$(@D)"
	@WGET_FILE="$(@)"; WGET_URL="$(DISTRO_OPENSUSE_URL)/$(*)/$(@F)"; $(do_wget);


boot/opensuse/%/linux:
	@mkdir -p "$(@D)"
	@WGET_FILE="$(@)"; WGET_URL="$(DISTRO_OPENSUSE_URL)/$(*)/$(@F)"; $(do_wget);


opensuse-download: $(DISTRO_OPENSUSE_BOOT)


opensuse-clean:
	rm -Rf build/distros/opensuse
	rm -Rf boot/opensuse
        

opensuse-distclean: opensuse-clean


#
# IPERD config  targets
#
opensuse-defconfig:
	@echo '#'
	@echo '# openSUSE'
	@echo 'DISTRO_OPENSUSE=$(DEFAULT_OPENSUSE)'
	@echo 'DISTRO_OPENSUSE_URL=$(DEFAULT_OPENSUSE_URL)'
	@echo 'DISTRO_OPENSUSE_GRUB=$(DEFAULT_OPENSUSE_GRUB)'
	@echo 'DISTRO_OPENSUSE_APPEND=$(DEFAULT_OPENSUSE_APPEND)'
	@echo 'DISTRO_OPENSUSE_EXTRA_URL='
	@echo 'DISTRO_OPENSUSE_EXTRA_APPEND='
	@echo 'DISTRO_OPENSUSE_LOCAL_URL=$(DEFAULT_OPENSUSE_URL)'
	@echo 'DISTRO_OPENSUSE_LOCAL_GRUB=$(DEFAULT_OPENSUSE_GRUB)'
	@echo 'DISTRO_OPENSUSE_LOCAL_APPEND=$(DEFAULT_OPENSUSE_APPEND)'
	@for REL in $(DEFAULT_OPENSUSE_VERSIONS); do \
	   REL="$$(echo "$${REL}" |sed -e 's/\.//g')"; \
	   echo "DISTRO_OPENSUSE_$${REL}=$(DEFAULT_OPENSUSE_OPT)"; \
	done;
	echo "DISTRO_OPENSUSE_SLOWROLL=$(DEFAULT_OPENSUSE_OPT)"; \
	echo "DISTRO_OPENSUSE_TUMBLEWEED=$(DEFAULT_OPENSUSE_OPT)"; \


# end of Makefile.inc
