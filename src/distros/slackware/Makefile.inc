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


DISTRO_SLACKWARE		?= n
DISTRO_SLACKWARE_MIRROR		?= n
DISTRO_SLACKWARE_URL		?= https://mirrors.edge.kernel.org/slackware
DISTRO_SLACKWARE_GRUB		?= (http,mirrors.edge.kernel.org)/slackware
DISTRO_SLACKWARE_APPEND		?= SLACK_KERNEL=hugesmp.s
DISTRO_SLACKWARE_LOCAL_URL	?= https://mirrors.edge.kernel.org/slackware
DISTRO_SLACKWARE_LOCAL_GRUB	?= (http,mirrors.edge.kernel.org)/slackware
DISTRO_SLACKWARE_LOCAL_APPEND	?= SLACK_KERNEL=hugesmp.s
DISTRO_SLACKWARE_140		?= n
DISTRO_SLACKWARE_141		?= n
DISTRO_SLACKWARE_142		?= n
DISTRO_SLACKWARE_150		?= n
DISTRO_SLACKWARE64_140		?= n
DISTRO_SLACKWARE64_141		?= n
DISTRO_SLACKWARE64_142		?= n
DISTRO_SLACKWARE64_150		?= n


DISTRO_SLACKWARE_KEYWORDS	:= DISTRO_APPEND='$(DISTRO_SLACKWARE_APPEND)'; \
				   DISTRO_GRUB='$(DISTRO_SLACKWARE_GRUB)'; \
				   DISTRO_URL='$(DISTRO_SLACKWARE_URL)'; \
				   DISTRO_LOCAL_APPEND='$(DISTRO_SLACKWARE_LOCAL_APPEND)'; \
				   DISTRO_LOCAL_GRUB='$(DISTRO_SLACKWARE_LOCAL_GRUB)'; \
				   DISTRO_LOCAL_URL='$(DISTRO_SLACKWARE_LOCAL_URL)';


ifeq ($(DISTRO_SLACKWARE), y)
   GRUB_CFG_INCLUDES		+= src/distros/slackware/grub.d/grub.inc
   IPERD_DOWNLOADS		+= slackware-download
   DISTRO_SLACKWARE_CFG		+= src/distros/slackware/grub-header.inc.in

   ifneq ($(DISTRO_SLACKWARE_140), n)
      DISTRO_SLACKWARE_CFG	+= src/distros/slackware/grub.d/slackware-14.0.inc
   endif
   ifeq ($(DISTRO_SLACKWARE_140), d)
      DISTRO_SLACKWARE_BOOT	+= boot/slackware/slackware-14.0/isolinux/initrd.img
      DISTRO_SLACKWARE_BOOT	+= boot/slackware/slackware-14.0/kernels/huge.s/bzImage
   else ifneq ($(DISTRO_SLACKWARE_140), l)
      DISTRO_SLACKWARE_140	:= y
   endif

   ifneq ($(DISTRO_SLACKWARE_141), n)
      DISTRO_SLACKWARE_CFG	+= src/distros/slackware/grub.d/slackware-14.1.inc
   endif
   ifeq ($(DISTRO_SLACKWARE_141), d)
      DISTRO_SLACKWARE_BOOT	+= boot/slackware/slackware-14.1/isolinux/initrd.img
      DISTRO_SLACKWARE_BOOT	+= boot/slackware/slackware-14.1/kernels/huge.s/bzImage
   else ifneq ($(DISTRO_SLACKWARE_141), l)
      DISTRO_SLACKWARE_141	:= y
   endif

   ifneq ($(DISTRO_SLACKWARE_142), n)
      DISTRO_SLACKWARE_CFG	+= src/distros/slackware/grub.d/slackware-14.2.inc
   endif
   ifeq ($(DISTRO_SLACKWARE_142), d)
      DISTRO_SLACKWARE_BOOT	+= boot/slackware/slackware-14.2/isolinux/initrd.img
      DISTRO_SLACKWARE_BOOT	+= boot/slackware/slackware-14.2/kernels/huge.s/bzImage
   else ifneq ($(DISTRO_SLACKWARE_142), l)
      DISTRO_SLACKWARE_142	:= y
   endif

   ifneq ($(DISTRO_SLACKWARE_150), n)
      DISTRO_SLACKWARE_CFG	+= src/distros/slackware/grub.d/slackware-15.0.inc
   endif
   ifeq ($(DISTRO_SLACKWARE_150), d)
      DISTRO_SLACKWARE_BOOT	+= boot/slackware/slackware-15.0/isolinux/initrd.img
      DISTRO_SLACKWARE_BOOT	+= boot/slackware/slackware-15.0/kernels/huge.s/bzImage
   else ifneq ($(DISTRO_SLACKWARE_150), l)
      DISTRO_SLACKWARE_150	:= y
   endif

   ifneq ($(DISTRO_SLACKWARE64_140), n)
      DISTRO_SLACKWARE_CFG	+= src/distros/slackware/grub.d/slackware64-14.0.inc
   endif
   ifeq ($(DISTRO_SLACKWARE64_140), d)
      DISTRO_SLACKWARE_BOOT	+= boot/slackware/slackware64-14.0/isolinux/initrd.img
      DISTRO_SLACKWARE_BOOT	+= boot/slackware/slackware64-14.0/kernels/huge.s/bzImage
   else ifneq ($(DISTRO_SLACKWARE64_140), l)
      DISTRO_SLACKWARE64_140	:= y
   endif

   ifneq ($(DISTRO_SLACKWARE64_141), n)
      DISTRO_SLACKWARE_CFG	+= src/distros/slackware/grub.d/slackware64-14.1.inc
   endif
   ifeq ($(DISTRO_SLACKWARE64_141), d)
      DISTRO_SLACKWARE_BOOT	+= boot/slackware/slackware64-14.1/isolinux/initrd.img
      DISTRO_SLACKWARE_BOOT	+= boot/slackware/slackware64-14.1/kernels/huge.s/bzImage
   else ifneq ($(DISTRO_SLACKWARE64_141), l)
      DISTRO_SLACKWARE64_141	:= y
   endif

   ifneq ($(DISTRO_SLACKWARE64_142), n)
      DISTRO_SLACKWARE_CFG	+= src/distros/slackware/grub.d/slackware64-14.2.inc
   endif
   ifeq ($(DISTRO_SLACKWARE64_142), d)
      DISTRO_SLACKWARE_BOOT	+= boot/slackware/slackware64-14.2/isolinux/initrd.img
      DISTRO_SLACKWARE_BOOT	+= boot/slackware/slackware64-14.2/kernels/huge.s/bzImage
   else ifneq ($(DISTRO_SLACKWARE64_142), l)
      DISTRO_SLACKWARE64_142	:= y
   endif

   ifneq ($(DISTRO_SLACKWARE64_150), n)
      DISTRO_SLACKWARE_CFG	+= src/distros/slackware/grub.d/slackware64-15.0.inc
   endif
   ifeq ($(DISTRO_SLACKWARE64_150), d)
      DISTRO_SLACKWARE_BOOT	+= boot/slackware/slackware64-15.0/isolinux/initrd.img
      DISTRO_SLACKWARE_BOOT	+= boot/slackware/slackware64-15.0/kernels/huge.s/bzImage
   else ifneq ($(DISTRO_SLACKWARE64_150), l)
      DISTRO_SLACKWARE64_150	:= y
   endif

   DISTRO_SLACKWARE_CFG	+= src/distros/slackware/grub-footer.inc.in
endif


.PHONY: slackware-download


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


#
# Grub include targets
#
src/distros/slackware/grub.d/slackware-14.0.inc: src/distros/slackware/grub-distro.inc.in
	@$(do_subst_start)
	@$(DISTRO_SLACKWARE_KEYWORDS) \
		DISTRO_VERSION=14.0; \
		DISTRO_OPT=$(DISTRO_SLACKWARE_140); \
		DISTRO_ARCH=x86; \
		DISTRO_SUFFIX=; \
		$(do_subst_finish)


src/distros/slackware/grub.d/slackware64-14.0.inc: src/distros/slackware/grub-distro.inc.in
	@$(do_subst_start)
	@$(DISTRO_SLACKWARE_KEYWORDS) \
		DISTRO_VERSION=14.0; \
		DISTRO_OPT=$(DISTRO_SLACKWARE64_140); \
		DISTRO_ARCH=x86_64; \
		DISTRO_SUFFIX=64; \
		$(do_subst_finish)


src/distros/slackware/grub.d/slackware-14.1.inc: src/distros/slackware/grub-distro.inc.in
	@$(do_subst_start)
	@$(DISTRO_SLACKWARE_KEYWORDS) \
		DISTRO_VERSION=14.1; \
		DISTRO_OPT=$(DISTRO_SLACKWARE_141); \
		DISTRO_ARCH=x86; \
		DISTRO_SUFFIX=; \
		$(do_subst_finish)


src/distros/slackware/grub.d/slackware64-14.1.inc: src/distros/slackware/grub-distro.inc.in
	@$(do_subst_start)
	@$(DISTRO_SLACKWARE_KEYWORDS) \
		DISTRO_VERSION=14.1; \
		DISTRO_OPT=$(DISTRO_SLACKWARE64_141); \
		DISTRO_ARCH=x86_64; \
		DISTRO_SUFFIX=64; \
		$(do_subst_finish)


src/distros/slackware/grub.d/slackware-14.2.inc: src/distros/slackware/grub-distro.inc.in
	@$(do_subst_start)
	@$(DISTRO_SLACKWARE_KEYWORDS) \
		DISTRO_VERSION=14.2; \
		DISTRO_OPT=$(DISTRO_SLACKWARE_142); \
		DISTRO_ARCH=x86; \
		DISTRO_SUFFIX=; \
		$(do_subst_finish)


src/distros/slackware/grub.d/slackware64-14.2.inc: src/distros/slackware/grub-distro.inc.in
	@$(do_subst_start)
	@$(DISTRO_SLACKWARE_KEYWORDS) \
		DISTRO_VERSION=14.2; \
		DISTRO_OPT=$(DISTRO_SLACKWARE64_142); \
		DISTRO_ARCH=x86_64; \
		DISTRO_SUFFIX=64; \
		$(do_subst_finish)


src/distros/slackware/grub.d/slackware-15.0.inc: src/distros/slackware/grub-distro.inc.in
	@$(do_subst_start)
	@$(DISTRO_SLACKWARE_KEYWORDS) \
		DISTRO_VERSION=15.0; \
		DISTRO_OPT=$(DISTRO_SLACKWARE_150); \
		DISTRO_ARCH=x86; \
		DISTRO_SUFFIX=; \
		$(do_subst_finish)


src/distros/slackware/grub.d/slackware64-15.0.inc: src/distros/slackware/grub-distro.inc.in
	@$(do_subst_start)
	@$(DISTRO_SLACKWARE_KEYWORDS) \
		DISTRO_VERSION=15.0; \
		DISTRO_OPT=$(DISTRO_SLACKWARE64_150); \
		DISTRO_ARCH=x86_64; \
		DISTRO_SUFFIX=64; \
		$(do_subst_finish)


src/distros/slackware/grub.d/grub.inc: $(DISTRO_SLACKWARE_CFG)
	@$(do_subst_files_dt)


#
# IPERD config  targets
#
slackware-defconfig:
	@echo "#"
	@echo "# Slackware Linux"
	@echo "DISTRO_SLACKWARE=y"
	@echo "DISTRO_SLACKWARE_URL=https://mirrors.edge.kernel.org/slackware"
	@echo "DISTRO_SLACKWARE_GRUB=(http,mirrors.edge.kernel.org)/slackware"
	@echo "DISTRO_SLACKWARE_APPEND="
	@echo "DISTRO_SLACKWARE_LOCAL_URL=https://mirrors.edge.kernel.org/slackware"
	@echo "DISTRO_SLACKWARE_LOCAL_GRUB=(http,mirrors.edge.kernel.org)/slackware"
	@echo "DISTRO_SLACKWARE_LOCAL_APPEND="
	@for REL in 140 141 142 150; do \
	   echo "DISTRO_SLACKWARE_$${REL}=y"; \
	   echo "DISTRO_SLACKWARE64_$${REL}=y"; \
	done;


# end of Makefile.inc
