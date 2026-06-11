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


DISTRO_ALPINE_CFG		:=
DISTRO_ALPINE_BOOT		:=
DISTRO_ALPINE_SOURCE		:=


DEFAULT_ALPINE			?= y
DEFAULT_ALPINE_URL		?= https://mirrors.edge.kernel.org/alpine
DEFAULT_ALPINE_GRUB		?= (http,mirrors.edge.kernel.org)/alpine
DEFAULT_ALPINE_APPEND		?=
DEFAULT_ALPINE_OPT		:= $(DEFAULT_ALPINE)
DEFAULT_ALPINE_VERSIONS		:= 3.18 \
				   3.19 \
				   3.20 \
				   3.21 \
				   3.22 \
				   3.23


DISTRO_ALPINE			?= $(DEFAULT_ALPINE)
DISTRO_ALPINE_URL		?= $(DEFAULT_ALPINE_URL)
DISTRO_ALPINE_GRUB		?= $(DEFAULT_ALPINE_GRUB)
DISTRO_ALPINE_APPEND		?= $(DEFAULT_ALPINE_APPEND)
DISTRO_ALPINE_LOCAL_URL		?= $(DISTRO_ALPINE_URL)
DISTRO_ALPINE_LOCAL_GRUB	?= $(DISTRO_ALPINE_GRUB)
DISTRO_ALPINE_LOCAL_APPEND	?= $(DISTRO_ALPINE_APPEND)


DISTRO_ALPINE_KEYWORDS		:= DISTRO_APPEND='$(DISTRO_ALPINE_APPEND)'; \
				   DISTRO_GRUB='$(DISTRO_ALPINE_GRUB)'; \
				   DISTRO_URL='$(DISTRO_ALPINE_URL)'; \
				   DISTRO_LOCAL_APPEND='$(DISTRO_ALPINE_LOCAL_APPEND)'; \
				   DISTRO_LOCAL_GRUB='$(DISTRO_ALPINE_LOCAL_GRUB)'; \
				   DISTRO_LOCAL_URL='$(DISTRO_ALPINE_LOCAL_URL)';


.PHONY: alpine-download alpine-defconfig


.makefile.d/alpine.inc: .config src/distros/alpine/Makefile.distro.in
	@if test "x$(IPERD_DEFCONFIG)" != "x1"; then \
	   echo "  GEN      $(@)"; \
	fi;
	@rm -f "$(@)"
	@mkdir -p "$(@D)"
	@for REL in $(DEFAULT_ALPINE_VERSIONS); do \
	   TAG="$$(echo "$${REL}" |sed -e 's/\.//g')"; \
	   sed \
	      -e "s/[@]DISTRO_VERSION[@]/$${REL}/g" \
	      -e "s/[@]DISTRO_TAG[@]/$${TAG}/g" \
	      src/distros/alpine/Makefile.distro.in; \
	done > "$(@)";
	@touch "$(@)"


GRUB_CFG_INCLUDES		+= var/distros/alpine/grub.inc
DISTRO_ALPINE_CFG		+= src/distros/alpine/grub-header.inc.in
-include .makefile.d/alpine.inc
DISTRO_ALPINE_CFG		+= src/distros/alpine/grub-footer.inc.in
IPERD_DOWNLOADS			+= $(DISTRO_ALPINE_BOOT)


var/distros/alpine/grub.inc: $(DISTRO_ALPINE_CFG)
	@$(do_subst_files_dt)


#
# Distro downloads
#
boot/alpine/v%/main/x86/.iperd:
	@rm -Rf "boot/alpine/v$(*)/main/x86"
	@rm -Rf "boot/alpine/v$(*)/releases/x86"
	@rm -Rf "var/distros/alpine/source/alpine-$(*).0-x86*"
	@mkdir -p "boot/alpine/v$(*)/main"
	@mkdir -p "boot/alpine/v$(*)/releases/x86/netboot"
	@mkdir -p "var/distros/alpine/source/alpine-$(*).0-x86"
	@WGET_FILENAME="initramfs-lts"; \
		WGET_FILE="boot/alpine/v$(*)/releases/x86/netboot/$${WGET_FILENAME}"; \
		WGET_URL="$(DISTRO_ALPINE_URL)/v$(*)/releases/x86/netboot/$${WGET_FILENAME}"; \
		$(do_wget);
	@WGET_FILENAME="modloop-lts"; \
		WGET_FILE="boot/alpine/v$(*)/releases/x86/netboot/$${WGET_FILENAME}"; \
		WGET_URL="$(DISTRO_ALPINE_URL)/v$(*)/releases/x86/netboot/$${WGET_FILENAME}"; \
		$(do_wget);
	@WGET_FILENAME="vmlinuz-lts"; \
		WGET_FILE="boot/alpine/v$(*)/releases/x86/netboot/$${WGET_FILENAME}"; \
		WGET_URL="$(DISTRO_ALPINE_URL)/v$(*)/releases/x86/netboot/$${WGET_FILENAME}"; \
		$(do_wget);
	@WGET_FILENAME="alpine-standard-$(*).0-x86.iso"; \
		WGET_FILE="var/distros/alpine/source/$${WGET_FILENAME}"; \
		WGET_URL="$(DISTRO_ALPINE_URL)/v$(*)/releases/x86/$${WGET_FILENAME}"; \
		$(do_wget);
	@BSDTAR_FILE="var/distros/alpine/source/alpine-standard-$(*).0-x86.iso"; \
		BSDTAR_DIR="var/distros/alpine/source/alpine-standard-$(*).0-x86"; \
		$(do_bsdtar);
	@mv \
	   "var/distros/alpine/source/alpine-standard-$(*).0-x86/apks/x86" \
	   "boot/alpine/v$(*)/main/x86"
	@rm -Rf "var/distros/alpine/source/alpine-$(*).0-x86"
	@rm -Rf "var/distros/alpine/source/alpine-$(*).0-x86.iso"
	@touch $(@)


boot/alpine/v%/main/x86_64/.iperd:
	@rm -Rf "boot/alpine/v$(*)/main/x86_64"
	@rm -Rf "boot/alpine/v$(*)/releases/x86_64"
	@rm -Rf "var/distros/alpine/source/alpine-$(*).0-x86_64*"
	@mkdir -p "boot/alpine/v$(*)/main"
	@mkdir -p "boot/alpine/v$(*)/releases/x86_64/netboot"
	@mkdir -p "var/distros/alpine/source/alpine-$(*).0-x86_64"
	@WGET_FILENAME="initramfs-lts"; \
		WGET_FILE="boot/alpine/v$(*)/releases/x86_64/netboot/$${WGET_FILENAME}"; \
		WGET_URL="$(DISTRO_ALPINE_URL)/v$(*)/releases/x86_64/netboot/$${WGET_FILENAME}"; \
		$(do_wget);
	@WGET_FILENAME="modloop-lts"; \
		WGET_FILE="boot/alpine/v$(*)/releases/x86_64/netboot/$${WGET_FILENAME}"; \
		WGET_URL="$(DISTRO_ALPINE_URL)/v$(*)/releases/x86_64/netboot/$${WGET_FILENAME}"; \
		$(do_wget);
	@WGET_FILENAME="vmlinuz-lts"; \
		WGET_FILE="boot/alpine/v$(*)/releases/x86_64/netboot/$${WGET_FILENAME}"; \
		WGET_URL="$(DISTRO_ALPINE_URL)/v$(*)/releases/x86_64/netboot/$${WGET_FILENAME}"; \
		$(do_wget);
	@WGET_FILENAME="alpine-standard-$(*).0-x86_64.iso"; \
		WGET_FILE="var/distros/alpine/source/$${WGET_FILENAME}"; \
		WGET_URL="$(DISTRO_ALPINE_URL)/v$(*)/releases/x86_64/$${WGET_FILENAME}"; \
		$(do_wget);
	@BSDTAR_FILE="var/distros/alpine/source/alpine-standard-$(*).0-x86_64.iso"; \
		BSDTAR_DIR="var/distros/alpine/source/alpine-standard-$(*).0-x86_64"; \
		$(do_bsdtar);
	@mv \
	   "var/distros/alpine/source/alpine-standard-$(*).0-x86_64/apks/x86_64" \
	   "boot/alpine/v$(*)/main/x86_64"
	@rm -Rf "var/distros/alpine/source/alpine-$(*).0-x86_64"
	@rm -Rf "var/distros/alpine/source/alpine-$(*).0-x86_64.iso"
	@touch $(@)


alpine-download: $(DISTRO_ALPINE_BOOT)


#
# IPERD config targets
#
alpine-defconfig:
	@echo "#"
	@echo "# Alpine Linux"
	@echo "DISTRO_ALPINE=$(DEFAULT_ALPINE)"
	@echo "DISTRO_ALPINE_URL=$(DEFAULT_ALPINE_URL)"
	@echo "DISTRO_ALPINE_GRUB=$(DEFAULT_ALPINE_GRUB)"
	@echo "DISTRO_ALPINE_APPEND=$(DEFAULT_ALPINE_APPEND)"
	@echo "DISTRO_ALPINE_LOCAL_URL=$(DEFAULT_ALPINE_URL)"
	@echo "DISTRO_ALPINE_LOCAL_GRUB=$(DEFAULT_ALPINE_GRUB)"
	@echo "DISTRO_ALPINE_LOCAL_APPEND=$(DEFAULT_ALPINE_APPEND)"
	@for REL in $(DEFAULT_ALPINE_VERSIONS); do \
	   REL="$$(echo "$${REL}" |sed -e 's/\.//g')"; \
	   echo "DISTRO_ALPINE_$${REL}_x86=$(DEFAULT_ALPINE_OPT)"; \
	   echo "DISTRO_ALPINE_$${REL}_x8664=$(DEFAULT_ALPINE_OPT)"; \
	done;


# end of Makefile.inc
