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


DISTRO_UBUNTU_CFG		:=
DISTRO_UBUNTU_BOOT		:=
DISTRO_UBUNTU_SOURCE		:=


DEFAULT_UBUNTU			?= y
DEFAULT_UBUNTU_URL		?= https://mirrors.edge.kernel.org/ubuntu/
DEFAULT_UBUNTU_GRUB		?= (http,mirrors.edge.kernel.org)/ubuntu
DEFAULT_UBUNTU_APPEND		?=
DEFAULT_UBUNTU_OPT_I386		:= n
DEFAULT_UBUNTU_OPT_AMD64	:= $(DEFAULT_UBUNTU)
DEFAULT_UBUNTU_LEGACY_VER1	:= xenial \
				   bionic
DEFAULT_UBUNTU_LEGACY_VER2	:= focal
DEFAULT_UBUNTU_VERSIONS		:= jammy \
				   noble \
				   resolute


DISTRO_UBUNTU			?= $(DEFAULT_UBUNTU)
DISTRO_UBUNTU_URL		?= $(DEFAULT_UBUNTU_URL)
DISTRO_UBUNTU_GRUB		?= $(DEFAULT_UBUNTU_GRUB)
DISTRO_UBUNTU_APPEND		?= $(DEFAULT_UBUNTU_APPEND)
DISTRO_UBUNTU_LOCAL_URL		?= $(DISTRO_UBUNTU_URL)
DISTRO_UBUNTU_LOCAL_GRUB	?= $(DISTRO_UBUNTU_GRUB)
DISTRO_UBUNTU_LOCAL_APPEND	?= $(DISTRO_UBUNTU_APPEND)


DISTRO_UBUNTU_KEYWORDS		:= DISTRO_APPEND='$(DISTRO_UBUNTU_APPEND)'; \
				   DISTRO_GRUB='$(DISTRO_UBUNTU_GRUB)'; \
				   DISTRO_URL='$(DISTRO_UBUNTU_URL)'; \
				   DISTRO_LOCAL_APPEND='$(DISTRO_UBUNTU_LOCAL_APPEND)'; \
				   DISTRO_LOCAL_GRUB='$(DISTRO_UBUNTU_LOCAL_GRUB)'; \
				   DISTRO_LOCAL_URL='$(DISTRO_UBUNTU_LOCAL_URL)';


.PHONY: ubuntu-clean ubuntu-distclean ubuntu-download ubuntu-defconfig


build/distros/ubuntu/Makefile.versions.inc: .config src/distros/ubuntu/Makefile.distro-legacy1.in src/distros/ubuntu/Makefile.distro-legacy2.in
	@if test "x$(IPERD_DEFCONFIG)" != "x1"; then \
	   echo "  GEN      $(@)"; \
	fi;
	@rm -f "$(@)"
	@mkdir -p "$(@D)"
	@for REL in $(DEFAULT_UBUNTU_LEGACY_VER1); do \
	   CODENAME="$$(echo "$${REL}" |tr a-z A-Z)"; \
	   sed \
	      -e "s/[@]DISTRO_VERSION[@]/$${REL}/g" \
	      -e "s/[@]DISTRO_CODENAME[@]/$${CODENAME}/g" \
	      src/distros/ubuntu/Makefile.distro-legacy1.in; \
	done >> "$(@)";
	@for REL in $(DEFAULT_UBUNTU_LEGACY_VER2); do \
	   CODENAME="$$(echo "$${REL}" |tr a-z A-Z)"; \
	   sed \
	      -e "s/[@]DISTRO_VERSION[@]/$${REL}/g" \
	      -e "s/[@]DISTRO_CODENAME[@]/$${CODENAME}/g" \
	      src/distros/ubuntu/Makefile.distro-legacy2.in; \
	done >> "$(@)";
	@touch "$(@)"


GRUB_CFG_INCLUDES		+= build/distros/ubuntu/grub.inc
DISTRO_UBUNTU_CFG		+= src/distros/ubuntu/grub-header.inc.in
-include build/distros/ubuntu/Makefile.versions.inc
DISTRO_UBUNTU_CFG		+= src/distros/ubuntu/grub-footer.inc.in
IPERD_DOWNLOADS			+= $(DISTRO_UBUNTU_BOOT)


build/distros/ubuntu/grub.inc: $(DISTRO_UBUNTU_CFG)
	@$(do_subst_files_dt)


#
# Distro downloads
#
boot/ubuntu/dists/%/main/installer-i386/current/images/.iperd:
	@rm -Rf   "boot/ubuntu/dists/$(*)/main/installer-i386"
	@mkdir -p "boot/ubuntu/dists/$(*)/main/installer-i386/current/images/netboot/ubuntu-installer/i386"
	@WGET_FILENAME="initrd.gz"; \
		WGET_FILE="boot/ubuntu/dists/$(*)/main/installer-i386/current/images/netboot/ubuntu-installer/i386/$${WGET_FILENAME}"; \
		WGET_URL="$(DISTRO_UBUNTU_URL)/dists/$(*)/main/installer-i386/current/images/netboot/ubuntu-installer/i386/$${WGET_FILENAME}"; \
		$(do_wget);
	@WGET_FILENAME="linux"; \
		WGET_FILE="boot/ubuntu/dists/$(*)/main/installer-i386/current/images/netboot/ubuntu-installer/i386/$${WGET_FILENAME}"; \
		WGET_URL="$(DISTRO_UBUNTU_URL)/dists/$(*)/main/installer-i386/current/images/netboot/ubuntu-installer/i386/$${WGET_FILENAME}"; \
		$(do_wget);
	@touch $(@)


boot/ubuntu/dists/%/main/installer-amd64/current/images/.iperd:
	@rm -Rf   "boot/ubuntu/dists/$(*)/main/installer-amd64"
	@mkdir -p "boot/ubuntu/dists/$(*)/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64"
	@WGET_FILENAME="initrd.gz"; \
		WGET_FILE="boot/ubuntu/dists/$(*)/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64/$${WGET_FILENAME}"; \
		WGET_URL="$(DISTRO_UBUNTU_URL)/dists/$(*)/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64/$${WGET_FILENAME}"; \
		$(do_wget);
	@WGET_FILENAME="linux"; \
		WGET_FILE="boot/ubuntu/dists/$(*)/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64/$${WGET_FILENAME}"; \
		WGET_URL="$(DISTRO_UBUNTU_URL)/dists/$(*)/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64/$${WGET_FILENAME}"; \
		$(do_wget);
	@touch $(@)


boot/ubuntu/dists/%/main/installer-amd64/current/legacy-images/.iperd:
	@rm -Rf   "boot/ubuntu/dists/$(*)/main/installer-amd64"
	@mkdir -p "boot/ubuntu/dists/$(*)/main/installer-amd64/current/legacy-images/netboot/ubuntu-installer/amd64"
	@WGET_FILENAME="initrd.gz"; \
		WGET_FILE="boot/ubuntu/dists/$(*)/main/installer-amd64/current/legacy-images/netboot/ubuntu-installer/amd64/$${WGET_FILENAME}"; \
		WGET_URL="$(DISTRO_UBUNTU_URL)/dists/$(*)/main/installer-amd64/current/legacy-images/netboot/ubuntu-installer/amd64/$${WGET_FILENAME}"; \
		$(do_wget);
	@WGET_FILENAME="linux"; \
		WGET_FILE="boot/ubuntu/dists/$(*)/main/installer-amd64/current/legacy-images/netboot/ubuntu-installer/amd64/$${WGET_FILENAME}"; \
		WGET_URL="$(DISTRO_UBUNTU_URL)/dists/$(*)/main/installer-amd64/current/legacy-images/netboot/ubuntu-installer/amd64/$${WGET_FILENAME}"; \
		$(do_wget);
	@touch $(@)


ubuntu-download: $(DISTRO_UBUNTU_BOOT)


ubuntu-clean:
	rm -Rf build/distros/ubuntu
	rm -Rf boot/ubuntu


ubuntu-distclean: ubuntu-clean


#
# IPERD config targets
#
ubuntu-defconfig:
	@echo "#"
	@echo "# Ubuntu Linux"
	@echo "DISTRO_UBUNTU=$(DEFAULT_UBUNTU)"
	@echo "DISTRO_UBUNTU_URL=$(DEFAULT_UBUNTU_URL)"
	@echo "DISTRO_UBUNTU_GRUB=$(DEFAULT_UBUNTU_GRUB)"
	@echo "DISTRO_UBUNTU_APPEND=$(DEFAULT_UBUNTU_APPEND)"
	@echo "DISTRO_UBUNTU_LOCAL_URL=$(DEFAULT_UBUNTU_URL)"
	@echo "DISTRO_UBUNTU_LOCAL_GRUB=$(DEFAULT_UBUNTU_GRUB)"
	@echo "DISTRO_UBUNTU_LOCAL_APPEND=$(DEFAULT_UBUNTU_APPEND)"
	@for REL in $(DEFAULT_UBUNTU_LEGACY_VER1); do \
	   REL="$$(echo "$${REL}" |tr a-z A-Z)"; \
	   echo "DISTRO_UBUNTU_$${REL}_I386=$(DEFAULT_UBUNTU_OPT_I386)"; \
	   echo "DISTRO_UBUNTU_$${REL}_AMD64=$(DEFAULT_UBUNTU_OPT_AMD64)"; \
	done;
	@for REL in $(DEFAULT_UBUNTU_LEGACY_VER2); do \
	   REL="$$(echo "$${REL}" |tr a-z A-Z)"; \
	   echo "DISTRO_UBUNTU_$${REL}_AMD64=$(DEFAULT_UBUNTU_OPT_AMD64)"; \
	done;
	@for REL in $(DEFAULT_UBUNTU_VERSIONS); do \
	   REL="$$(echo "$${REL}" |tr a-z A-Z)"; \
	   echo "#DISTRO_UBUNTU_$${REL}_AMD64=n"; \
	done;


# end of Makefile.inc
