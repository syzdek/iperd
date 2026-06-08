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


DISTRO_ROCKY			?= n
DISTRO_ROCKY_MIRROR		?= n
DISTRO_ROCKY_URL		?= https://dl.rockylinux.org/pub/rocky
DISTRO_ROCKY_GRUB		?= (http,dl.rockylinux.org)/pub/rocky
DISTRO_ROCKY_APPEND		?=
DISTRO_ROCKY_EXTRA_URL		?=
DISTRO_ROCKY_EXTRA_GRUB		?=
DISTRO_ROCKY_EXTRA_APPEND	?=
DISTRO_ROCKY_LOCAL_URL		?= https://dl.rockylinux.org/pub/rocky
DISTRO_ROCKY_LOCAL_GRUB		?= (http,dl.rockylinux.org)/pub/rocky
DISTRO_ROCKY_LOCAL_APPEND	?=
DISTRO_ROCKY_8			?= n
DISTRO_ROCKY_9			?= n
DISTRO_ROCKY_10			?= n


DISTRO_ROCKY_KEYWORDS		:= DISTRO_APPEND='$(DISTRO_ROCKY_APPEND)'; \
				   DISTRO_GRUB='$(DISTRO_ROCKY_GRUB)'; \
				   DISTRO_URL='$(DISTRO_ROCKY_URL)'; \
				   DISTRO_EXTRA_APPEND='$(DISTRO_ROCKY_EXTRA_APPEND)'; \
				   DISTRO_EXTRA_URL='$(DISTRO_ROCKY_EXTRA_URL)'; \
				   DISTRO_LOCAL_APPEND='$(DISTRO_ROCKY_LOCAL_APPEND)'; \
				   DISTRO_LOCAL_GRUB='$(DISTRO_ROCKY_LOCAL_GRUB)'; \
				   DISTRO_LOCAL_URL='$(DISTRO_ROCKY_LOCAL_URL)';


ifeq ($(DISTRO_ROCKY), y)
   GRUB_CFG_INCLUDES		+= src/distros/rocky/grub.d/grub.inc
   DISTRO_ROCKY_CFG		+= src/distros/rocky/grub-header.inc.in

   ifneq ($(DISTRO_ROCKY_8), n)
      DISTRO_ROCKY_CFG		+= src/distros/rocky/grub.d/rocky-8.inc
   endif
   ifeq ($(DISTRO_ROCKY_8), d)
      DISTRO_ROCKY_BOOT		+= boot/rocky/8/BaseOS/x86_64/os/images/pxeboot/initrd.img
      DISTRO_ROCKY_BOOT		+= boot/rocky/8/BaseOS/x86_64/os/images/pxeboot/vmlinuz
   else ifneq ($(DISTRO_ROCKY_8), l)
      DISTRO_ROCKY_8		:= y
   endif

   ifneq ($(DISTRO_ROCKY_9), n)
      DISTRO_ROCKY_CFG		+= src/distros/rocky/grub.d/rocky-9.inc
   endif
   ifeq ($(DISTRO_ROCKY_9), d)
      DISTRO_ROCKY_BOOT		+= boot/rocky/9/BaseOS/x86_64/os/images/pxeboot/initrd.img
      DISTRO_ROCKY_BOOT		+= boot/rocky/9/BaseOS/x86_64/os/images/pxeboot/vmlinuz
   else ifneq ($(DISTRO_ROCKY_9), l)
      DISTRO_ROCKY_9		:= y
   endif

   ifneq ($(DISTRO_ROCKY_10), n)
      DISTRO_ROCKY_CFG		+= src/distros/rocky/grub.d/rocky-10.inc
   endif
   ifeq ($(DISTRO_ROCKY_10), d)
      DISTRO_ROCKY_BOOT		+= boot/rocky/10/BaseOS/x86_64/os/images/pxeboot/initrd.img
      DISTRO_ROCKY_BOOT		+= boot/rocky/10/BaseOS/x86_64/os/images/pxeboot/vmlinuz
   else ifneq ($(DISTRO_ROCKY_10), l)
      DISTRO_ROCKY_10		:= y
   endif

   DISTRO_ROCKY_CFG		+= src/distros/rocky/grub-footer.inc.in
endif
IPERD_DOWNLOADS			+= $(DISTRO_ROCKY_BOOT)


.PHONY: rocky-download


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


#
# Grub include targets
#
src/distros/rocky/grub.d/rocky-8.inc: src/distros/rocky/grub-distro.inc.in
	@$(do_subst_start)
	@$(DISTRO_ROCKY_KEYWORDS) \
		DISTRO_VERSION=8; \
		DISTRO_OPT=$(DISTRO_ROCKY_8); \
		DISTRO_ARCH=x86_64; \
		$(do_subst_finish)


src/distros/rocky/grub.d/rocky-9.inc: src/distros/rocky/grub-distro.inc.in
	@$(do_subst_start)
	@$(DISTRO_ROCKY_KEYWORDS) \
		DISTRO_VERSION=9; \
		DISTRO_OPT=$(DISTRO_ROCKY_9); \
		DISTRO_ARCH=x86_64; \
		$(do_subst_finish)


src/distros/rocky/grub.d/rocky-10.inc: src/distros/rocky/grub-distro.inc.in
	@$(do_subst_start)
	@$(DISTRO_ROCKY_KEYWORDS) \
		DISTRO_VERSION=10; \
		DISTRO_OPT=$(DISTRO_ROCKY_10); \
		DISTRO_ARCH=x86_64; \
		$(do_subst_finish)


src/distros/rocky/grub.d/grub.inc: $(DISTRO_ROCKY_CFG)
	@$(do_subst_files_dt)


#
# IPERD config  targets
#
rocky-defconfig:
	@echo "#"
	@echo "# Rocky Linux"
	@echo "DISTRO_ROCKY=y"
	@echo "DISTRO_ROCKY_URL=https://dl.rockylinux.org/pub/rocky"
	@echo "DISTRO_ROCKY_GRUB=(http,dl.rockylinux.org)/pub/rocky"
	@echo "DISTRO_ROCKY_APPEND="
	@echo "DISTRO_ROCKY_EXTRA_URL="
	@echo "DISTRO_ROCKY_EXTRA_APPEND="
	@echo "DISTRO_ROCKY_LOCAL_URL=https://dl.rockylinux.org/pub/rocky"
	@echo "DISTRO_ROCKY_LOCAL_GRUB=(http,dl.rockylinux.org)/pub/rocky"
	@echo "DISTRO_ROCKY_LOCAL_APPEND="
	@for REL in 8 9 10; do \
	   echo "DISTRO_ROCKY_$${REL}=y"; \
	done;


# end of Makefile.inc
