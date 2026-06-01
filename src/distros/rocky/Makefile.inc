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


DISTRO_ROCKY_INCLUDES	:=


DISTRO_ROCKY			?= n
DISTRO_ROCKY_MIRROR		?= n
DISTRO_ROCKY_RSYNC		?=
DISTRO_ROCKY_URL		?= https://mirrors.edge.kernel.org/rocky
DISTRO_ROCKY_GRUB		?= (http,mirrors.edge.kernel.org)/rocky
DISTRO_ROCKY_8			?= n
DISTRO_ROCKY_9			?= n
DISTRO_ROCKY_10			?= n


ifeq ($(DISTRO_ROCKY), y)
   GRUB_CFG_INCLUDES		+= src/distros/rocky/grub.inc
   DISTRO_ROCKY_INCLUDES	+= src/distros/rocky/grub-header.inc.in

   ifneq ($(DISTRO_ROCKY_8), n)
      DISTRO_ROCKY_INCLUDES	+= src/distros/rocky/grub-rocky-8.inc
   endif

   ifneq ($(DISTRO_ROCKY_9), n)
      DISTRO_ROCKY_INCLUDES	+= src/distros/rocky/grub-rocky-9.inc
   endif

   ifneq ($(DISTRO_ROCKY_10), n)
      DISTRO_ROCKY_INCLUDES	+= src/distros/rocky/grub-rocky-10.inc
   endif

   DISTRO_ROCKY_INCLUDES	+= src/distros/rocky/grub-footer.inc.in
endif


#
# Grub include targets
#
src/distros/rocky/grub-rocky-8.inc: src/distros/rocky/grub-distro.inc.in
	@$(do_subst_start)
	@DISTRO_VERSION=8; DISTRO_ARCH=x86_64; $(do_subst_finish)


src/distros/rocky/grub-rocky-9.inc: src/distros/rocky/grub-distro.inc.in
	@$(do_subst_start)
	@DISTRO_VERSION=9; DISTRO_ARCH=x86_64; $(do_subst_finish)


src/distros/rocky/grub-rocky-10.inc: src/distros/rocky/grub-distro.inc.in
	@$(do_subst_start)
	@DISTRO_VERSION=10; DISTRO_ARCH=x86_64; $(do_subst_finish)


src/distros/rocky/grub.inc: $(DISTRO_ROCKY_INCLUDES)
	@$(do_subst_files_dt)


# end of Makefile.inc
