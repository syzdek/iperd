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


DISTRO_FEDORA			?= n
DISTRO_FEDORA_MIRROR		?= n
DISTRO_FEDORA_URL		?= https://mirrors.edge.kernel.org/fedora/releases
DISTRO_FEDORA_GRUB		?= (http,mirrors.edge.kernel.org)/fedora/releases
DISTRO_FEDORA_APPEND		?=
DISTRO_FEDORA_EXTRA_URL		?=
DISTRO_FEDORA_EXTRA_GRUB	?=
DISTRO_FEDORA_EXTRA_APPEND	?=
DISTRO_FEDORA_LOCAL_URL		?= https://mirrors.edge.kernel.org/fedora/releases
DISTRO_FEDORA_LOCAL_GRUB	?= (http,mirrors.edge.kernel.org)/fedora/releases
DISTRO_FEDORA_LOCAL_APPEND	?=
DISTRO_FEDORA_42		?= n
DISTRO_FEDORA_43		?= n
DISTRO_FEDORA_44		?= n


DISTRO_FEDORA_KEYWORDS		:= DISTRO_APPEND='$(DISTRO_FEDORA_APPEND)'; \
				   DISTRO_GRUB='$(DISTRO_FEDORA_GRUB)'; \
				   DISTRO_URL='$(DISTRO_FEDORA_URL)'; \
				   DISTRO_EXTRA_APPEND='$(DISTRO_FEDORA_EXTRA_APPEND)'; \
				   DISTRO_EXTRA_URL='$(DISTRO_FEDORA_EXTRA_URL)'; \
				   DISTRO_LOCAL_APPEND='$(DISTRO_FEDORA_LOCAL_APPEND)'; \
				   DISTRO_LOCAL_GRUB='$(DISTRO_FEDORA_LOCAL_GRUB)'; \
				   DISTRO_LOCAL_URL='$(DISTRO_FEDORA_LOCAL_URL)';


ifeq ($(DISTRO_FEDORA), y)
   GRUB_CFG_INCLUDES		+= src/distros/fedora/grub.d/grub.inc
   DISTRO_FEDORA_CFG		+= src/distros/fedora/grub-header.inc.in

   #
   # Fedora 42
   ifneq ($(DISTRO_FEDORA_42), n)
      DISTRO_FEDORA_CFG		+= src/distros/fedora/grub.d/fedora-42.inc
   endif
   ifeq ($(DISTRO_FEDORA_42), d)
      DISTRO_FEDORA_BOOT	+= boot/fedora/42/Everything/x86_64/os/images/pxeboot/initrd.img
      DISTRO_FEDORA_BOOT	+= boot/fedora/42/Everything/x86_64/os/images/pxeboot/vmlinuz
   else ifneq ($(DISTRO_FEDORA_42), l)
      DISTRO_FEDORA_42		:= y
   endif

   #
   # Fedora 43
   ifneq ($(DISTRO_FEDORA_43), n)
      DISTRO_FEDORA_CFG		+= src/distros/fedora/grub.d/fedora-43.inc
   endif
   ifeq ($(DISTRO_FEDORA_43), d)
      DISTRO_FEDORA_BOOT	+= boot/fedora/43/Everything/x86_64/os/images/pxeboot/initrd.img
      DISTRO_FEDORA_BOOT	+= boot/fedora/43/Everything/x86_64/os/images/pxeboot/vmlinuz
   else ifneq ($(DISTRO_FEDORA_43), l)
      DISTRO_FEDORA_43		:= y
   endif

   #
   # Fedora 44
   ifneq ($(DISTRO_FEDORA_44), n)
      DISTRO_FEDORA_CFG		+= src/distros/fedora/grub.d/fedora-44.inc
   endif
   ifeq ($(DISTRO_FEDORA_44), d)
      DISTRO_FEDORA_BOOT	+= boot/fedora/44/Everything/x86_64/os/images/pxeboot/initrd.img
      DISTRO_FEDORA_BOOT	+= boot/fedora/44/Everything/x86_64/os/images/pxeboot/vmlinuz
   else ifneq ($(DISTRO_FEDORA_44), l)
      DISTRO_FEDORA_44		:= y
   endif

   DISTRO_FEDORA_CFG		+= src/distros/fedora/grub-footer.inc.in
endif
IPERD_DOWNLOADS			+= $(DISTRO_FEDORA_BOOT)


.PHONY: fedora-download


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


#
# Grub include targets
#
src/distros/fedora/grub.d/fedora-42.inc: src/distros/fedora/grub-distro.inc.in
	@$(do_subst_start)
	@$(DISTRO_FEDORA_KEYWORDS) \
		DISTRO_VERSION=42; \
		DISTRO_OPT=$(DISTRO_FEDORA_42); \
		DISTRO_ARCH=x86_64; \
		$(do_subst_finish)


src/distros/fedora/grub.d/fedora-43.inc: src/distros/fedora/grub-distro.inc.in
	@$(do_subst_start)
	@$(DISTRO_FEDORA_KEYWORDS) \
		DISTRO_VERSION=43; \
		DISTRO_OPT=$(DISTRO_FEDORA_43); \
		DISTRO_ARCH=x86_64; \
		$(do_subst_finish)


src/distros/fedora/grub.d/fedora-44.inc: src/distros/fedora/grub-distro.inc.in
	@$(do_subst_start)
	@$(DISTRO_FEDORA_KEYWORDS) \
		DISTRO_VERSION=44; \
		DISTRO_OPT=$(DISTRO_FEDORA_44); \
		DISTRO_ARCH=x86_64; \
		$(do_subst_finish)


src/distros/fedora/grub.d/grub.inc: $(DISTRO_FEDORA_CFG)
	@$(do_subst_files_dt)


#
# IPERD config  targets
#
fedora-defconfig:
	@echo "#"
	@echo "# Fedora Linux"
	@echo "DISTRO_FEDORA=y"
	@echo "DISTRO_FEDORA_URL=https://mirrors.edge.kernel.org/fedora/releases"
	@echo "DISTRO_FEDORA_GRUB=(http,mirrors.edge.kernel.org)/fedora/releases"
	@echo "DISTRO_FEDORA_APPEND="
	@echo "DISTRO_FEDORA_EXTRA_URL="
	@echo "DISTRO_FEDORA_EXTRA_APPEND="
	@echo "DISTRO_FEDORA_LOCAL_URL=https://mirrors.edge.kernel.org/fedora/releases"
	@echo "DISTRO_FEDORA_LOCAL_GRUB=(http,mirrors.edge.kernel.org)/fedora/releases"
	@echo "DISTRO_FEDORA_LOCAL_APPEND="
	@for REL in 42 43 44; do \
	   echo "DISTRO_FEDORA_$${REL}=y"; \
	done;


# end of Makefile.inc
