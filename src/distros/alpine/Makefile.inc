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


DISTRO_ALPINE_INCLUDES	:=


DISTRO_ALPINE			?= n
DISTRO_ALPINE_MIRROR		?= n
DISTRO_ALPINE_RSYNC		?=
DISTRO_ALPINE_URL		?= https://mirrors.edge.kernel.org/alpine
DISTRO_ALPINE_GRUB		?= (http,mirrors.edge.kernel.org)/alpine
DISTRO_ALPINE_318_x86		?= n
DISTRO_ALPINE_319_x86		?= n
DISTRO_ALPINE_320_x86		?= n
DISTRO_ALPINE_321_x86		?= n
DISTRO_ALPINE_322_x86		?= n
DISTRO_ALPINE_323_x86		?= n
DISTRO_ALPINE_318_x8664		?= n
DISTRO_ALPINE_319_x8664		?= n
DISTRO_ALPINE_320_x8664		?= n
DISTRO_ALPINE_321_x8664		?= n
DISTRO_ALPINE_322_x8664		?= n
DISTRO_ALPINE_323_x8664		?= n


ifeq ($(DISTRO_ALPINE), y)
   GRUB_CFG_INCLUDES		+= src/distros/alpine/grub.inc
   DISTRO_ALPINE_INCLUDES	+= src/distros/alpine/grub-header.inc.in

   ifneq ($(DISTRO_ALPINE_318_x86), n)
      DISTRO_ALPINE_INCLUDES	+= src/distros/alpine/grub-alpine-3.18-x86.inc
   endif
   ifneq ($(DISTRO_ALPINE_318_x8664), n)
      DISTRO_ALPINE_INCLUDES	+= src/distros/alpine/grub-alpine-3.18-x86_64.inc
   endif

   ifneq ($(DISTRO_ALPINE_319_x86), n)
      DISTRO_ALPINE_INCLUDES	+= src/distros/alpine/grub-alpine-3.19-x86.inc
   endif
   ifneq ($(DISTRO_ALPINE_319_x8664), n)
      DISTRO_ALPINE_INCLUDES	+= src/distros/alpine/grub-alpine-3.19-x86_64.inc
   endif

   ifneq ($(DISTRO_ALPINE_320_x86), n)
      DISTRO_ALPINE_INCLUDES	+= src/distros/alpine/grub-alpine-3.20-x86.inc
   endif
   ifneq ($(DISTRO_ALPINE_320_x8664), n)
      DISTRO_ALPINE_INCLUDES	+= src/distros/alpine/grub-alpine-3.20-x86_64.inc
   endif

   ifneq ($(DISTRO_ALPINE_321_x86), n)
      DISTRO_ALPINE_INCLUDES	+= src/distros/alpine/grub-alpine-3.21-x86.inc
   endif
   ifneq ($(DISTRO_ALPINE_321_x8664), n)
      DISTRO_ALPINE_INCLUDES	+= src/distros/alpine/grub-alpine-3.21-x86_64.inc
   endif

   ifneq ($(DISTRO_ALPINE_322_x86), n)
      DISTRO_ALPINE_INCLUDES	+= src/distros/alpine/grub-alpine-3.22-x86.inc
   endif
   ifneq ($(DISTRO_ALPINE_322_x8664), n)
      DISTRO_ALPINE_INCLUDES	+= src/distros/alpine/grub-alpine-3.22-x86_64.inc
   endif

   ifneq ($(DISTRO_ALPINE_323_x86), n)
      DISTRO_ALPINE_INCLUDES	+= src/distros/alpine/grub-alpine-3.23-x86.inc
   endif
   ifneq ($(DISTRO_ALPINE_323_x8664), n)
      DISTRO_ALPINE_INCLUDES	+= src/distros/alpine/grub-alpine-3.23-x86_64.inc
   endif

   ifneq ($(DISTRO_ALPINE_324_x86), n)
      DISTRO_ALPINE_INCLUDES	+= src/distros/alpine/grub-alpine-3.24-x86.inc
   endif
   ifneq ($(DISTRO_ALPINE_324_x8664), n)
      DISTRO_ALPINE_INCLUDES	+= src/distros/alpine/grub-alpine-3.24-x86_64.inc
   endif

   DISTRO_ALPINE_INCLUDES	+= src/distros/alpine/grub-footer.inc.in
endif


#
# Grub include targets
#
src/distros/alpine/grub-alpine-3.18-x86.inc: src/distros/alpine/grub-distro.inc.in
	@$(do_subst_start)
	@DISTRO_VERSION=3.18; DISTRO_ARCH=x86; $(do_subst_finish)


src/distros/alpine/grub-alpine-3.18-x86_64.inc: src/distros/alpine/grub-distro.inc.in
	@$(do_subst_start)
	@DISTRO_VERSION=3.18; DISTRO_ARCH=x86_64; $(do_subst_finish)


src/distros/alpine/grub-alpine-3.19-x86.inc: src/distros/alpine/grub-distro.inc.in
	@$(do_subst_start)
	@DISTRO_VERSION=3.19; DISTRO_ARCH=x86; $(do_subst_finish)


src/distros/alpine/grub-alpine-3.19-x86_64.inc: src/distros/alpine/grub-distro.inc.in
	@$(do_subst_start)
	@DISTRO_VERSION=3.19; DISTRO_ARCH=x86_64; $(do_subst_finish)


src/distros/alpine/grub-alpine-3.20-x86.inc: src/distros/alpine/grub-distro.inc.in
	@$(do_subst_start)
	@DISTRO_VERSION=3.20; DISTRO_ARCH=x86; $(do_subst_finish)


src/distros/alpine/grub-alpine-3.20-x86_64.inc: src/distros/alpine/grub-distro.inc.in
	@$(do_subst_start)
	@DISTRO_VERSION=3.20; DISTRO_ARCH=x86_64; $(do_subst_finish)


src/distros/alpine/grub-alpine-3.21-x86.inc: src/distros/alpine/grub-distro.inc.in
	@$(do_subst_start)
	@DISTRO_VERSION=3.21; DISTRO_ARCH=x86; $(do_subst_finish)


src/distros/alpine/grub-alpine-3.21-x86_64.inc: src/distros/alpine/grub-distro.inc.in
	@$(do_subst_start)
	@DISTRO_VERSION=3.21; DISTRO_ARCH=x86_64; $(do_subst_finish)


src/distros/alpine/grub-alpine-3.22-x86.inc: src/distros/alpine/grub-distro.inc.in
	@$(do_subst_start)
	@DISTRO_VERSION=3.22; DISTRO_ARCH=x86; $(do_subst_finish)


src/distros/alpine/grub-alpine-3.22-x86_64.inc: src/distros/alpine/grub-distro.inc.in
	@$(do_subst_start)
	@DISTRO_VERSION=3.22; DISTRO_ARCH=x86_64; $(do_subst_finish)


src/distros/alpine/grub-alpine-3.23-x86.inc: src/distros/alpine/grub-distro.inc.in
	@$(do_subst_start)
	@DISTRO_VERSION=3.23; DISTRO_ARCH=x86; $(do_subst_finish)


src/distros/alpine/grub-alpine-3.23-x86_64.inc: src/distros/alpine/grub-distro.inc.in
	@$(do_subst_start)
	@DISTRO_VERSION=3.23; DISTRO_ARCH=x86_64; $(do_subst_finish)


src/distros/alpine/grub-alpine-3.24-x86.inc: src/distros/alpine/grub-distro.inc.in
	@$(do_subst_start)
	@DISTRO_VERSION=3.24; DISTRO_ARCH=x86; $(do_subst_finish)


src/distros/alpine/grub-alpine-3.24-x86_64.inc: src/distros/alpine/grub-distro.inc.in
	@$(do_subst_start)
	@DISTRO_VERSION=3.24; DISTRO_ARCH=x86_64; $(do_subst_finish)


src/distros/alpine/grub.inc: $(DISTRO_ALPINE_INCLUDES)
	@$(do_subst_files_dt)


# end of Makefile.inc
