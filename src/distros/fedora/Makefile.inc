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


DISTRO_FEDORA_CFG		:=
DISTRO_FEDORA_BOOT		:=


DEFAULT_FEDORA			?= y
DEFAULT_FEDORA_URL		?= https://mirrors.edge.kernel.org/fedora/releases
DEFAULT_FEDORA_GRUB		?= (http,mirrors.edge.kernel.org)/fedora/releases
DEFAULT_FEDORA_APPEND		?=
DEFAULT_FEDORA_OPT		?= $(DEFAULT_FEDORA)
DEFAULT_FEDORA_VERSIONS		?= 42 \
				   43 \
				   44


DISTRO_FEDORA			?= $(DEFAULT_FEDORA)
DISTRO_FEDORA_URL		?= $(DEFAULT_FEDORA_URL)
DISTRO_FEDORA_GRUB		?= $(DEFAULT_FEDORA_GRUB)
DISTRO_FEDORA_APPEND		?= $(DEFAULT_FEDORA_APPEND)
DISTRO_FEDORA_LOCAL_URL		?= $(DISTRO_FEDORA_URL)
DISTRO_FEDORA_LOCAL_GRUB	?= $(DISTRO_FEDORA_GRUB)
DISTRO_FEDORA_LOCAL_APPEND	?= $(DISTRO_FEDORA_APPEND)


DISTRO_FEDORA_KEYWORDS		:= DISTRO_APPEND='$(DISTRO_FEDORA_APPEND)'; \
				   DISTRO_GRUB='$(DISTRO_FEDORA_GRUB)'; \
				   DISTRO_PUB_URL='$(DISTRO_FEDORA_URL)'; \
				   DISTRO_LOCAL_APPEND='$(DISTRO_FEDORA_LOCAL_APPEND)'; \
				   DISTRO_LOCAL_GRUB='$(DISTRO_FEDORA_LOCAL_GRUB)'; \
				   DISTRO_LOCAL_URL='$(DISTRO_FEDORA_LOCAL_URL)';


.PHONY: fedora-clean fedora-distclean fedora-download fedora-defconfig


build/distros/fedora/Makefile.versions.inc: .config src/distros/fedora/Makefile.version.inc.in
	@if test "x$(IPERD_DEFCONFIG)" != "x1"; then \
	   echo "  GEN      $(@)"; \
	fi
	@rm -f "$(@)"
	@mkdir -p "$(@D)"
	@for REL in $(DEFAULT_FEDORA_VERSIONS); do \
	   sed \
	      -e "s/[@]DISTRO_VERSION[@]/$${REL}/g" \
	      src/distros/fedora/Makefile.version.inc.in; \
	done > "$(@)";
	@touch "$(@)"


GRUB_CFG_INCLUDES		+= build/distros/fedora/grub.inc
DISTRO_FEDORA_CFG		+= src/distros/fedora/grub-header.inc.in
-include build/distros/fedora/Makefile.versions.inc
DISTRO_FEDORA_CFG		+= src/distros/fedora/grub-footer.inc.in
IPERD_DOWNLOADS			+= $(DISTRO_FEDORA_BOOT)


build/distros/fedora/grub.inc: $(DISTRO_FEDORA_CFG)
	@$(do_subst_files_dt)


#
# Distro downloads
#
boot/fedora/%/initrd.img:
	@mkdir -p "$(@D)"
	@WGET_FILE="$(@)"; WGET_URL="$(DISTRO_FEDORA_URL)/$(*)/$(@F)"; $(do_wget);


boot/fedora/%/vmlinuz:
	@mkdir -p "$(@D)"
	@WGET_FILE="$(@)"; WGET_URL="$(DISTRO_FEDORA_URL)/$(*)/$(@F)"; $(do_wget);


fedora-download: $(DISTRO_FEDORA_BOOT)


fedora-clean:
	rm -Rf build/distros/fedora
	rm -Rf boot/fedora
        

fedora-distclean: fedora-clean


#
# IPERD config  targets
#
fedora-defconfig:
	@echo "#"
	@echo "# Fedora Linux"
	@echo "DISTRO_FEDORA=$(DEFAULT_FEDORA)"
	@echo "DISTRO_FEDORA_URL=$(DEFAULT_FEDORA_URL)"
	@echo "DISTRO_FEDORA_GRUB=$(DEFAULT_FEDORA_GRUB)"
	@echo "DISTRO_FEDORA_APPEND=$(DEFAULT_FEDORA_APPEND)"
	@echo "DISTRO_FEDORA_LOCAL_URL=$(DEFAULT_FEDORA_URL)"
	@echo "DISTRO_FEDORA_LOCAL_GRUB=$(DEFAULT_FEDORA_GRUB)"
	@echo "DISTRO_FEDORA_LOCAL_APPEND=$(DEFAULT_FEDORA_APPEND)"
	@for REL in $(DEFAULT_FEDORA_VERSIONS); do \
	   echo "DISTRO_FEDORA_$${REL}=$(DEFAULT_FEDORA_OPT)"; \
	done;


# end of Makefile.inc
