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


DISTRO_DEBIAN_CFG		:=
DISTRO_DEBIAN_BOOT		:=
DISTRO_DEBIAN_SOURCE		:=


DEFAULT_DEBIAN			:= y
DEFAULT_DEBIAN_URL		:= https://deb.debian.org/debian
DEFAULT_DEBIAN_GRUB		:= (http,deb.debian.org)/debian
DEFAULT_DEBIAN_APPEND		:=
DEFAULT_DEBIAN_DOWNLOAD_APPEND	:= $(DEFAULT_DEBIAN_APPEND)
DEFAULT_DEBIAN_LOCAL_URL	:= $(DEFAULT_DEBIAN_URL)
DEFAULT_DEBIAN_LOCAL_GRUB	:= $(DEFAULT_DEBIAN_GRUB)
DEFAULT_DEBIAN_LOCAL_APPEND	:= $(DEFAULT_DEBIAN_APPEND)
DEFAULT_DEBIAN_OPT_I386		:= n
DEFAULT_DEBIAN_OPT_AMD64	:= $(DEFAULT_DEBIAN)
DEFAULT_DEBIAN_VERSIONS		:= bullseye \
				   bookworm \
				   trixie


DISTRO_DEBIAN			?= $(DEFAULT_DEBIAN)
DISTRO_DEBIAN_URL		?= $(DEFAULT_DEBIAN_URL)
DISTRO_DEBIAN_GRUB		?= $(DEFAULT_DEBIAN_GRUB)
DISTRO_DEBIAN_APPEND		?= $(DEFAULT_DEBIAN_APPEND)
DISTRO_DEBIAN_DOWNLOAD_APPEND	?= $(DISTRO_DEBIAN_APPEND)
DISTRO_DEBIAN_LOCAL_URL		?= $(DISTRO_DEBIAN_URL)
DISTRO_DEBIAN_LOCAL_GRUB	?= $(DISTRO_DEBIAN_GRUB)
DISTRO_DEBIAN_LOCAL_APPEND	?= $(DISTRO_DEBIAN_APPEND)


DISTRO_DEBIAN_KEYWORDS		:= DISTRO_ALIAS='debian'; \
				   DISTRO_PUB_URL='$(DISTRO_ALPINE_URL)'; \
				   DISTRO_PUB_REPO='$(DISTRO_ALPINE_REPO)'; \
				   DISTRO_PUB_GRUB='$(DISTRO_ALPINE_GRUB)'; \
				   DISTRO_PUB_APPEND='$(DISTRO_ALPINE_APPEND)'; \
				   DISTRO_DOWNLOAD_REPO='$(DISTRO_ALPINE_DOWNLOAD_REPO)'; \
				   DISTRO_DOWNLOAD_APPEND='$(DISTRO_ALPINE_DOWNLOAD_APPEND)'; \
				   DISTRO_EXTRA_URL='$(DISTRO_ALPINE_DOWNLOAD_URL)'; \
				   DISTRO_EXTRA_APPEND='$(DISTRO_ALPINE_DOWNLOAD_APPEND)'; \
				   DISTRO_LOCAL_URL='$(DISTRO_ALPINE_LOCAL_URL)'; \
				   DISTRO_LOCAL_REPO='$(DISTRO_ALPINE_LOCAL_REPO)'; \
				   DISTRO_LOCAL_GRUB='$(DISTRO_ALPINE_LOCAL_GRUB)'; \
				   DISTRO_LOCAL_APPEND='$(DISTRO_ALPINE_LOCAL_APPEND)'; \


.PHONY: debian-clean debian-distclean debian-download debian-defconfig


build/distros/debian/Makefile.versions.inc: .config src/distros/debian/Makefile.version.inc.in
	@if test "x$(IPERD_DEFCONFIG)" != "x1"; then \
	   echo "  GEN      $(@)"; \
	fi;
	@rm -f "$(@)"
	@mkdir -p "$(@D)"
	@for REL in $(DEFAULT_DEBIAN_VERSIONS); do \
	   CODENAME="$$(echo "$${REL}" |tr a-z A-Z)"; \
	   sed \
	      -e "s/[@]DISTRO_VERSION[@]/$${REL}/g" \
	      -e "s/[@]DISTRO_VER_CODENAME[@]/$${CODENAME}/g" \
	      src/distros/debian/Makefile.version.inc.in; \
	done > "$(@)";
	@touch "$(@)"


GRUB_CFG_INCLUDES		+= build/distros/debian/grub.inc
DISTRO_DEBIAN_CFG		+= src/distros/debian/grub-header.inc.in
-include build/distros/debian/Makefile.versions.inc
DISTRO_DEBIAN_CFG		+= src/distros/debian/grub-footer.inc.in
IPERD_DOWNLOADS			+= $(DISTRO_DEBIAN_BOOT)


build/distros/debian/grub.inc: $(DISTRO_DEBIAN_CFG)
	@$(do_subst_files_dt)


#
# Distro downloads
#
boot/debian/dists/%/main/installer-i386/.iperd:
	@rm -Rf   "boot/debian/dists/$(*)/main/installer-i386"
	@mkdir -p "boot/debian/dists/$(*)/main/installer-i386/current/images/netboot/debian-installer/i386"
	@WGET_FILENAME="initrd.gz"; \
		WGET_FILE="boot/debian/dists/$(*)/main/installer-i386/current/images/netboot/debian-installer/i386/$${WGET_FILENAME}"; \
		WGET_URL="$(DISTRO_DEBIAN_URL)/dists/$(*)/main/installer-i386/current/images/netboot/debian-installer/i386/$${WGET_FILENAME}"; \
		$(do_wget);
	@WGET_FILENAME="linux"; \
		WGET_FILE="boot/debian/dists/$(*)/main/installer-i386/current/images/netboot/debian-installer/i386/$${WGET_FILENAME}"; \
		WGET_URL="$(DISTRO_DEBIAN_URL)/dists/$(*)/main/installer-i386/current/images/netboot/debian-installer/i386/$${WGET_FILENAME}"; \
		$(do_wget);
	@touch $(@)


boot/debian/dists/%/main/installer-amd64/.iperd:
	@rm -Rf   "boot/debian/dists/$(*)/main/installer-amd64"
	@mkdir -p "boot/debian/dists/$(*)/main/installer-amd64/current/images/netboot/debian-installer/amd64"
	@WGET_FILENAME="initrd.gz"; \
		WGET_FILE="boot/debian/dists/$(*)/main/installer-amd64/current/images/netboot/debian-installer/amd64/$${WGET_FILENAME}"; \
		WGET_URL="$(DISTRO_DEBIAN_URL)/dists/$(*)/main/installer-amd64/current/images/netboot/debian-installer/amd64/$${WGET_FILENAME}"; \
		$(do_wget);
	@WGET_FILENAME="linux"; \
		WGET_FILE="boot/debian/dists/$(*)/main/installer-amd64/current/images/netboot/debian-installer/amd64/$${WGET_FILENAME}"; \
		WGET_URL="$(DISTRO_DEBIAN_URL)/dists/$(*)/main/installer-amd64/current/images/netboot/debian-installer/amd64/$${WGET_FILENAME}"; \
		$(do_wget);
	@touch $(@)


debian-download: $(DISTRO_DEBIAN_BOOT)


debian-clean:
	rm -Rf build/distros/debian
	rm -Rf boot/debian


debian-distclean: debian-clean


#
# IPERD config targets
#
debian-defconfig:
	@echo "#"
	@echo "# Debian Linux"
	@echo "DISTRO_DEBIAN=$(DEFAULT_DEBIAN)"
	@echo "DISTRO_DEBIAN_URL=$(DEFAULT_DEBIAN_URL)"
	@echo "DISTRO_DEBIAN_GRUB=$(DEFAULT_DEBIAN_GRUB)"
	@echo "DISTRO_DEBIAN_APPEND=$(DEFAULT_DEBIAN_APPEND)"
	@echo "DISTRO_DEBIAN_LOCAL_URL=$(DEFAULT_DEBIAN_URL)"
	@echo "DISTRO_DEBIAN_LOCAL_GRUB=$(DEFAULT_DEBIAN_GRUB)"
	@echo "DISTRO_DEBIAN_LOCAL_APPEND=$(DEFAULT_DEBIAN_APPEND)"
	@for REL in $(DEFAULT_DEBIAN_VERSIONS); do \
	   REL="$$(echo "$${REL}" |tr a-z A-Z)"; \
	   echo "DISTRO_DEBIAN_$${REL}_I386=$(DEFAULT_DEBIAN_OPT_I386)"; \
	   echo "DISTRO_DEBIAN_$${REL}_AMD64=$(DEFAULT_DEBIAN_OPT_AMD64)"; \
	done;


# end of Makefile.inc
