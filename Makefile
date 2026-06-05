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


V			?= 0
IPERD_NUMJOBS		?= 1


IPERD_ROOT		:= $(dir $(realpath $(lastword $(MAKEFILE_LIST))))


GRUB_SERIAL_COM		?= 1
GRUB_SERIAL_DEV		?= 0
GRUB_SERIAL_BAUD	?= 115200
GRUB_USE_GFXTERM	?= n
GRUB_TERM		?= vt100-color


GRUB_CFG_INCLUDES	=
IPERD_DOWNLOADS		=
IPERD_MIRRORS		=
IPERD_DEFCONFIGS	= alpine \
			  rocky \
			  slackware


IPERD_VERSION		= $(shell git describe --long --abbrev=7 HEAD |sed -e 's/\-/./g' -e 's/^v//g')
DATE			= $(shell date +%Y-%m-%d)


DISTCLEANFILES		= boot \
			  src/*/.iperd \
			  src/distros/*/source
CLEANFILES		= boot/grub \
			  tools \
			  src/*/*.new \
			  src/distros/*/grub.d/


do_subst = sed \
	-e "s;[@]IPERD_PREFIX[@];$(IPERD_PREFIX);g" \
	-e "s;[@]IPERD_NET_PREFIX[@];$(IPERD_NET_PREFIX);g" \
	\
	-e "s,[@]GRUB_SERIAL_COM[@],$(GRUB_SERIAL_COM),g" \
	-e "s,[@]GRUB_SERIAL_DEV[@],$(GRUB_SERIAL_DEV),g" \
	-e "s,[@]GRUB_SERIAL_BAUD[@],$(GRUB_SERIAL_BAUD),g" \
	-e "s,[@]GRUB_USE_GFXTERM[@],$(GRUB_USE_GFXTERM),g" \
	-e "s,[@]GRUB_TERM[@],$(GRUB_TERM),g" \
	\
	-e "s;[@]DISTRO_ARCH[@];$${DISTRO_ARCH};g" \
	-e "s;[@]DISTRO_APPEND[@];$${DISTRO_APPEND};g" \
	-e "s;[@]DISTRO_EXTRA_APPEND[@];$${DISTRO_EXTRA_APPEND};g" \
	-e "s;[@]DISTRO_EXTRA_GRUB[@];$${DISTRO_EXTRA_GRUB};g" \
	-e "s;[@]DISTRO_EXTRA_URL[@];$${DISTRO_EXTRA_URL};g" \
	-e "s;[@]DISTRO_LOCAL_APPEND[@];$${DISTRO_LOCAL_APPEND};g" \
	-e "s;[@]DISTRO_LOCAL_GRUB[@];$${DISTRO_LOCAL_GRUB};g" \
	-e "s;[@]DISTRO_LOCAL_URL[@];$${DISTRO_LOCAL_URL};g" \
	-e "s;[@]DISTRO_VERSION[@];$${DISTRO_VERSION};g" \
	-e "s;[@]DISTRO_GRUB[@];$${DISTRO_GRUB};g" \
	-e "s,[@]DISTRO_SUFFIX[@],$${DISTRO_SUFFIX},g" \
	-e "s;[@]DISTRO_URL[@];$${DISTRO_URL};g" \
	-e "s;[@]DISTRO_OPT[@];$${DISTRO_OPT};g" \
	-e "s;[@]DISTRO_CODENAME[@];$${DISTRO_CODENAME};g" \
	\
	-e "s,[@]DISTRO[@],$${DISTRO},g" \
	-e "s,[@]CODENAME[@],$${DISTRO_CODENAME},g" \
	-e "s,[@]VERSION[@],$${DISTRO_VERSION},g" \
	-e "s,[@]LABEL[@],$${DISTRO_LABEL},g" \
	-e "s,[@]ARCH[@],$${DISTRO_ARCH},g" \
	-e 's,[@]IPERD_VERSION[@],$(IPERD_VERSION),g' \
	-e 's,[@]DATE[@],$(DATE),g' \
	-e 's,[@]NETBOOT[@],$(NETBOOT),g' \
	-e 's,[@]NETBOOT_HOST[@],$(NETBOOT_HOST),g' \
	-e 's,[@]NETBOOT_PATH[@],$(NETBOOT_PATH),g' \
	-e 's,[@]NETBOOT_HTTP[@],$(NETBOOT_HTTP),g' \
	-e 's,[@]NETBOOT_HTTP_SCHEME[@],$(NETBOOT_HTTP_SCHEME),g' \
	-e 's,[@]NETBOOT_HTTP_HOST[@],$(NETBOOT_HTTP_HOST),g' \
	-e 's,[@]NETBOOT_HTTP_PATH[@],$(NETBOOT_HTTP_PATH),g' \
	-e 's,[@]NETBOOT_NFS[@],$(NETBOOT_NFS),g' \
	-e 's,[@]NETBOOT_NFS_HOST[@],$(NETBOOT_NFS_HOST),g' \
	-e 's,[@]NETBOOT_NFS_PATH[@],$(NETBOOT_NFS_PATH),g' \
	-e 's,[@]NETBOOT_TFTP[@],$(NETBOOT_TFTP),g' \
	-e 's,[@]NETBOOT_TFTP_HOST[@],$(NETBOOT_TFTP_HOST),g' \
	-e 's,[@]NETBOOT_TFTP_PATH[@],$(NETBOOT_TFTP_PATH),g' \
	$(SUBST_EXPRESSIONS)


do_subst_start		= if test "x$(V)" == "x0";then \
			     echo "  SED      $(@)"; \
			  else \
			     echo "do_subst $(+) > ${@}"; \
			  fi; \
			  rm -f "$(@)" "$(@).new" || exit 1; \
			  mkdir -p "`dirname "$(@)"`" || exit 1;
do_subst_finish		= $(do_subst) $(+) > "$(@).new" || exit 1; \
			  mv "$(@).new" "$(@)" || exit 1; \
			  touch "$(@)"

do_subst_common		= if test "x$(V)" == "x0";then \
			     echo "  SED      $(@)"; \
			  else \
			     echo "do_subst < ${@}.in > ${@}"; \
			  fi; \
			  rm -f "$(@)" "$(@).new" || exit 1; \
			  mkdir -p "`dirname "$(@)"`" || exit 1; \
			  $(do_subst) < "$(@).in" > "$(@).new" || exit 1; \
			  mv "$(@).new" "$(@)" || exit 1; \
			  touch "$(@)"
do_subst_fn		= $(do_subst_common); chmod 0755 "$(@)"
do_subst_dt		= $(do_subst_common); chmod 0644 "$(@)"


do_subst_files		= if test "x$(V)" == "x0";then \
			     echo "  SED      $(@)"; \
			  else \
			     echo "do_subst $(+) > ${@}"; \
			  fi; \
			  rm -f "$(@)" "$(@).new" || exit 1; \
			  mkdir -p "`dirname "$(@)"`" || exit 1; \
			  $(do_subst) $(+) > "$(@).new" || exit 1; \
			  mv "$(@).new" "$(@)" || exit 1; \
			  touch "$(@)"
do_subst_files_fn	= $(do_subst_files); chmod 0755 "$(@)"
do_subst_files_dt	= $(do_subst_files); chmod 0644 "$(@)"


do_wget			= if test "x$(V)" == "x0";then \
			     echo "  WGET     $${WGET_FILE}"; \
			  else \
			     echo "wget -q -O $${WGET_FILE} $${WGET_URL}"; \
			  fi; \
			  rm -f "$${WGET_FILE}" || exit 1; \
			  wget -q -O "$${WGET_FILE}" "$${WGET_URL}" || exit; \
			  chmod 644 "$${WGET_FILE}" || exit 1; \
			  touch "$${WGET_FILE}"


do_bsdtar		= if test "x$(V)" == "x0";then \
			     echo "  BSDTAR   $${BSDTAR_FILE}"; \
			  else \
			     echo "( cd '$${BSDTAR_DIR}' && bsdtar -xf '$${BSD_PWD}/$${BSDTAR_FILE}'; )"; \
			  fi; \
			  BSD_PWD="$$(pwd)"; \
			  rm -Rf "$${BSDTAR_DIR}" || exit 1; \
			  mkdir -p "$${BSDTAR_DIR}" || exit 1; \
			  ( cd "$${BSDTAR_DIR}" && \
			    bsdtar -xf "$${BSD_PWD}/$${BSDTAR_FILE}" && \
			    chmod -R u+w .; \
			  )


.PHONY: all clean configs configure defconfig distclean grub update images deps


all:
	@echo " "
	@echo "Prepare directory:"
	@echo "   make configure"
	@echo "   make grub"
	@echo "   make download"
	@echo " "
	@echo "Build:"
	@echo "   make images # builds iperdboot.iso and iperdboot.img"
	@echo " "
	@echo "   make images/iperdboot.iso      # UEFI/BIOS hybrid"
	@echo "   make images/iperdboot.bios.iso # BIOS only"
	@echo "   make images/iperdboot.uefi.iso # UEFI only"
	@echo " "
	@echo "   make images/iperdboot.img     DISKSIZE=1900 # GPT/MBR hybrid"
	@echo "   make images/iperdboot.gpt.img DISKSIZE=1900 # GPT only"
	@echo "   make images/iperdboot.mbr.img DISKSIZE=1900 # MBR only"
	@echo " "
	@echo "   make thumbdrive DISK=/dev/sdb PARTTYPE=hybrid PARTSIZE=1900M"
	@echo " "


.config:
	@if test ! -e "$(@)"; then \
	   echo "creating default $(@) ..."; \
	   $(MAKE) -s defconfig > "$(@)"; \
	fi;
	@touch "$(@)"


-include .config
include src/dejavu/Makefile.inc
include src/unifont/Makefile.inc
include src/grub/Makefile.inc
include src/themes/Makefile.inc
include src/grubnet/Makefile.inc
ifeq ($(DISTRO_ALPINE), y)
   include src/distros/alpine/Makefile.inc
endif
ifeq ($(DISTRO_ROCKY), y)
   include src/distros/rocky/Makefile.inc
endif
ifeq ($(DISTRO_SLACKWARE), y)
   include src/distros/slackware/Makefile.inc
endif
include src/grubcfg/Makefile.inc


defconfig:
	@echo "#"
	@echo "# IP Engineering Rescue Disk Configuration"
	@echo "#"
	@echo "# GRUB options"
	@echo "GRUB_SERIAL_COM=1"
	@echo "GRUB_SERIAL_DEV=0"
	@echo "GRUB_SERIAL_BAUD=115200"
	@echo "GRUB_USE_GFXTERM=n"
	@echo "GRUB_TERM=vt100-color"
	@echo "#"
	@echo "# IPERD"
	@echo "IPERD_PREFIX="
	@echo "IPERD_NET_PREFIX=/httpboot"
	@for CFG in $(IPERD_DEFCONFIGS); do \
	   $(MAKE) -s -f  src/distros/$${CFG}/Makefile.inc $${CFG}-defconfig; \
	done
	@echo "#"
	@echo "# end of config"


download: $(IPERD_DOWNLOADS)


update: src/grubnet/.iperd src/grubcfg/.iperd $(IPERD_DOWNLOADS)


clean:
	rm -Rf $(CLEANFILES)


distclean: clean
	rm -Rf $(DISTCLEANFILES)


# end of makefile
