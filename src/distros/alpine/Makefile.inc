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


DISTRO_ALPINE			?= n
DISTRO_ALPINE_MIRROR		?= n
DISTRO_ALPINE_URL		?= https://mirrors.edge.kernel.org/alpine
DISTRO_ALPINE_GRUB		?= (http,mirrors.edge.kernel.org)/alpine
DISTRO_ALPINE_APPEND		?=
DISTRO_ALPINE_318_x86		?= n
DISTRO_ALPINE_318_x8664		?= n
DISTRO_ALPINE_319_x86		?= n
DISTRO_ALPINE_319_x8664		?= n
DISTRO_ALPINE_320_x86		?= n
DISTRO_ALPINE_320_x8664		?= n
DISTRO_ALPINE_321_x86		?= n
DISTRO_ALPINE_321_x8664		?= n
DISTRO_ALPINE_322_x86		?= n
DISTRO_ALPINE_322_x8664		?= n
DISTRO_ALPINE_323_x86		?= n
DISTRO_ALPINE_323_x8664		?= n


DISTRO_ALPINE_KEYWORDS		:= DISTRO_APPEND='$(DISTRO_ALPINE_APPEND)'; \
				   DISTRO_GRUB='$(DISTRO_ALPINE_GRUB)'; \
				   DISTRO_URL='$(DISTRO_ALPINE_URL)';


ifeq ($(DISTRO_ALPINE), y)
   GRUB_CFG_INCLUDES		+= src/distros/alpine/grub.inc
   IPERD_DOWNLOADS		+= alpine-download
   DISTRO_ALPINE_CFG		+= src/distros/alpine/grub-header.inc.in

   # Alpine Linux 3.18
   ifneq ($(DISTRO_ALPINE_318_x86), n)
      DISTRO_ALPINE_CFG		+= src/distros/alpine/grub-alpine-3.18-x86.inc
   endif
   ifeq ($(DISTRO_ALPINE_318_x86), d)
      DISTRO_ALPINE_BOOT	+= boot/alpine/v3.18/main/x86/.iperd
   else
      DISTRO_ALPINE_318_x86	:= y
   endif

   ifneq ($(DISTRO_ALPINE_318_x8664), n)
      DISTRO_ALPINE_CFG		+= src/distros/alpine/grub-alpine-3.18-x86_64.inc
   endif
   ifeq ($(DISTRO_ALPINE_318_x8664), d)
      DISTRO_ALPINE_BOOT	+= boot/alpine/v3.18/main/x86_64/.iperd
   else
      DISTRO_ALPINE_318_x8664	:= y
   endif

   # Alpine Linux 3.19
   ifneq ($(DISTRO_ALPINE_319_x86), n)
      DISTRO_ALPINE_CFG		+= src/distros/alpine/grub-alpine-3.19-x86.inc
   endif
   ifeq ($(DISTRO_ALPINE_319_x86), d)
      DISTRO_ALPINE_BOOT	+= boot/alpine/v3.19/main/x86/.iperd
   else
      DISTRO_ALPINE_319_x86	:= y
   endif

   ifneq ($(DISTRO_ALPINE_319_x8664), n)
      DISTRO_ALPINE_CFG		+= src/distros/alpine/grub-alpine-3.19-x86_64.inc
   endif
   ifeq ($(DISTRO_ALPINE_319_x8664), d)
      DISTRO_ALPINE_BOOT	+= boot/alpine/v3.19/main/x86_64/.iperd
   else
      DISTRO_ALPINE_319_x8664	:= y
   endif

   # Alpine Linux 3.20
   ifneq ($(DISTRO_ALPINE_320_x86), n)
      DISTRO_ALPINE_CFG		+= src/distros/alpine/grub-alpine-3.20-x86.inc
   endif
   ifeq ($(DISTRO_ALPINE_320_x86), d)
      DISTRO_ALPINE_BOOT	+= boot/alpine/v3.20/main/x86/.iperd
   else
      DISTRO_ALPINE_320_x86	:= y
   endif

   ifneq ($(DISTRO_ALPINE_320_x8664), n)
      DISTRO_ALPINE_CFG		+= src/distros/alpine/grub-alpine-3.20-x86_64.inc
   endif
   ifeq ($(DISTRO_ALPINE_320_x8664), d)
      DISTRO_ALPINE_BOOT	+= boot/alpine/v3.20/main/x86_64/.iperd
   else
      DISTRO_ALPINE_320_x8664	:= y
   endif

   # Alpine Linux 3.21
   ifneq ($(DISTRO_ALPINE_321_x86), n)
      DISTRO_ALPINE_CFG		+= src/distros/alpine/grub-alpine-3.21-x86.inc
   endif
   ifeq ($(DISTRO_ALPINE_321_x86), d)
      DISTRO_ALPINE_BOOT	+= boot/alpine/v3.21/main/x86/.iperd
   else
      DISTRO_ALPINE_321_x86	:= y
   endif

   ifneq ($(DISTRO_ALPINE_321_x8664), n)
      DISTRO_ALPINE_CFG		+= src/distros/alpine/grub-alpine-3.21-x86_64.inc
   endif
   ifeq ($(DISTRO_ALPINE_321_x8664), d)
      DISTRO_ALPINE_BOOT	+= boot/alpine/v3.21/main/x86_64/.iperd
   else
      DISTRO_ALPINE_321_x8664	:= y
   endif

   # Alpine Linux 3.22
   ifneq ($(DISTRO_ALPINE_322_x86), n)
      DISTRO_ALPINE_CFG		+= src/distros/alpine/grub-alpine-3.22-x86.inc
   endif
   ifeq ($(DISTRO_ALPINE_322_x86), d)
      DISTRO_ALPINE_BOOT	+= boot/alpine/v3.22/main/x86/.iperd
   else
      DISTRO_ALPINE_322_x86	:= y
   endif

   ifneq ($(DISTRO_ALPINE_322_x8664), n)
      DISTRO_ALPINE_CFG		+= src/distros/alpine/grub-alpine-3.22-x86_64.inc
   endif
   ifeq ($(DISTRO_ALPINE_322_x8664), d)
      DISTRO_ALPINE_BOOT	+= boot/alpine/v3.22/main/x86_64/.iperd
   else
      DISTRO_ALPINE_322_x8664	:= y
   endif

   # Alpine Linux 3.23
   ifneq ($(DISTRO_ALPINE_323_x86), n)
      DISTRO_ALPINE_CFG		+= src/distros/alpine/grub-alpine-3.23-x86.inc
   endif
   ifeq ($(DISTRO_ALPINE_323_x86), d)
      DISTRO_ALPINE_BOOT	+= boot/alpine/v3.23/main/x86/.iperd
   else
      DISTRO_ALPINE_323_x86	:= y
   endif

   ifneq ($(DISTRO_ALPINE_323_x8664), n)
      DISTRO_ALPINE_CFG		+= src/distros/alpine/grub-alpine-3.23-x86_64.inc
   endif
   ifeq ($(DISTRO_ALPINE_323_x8664), d)
      DISTRO_ALPINE_BOOT	+= boot/alpine/v3.23/main/x86_64/.iperd
   else
      DISTRO_ALPINE_323_x8664	:= y
   endif

   DISTRO_ALPINE_CFG		+= src/distros/alpine/grub-footer.inc.in
endif


.PHONY: alpine-download


#
# Distro downloads
#
boot/alpine/v%/main/x86/.iperd:
	@rm -Rf "boot/alpine/v$(*)/main/x86"
	@rm -Rf "boot/alpine/v$(*)/releases/x86"
	@rm -Rf "src/distros/alpine/source/alpine-$(*).0-x86*"
	@mkdir -p "boot/alpine/v$(*)/main"
	@mkdir -p "boot/alpine/v$(*)/releases/x86/netboot"
	@mkdir -p "src/distros/alpine/source/alpine-$(*).0-x86"
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
		WGET_FILE="src/distros/alpine/source/$${WGET_FILENAME}"; \
		WGET_URL="$(DISTRO_ALPINE_URL)/v$(*)/releases/x86/$${WGET_FILENAME}"; \
		$(do_wget);
	@BSDTAR_FILE="src/distros/alpine/source/alpine-standard-$(*).0-x86.iso"; \
		BSDTAR_DIR="src/distros/alpine/source/alpine-standard-$(*).0-x86"; \
		$(do_bsdtar);
	@mv \
	   "src/distros/alpine/source/alpine-standard-$(*).0-x86/apks/x86" \
	   "boot/alpine/v$(*)/main/x86"
	@rm -Rf "src/distros/alpine/source/alpine-$(*).0-x86"
	@rm -Rf "src/distros/alpine/source/alpine-$(*).0-x86.iso"
	@touch $(@)


boot/alpine/v%/main/x86_64/.iperd:
	@rm -Rf "boot/alpine/v$(*)/main/x86_64"
	@rm -Rf "boot/alpine/v$(*)/releases/x86_64"
	@rm -Rf "src/distros/alpine/source/alpine-$(*).0-x86_64*"
	@mkdir -p "boot/alpine/v$(*)/main"
	@mkdir -p "boot/alpine/v$(*)/releases/x86_64/netboot"
	@mkdir -p "src/distros/alpine/source/alpine-$(*).0-x86_64"
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
		WGET_FILE="src/distros/alpine/source/$${WGET_FILENAME}"; \
		WGET_URL="$(DISTRO_ALPINE_URL)/v$(*)/releases/x86_64/$${WGET_FILENAME}"; \
		$(do_wget);
	@BSDTAR_FILE="src/distros/alpine/source/alpine-standard-$(*).0-x86_64.iso"; \
		BSDTAR_DIR="src/distros/alpine/source/alpine-standard-$(*).0-x86_64"; \
		$(do_bsdtar);
	@mv \
	   "src/distros/alpine/source/alpine-standard-$(*).0-x86_64/apks/x86_64" \
	   "boot/alpine/v$(*)/main/x86_64"
	@rm -Rf "src/distros/alpine/source/alpine-$(*).0-x86_64"
	@rm -Rf "src/distros/alpine/source/alpine-$(*).0-x86_64.iso"
	@touch $(@)


alpine-download: $(DISTRO_ALPINE_BOOT)


#
# Grub include targets
#
# Alpine Linux 3.18.x
src/distros/alpine/grub-alpine-3.18-x86.inc: src/distros/alpine/grub-distro.inc.in
	@$(do_subst_start)
	@$(DISTRO_ALPINE_KEYWORDS) \
		DISTRO_VERSION=3.18; \
		DISTRO_OPT=$(DISTRO_ALPINE_318_x86); \
		DISTRO_ARCH=x86; \
		$(do_subst_finish)

src/distros/alpine/grub-alpine-3.18-x86_64.inc: src/distros/alpine/grub-distro.inc.in
	@$(do_subst_start)
	@$(DISTRO_ALPINE_KEYWORDS) \
		DISTRO_VERSION=3.18; \
		DISTRO_OPT=$(DISTRO_ALPINE_318_x8664); \
		DISTRO_ARCH=x86_64; \
		$(do_subst_finish)


# Alpine Linux 3.19.x
src/distros/alpine/grub-alpine-3.19-x86.inc: src/distros/alpine/grub-distro.inc.in
	@$(do_subst_start)
	@$(DISTRO_ALPINE_KEYWORDS) \
		DISTRO_VERSION=3.19; \
		DISTRO_OPT=$(DISTRO_ALPINE_319_x86); \
		DISTRO_ARCH=x86; \
		$(do_subst_finish)

src/distros/alpine/grub-alpine-3.19-x86_64.inc: src/distros/alpine/grub-distro.inc.in
	@$(do_subst_start)
	@$(DISTRO_ALPINE_KEYWORDS) \
		DISTRO_VERSION=3.19; \
		DISTRO_OPT=$(DISTRO_ALPINE_319_x8664); \
		DISTRO_ARCH=x86_64; \
		$(do_subst_finish)


# Alpine Linux 3.20.x
src/distros/alpine/grub-alpine-3.20-x86.inc: src/distros/alpine/grub-distro.inc.in
	@$(do_subst_start)
	@$(DISTRO_ALPINE_KEYWORDS) \
		DISTRO_VERSION=3.20; \
		DISTRO_OPT=$(DISTRO_ALPINE_320_x86); \
		DISTRO_ARCH=x86; \
		$(do_subst_finish)

src/distros/alpine/grub-alpine-3.20-x86_64.inc: src/distros/alpine/grub-distro.inc.in
	@$(do_subst_start)
	@$(DISTRO_ALPINE_KEYWORDS) \
		DISTRO_VERSION=3.20; \
		DISTRO_OPT=$(DISTRO_ALPINE_320_x8664); \
		DISTRO_ARCH=x86_64; \
		$(do_subst_finish)


# Alpine Linux 3.21.x
src/distros/alpine/grub-alpine-3.21-x86.inc: src/distros/alpine/grub-distro.inc.in
	@$(do_subst_start)
	@$(DISTRO_ALPINE_KEYWORDS) \
		DISTRO_VERSION=3.21; \
		DISTRO_OPT=$(DISTRO_ALPINE_321_x86); \
		DISTRO_ARCH=x86; \
		$(do_subst_finish)

src/distros/alpine/grub-alpine-3.21-x86_64.inc: src/distros/alpine/grub-distro.inc.in
	@$(do_subst_start)
	@$(DISTRO_ALPINE_KEYWORDS) \
		DISTRO_VERSION=3.21; \
		DISTRO_OPT=$(DISTRO_ALPINE_321_x8664); \
		DISTRO_ARCH=x86_64; \
		$(do_subst_finish)


# Alpine Linux 3.22.x
src/distros/alpine/grub-alpine-3.22-x86.inc: src/distros/alpine/grub-distro.inc.in
	@$(do_subst_start)
	@$(DISTRO_ALPINE_KEYWORDS) \
		DISTRO_VERSION=3.22; \
		DISTRO_OPT=$(DISTRO_ALPINE_322_x86); \
		DISTRO_ARCH=x86; \
		$(do_subst_finish)

src/distros/alpine/grub-alpine-3.22-x86_64.inc: src/distros/alpine/grub-distro.inc.in
	@$(do_subst_start)
	@$(DISTRO_ALPINE_KEYWORDS) \
		DISTRO_VERSION=3.22; \
		DISTRO_OPT=$(DISTRO_ALPINE_322_x8664); \
		DISTRO_ARCH=x86_64; \
		$(do_subst_finish)


# Alpine Linux 3.23.x
src/distros/alpine/grub-alpine-3.23-x86.inc: src/distros/alpine/grub-distro.inc.in
	@$(do_subst_start)
	@$(DISTRO_ALPINE_KEYWORDS) \
		DISTRO_VERSION=3.23; \
		DISTRO_OPT=$(DISTRO_ALPINE_323_x86); \
		DISTRO_ARCH=x86; \
		$(do_subst_finish)

src/distros/alpine/grub-alpine-3.23-x86_64.inc: src/distros/alpine/grub-distro.inc.in
	@$(do_subst_start)
	@$(DISTRO_ALPINE_KEYWORDS) \
		DISTRO_VERSION=3.23; \
		DISTRO_OPT=$(DISTRO_ALPINE_323_x8664); \
		DISTRO_ARCH=x86_64; \
		$(do_subst_finish)


# Alpine Linux Section
src/distros/alpine/grub.inc: $(DISTRO_ALPINE_CFG)
	@$(do_subst_files_dt)


# end of Makefile.inc
