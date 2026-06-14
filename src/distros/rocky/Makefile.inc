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


DISTRO_ROCKY_CFG		:=
DISTRO_ROCKY_BOOT		:=


DEFAULT_ROCKY			:= y
DEFAULT_ROCKY_URL		:= https://dl.rockylinux.org/pub/rocky
DEFAULT_ROCKY_GRUB		:= (http,dl.rockylinux.org)/pub/rocky
DEFAULT_ROCKY_APPEND		:=
DEFAULT_ROCKY_OPT		:= $(DEFAULT_ROCKY)
DEFAULT_ROCKY_VERSIONS		:= 8 \
				   9 \
				   10


DISTRO_ROCKY			?= $(DEFAULT_ROCKY)
DISTRO_ROCKY_URL		?= $(DEFAULT_ROCKY_URL)
DISTRO_ROCKY_GRUB		?= $(DEFAULT_ROCKY_GRUB)
DISTRO_ROCKY_APPEND		?= $(DEFAULT_ROCKY_APPEND)
DISTRO_ROCKY_EXTRA_URL		?=
DISTRO_ROCKY_EXTRA_GRUB		?=
DISTRO_ROCKY_EXTRA_APPEND	?=
DISTRO_ROCKY_LOCAL_URL		?= $(DISTRO_ROCKY_URL)
DISTRO_ROCKY_LOCAL_GRUB		?= $(DISTRO_ROCKY_GRUB)
DISTRO_ROCKY_LOCAL_APPEND	?= $(DISTRO_ROCKY_APPEND)


DISTRO_ROCKY_KEYWORDS		:= DISTRO_APPEND='$(DISTRO_ROCKY_APPEND)'; \
				   DISTRO_GRUB='$(DISTRO_ROCKY_GRUB)'; \
				   DISTRO_URL='$(DISTRO_ROCKY_URL)'; \
				   DISTRO_EXTRA_APPEND='$(DISTRO_ROCKY_EXTRA_APPEND)'; \
				   DISTRO_EXTRA_URL='$(DISTRO_ROCKY_EXTRA_URL)'; \
				   DISTRO_LOCAL_APPEND='$(DISTRO_ROCKY_LOCAL_APPEND)'; \
				   DISTRO_LOCAL_GRUB='$(DISTRO_ROCKY_LOCAL_GRUB)'; \
				   DISTRO_LOCAL_URL='$(DISTRO_ROCKY_LOCAL_URL)';


.PHONY: rocky-clean rocky-distclean rocky-download rocky-defconfig


build/distros/rocky/Makefile.versions.inc: .config src/distros/rocky/Makefile.version.inc.in
	@if test "x$(IPERD_DEFCONFIG)" != "x1"; then \
	   echo "  GEN      $(@)"; \
	fi
	@rm -f "$(@)"
	@mkdir -p "$(@D)"
	@for REL in $(DEFAULT_ROCKY_VERSIONS); do \
	   sed \
	      -e "s/[@]DISTRO_VERSION[@]/$${REL}/g" \
	      src/distros/rocky/Makefile.version.inc.in; \
	done > "$(@)";
	@touch "$(@)"


GRUB_CFG_INCLUDES		+= build/distros/rocky/grub.inc
DISTRO_ROCKY_CFG		+= src/distros/rocky/grub-header.inc.in
-include build/distros/rocky/Makefile.versions.inc
DISTRO_ROCKY_CFG		+= src/distros/rocky/grub-footer.inc.in
IPERD_DOWNLOADS			+= $(DISTRO_ROCKY_BOOT)


build/distros/rocky/grub.inc: $(DISTRO_ROCKY_CFG)
	@$(do_subst_files_dt)


#
# Distro downloads
#
boot/rocky/%/initrd.img:
	@mkdir -p "$(@D)"
	@WGET_FILE="$(@)"; WGET_URL="$(DISTRO_ROCKY_URL)/$(*)/$(@F)"; $(do_wget);


boot/rocky/%/vmlinuz:
	@mkdir -p "$(@D)"
	@WGET_FILE="$(@)"; WGET_URL="$(DISTRO_ROCKY_URL)/$(*)/$(@F)"; $(do_wget);


rocky-download: $(DISTRO_ROCKY_BOOT)


rocky-clean:
	rm -Rf build/distros/rocky
	rm -Rf boot/rocky
        

rocky-distclean: rocky-clean


#
# IPERD config  targets
#
rocky-defconfig:
	@echo '#'
	@echo '# Rocky Linux'
	@echo 'DISTRO_ROCKY=$(DEFAULT_ROCKY)'
	@echo 'DISTRO_ROCKY_URL=$(DEFAULT_ROCKY_URL)'
	@echo 'DISTRO_ROCKY_GRUB=$(DEFAULT_ROCKY_GRUB)'
	@echo 'DISTRO_ROCKY_APPEND=$(DEFAULT_ROCKY_APPEND)'
	@echo 'DISTRO_ROCKY_EXTRA_URL='
	@echo 'DISTRO_ROCKY_EXTRA_APPEND='
	@echo 'DISTRO_ROCKY_LOCAL_URL=$(DEFAULT_ROCKY_URL)'
	@echo 'DISTRO_ROCKY_LOCAL_GRUB=$(DEFAULT_ROCKY_GRUB)'
	@echo 'DISTRO_ROCKY_LOCAL_APPEND=$(DEFAULT_ROCKY_APPEND)'
	@for REL in $(DEFAULT_ROCKY_VERSIONS); do \
	   echo "DISTRO_ROCKY_$${REL}=$(DEFAULT_ROCKY_OPT)"; \
	done;


# end of Makefile.inc
