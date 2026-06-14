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
NUMJOBS			?= 1
DATE			:= $(shell date +%Y-%m-%d)


DISTCLEANFILES		= boot \
			  var
CLEANFILES		= *.iso *.tar.xz \
			  boot/grub \
			  tools \
			  var/*/*.new \
			  var/distros/*/*.inc


GRUB_RUNTIME_SETUP	?= n
GRUB_RUNTIME_NOTICE	?= n
GRUB_SERIAL_DEV		?= 0
GRUB_SERIAL_BAUD	?= 115200
GRUB_USE_GFXTERM	?= n
GRUB_TERM		?= vt100-color
GRUB_TERM_GEOMETRY	?= 80x24
GRUB_CFG_INCLUDES	=


LINUX_CONSOLE		?= tty0


IPERD_GIT_URL		?= https://github.com/syzdek/iperd.git
IPERD_ROOT		:= $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
IPERD_DOWNLOADS		:=
IPERD_MIRRORS		:=
IPERD_PRUNE		:=
IPERD_DEFCONFIGS	:= alpine \
			   debian \
			   fedora \
			   rocky \
			   slackware \
			   ubuntu
IPERD_DEPS		:= boot/grub/.iperd \
			   boot/grub/grub.cfg \
			   VERSION.md \
			   $(IPERD_DOWNLOADS)
IPERD_GIT_REF		:= $(shell git rev-parse --abbrev-ref HEAD 2> /dev/null)
IPERD_VERSION_DEPS	:=
ifdef IPERD_GIT_REF
   IPERD_VERSION_DEPS	:= .git/refs/heads/$(IPERD_GIT_REF)
endif


do_subst = sed \
	-e 's,[@]IPERD_DATE[@],$(IPERD_DATE),g' \
	-e 's,[@]IPERD_VERSION[@],$(IPERD_VERSION),g' \
	-e "s;[@]IPERD_PREFIX[@];$(IPERD_PREFIX);g" \
	-e "s;[@]IPERD_NET_PREFIX[@];$(IPERD_NET_PREFIX);g" \
	\
	-e "s;[@]LINUX_CONSOLE[@];$(LINUX_CONSOLE);g" \
	\
	-e "s,[@]GRUB_RUNTIME_SETUP[@],$(GRUB_RUNTIME_SETUP),g" \
	-e "s,[@]GRUB_RUNTIME_NOTICE[@],$(GRUB_RUNTIME_NOTICE),g" \
	-e "s,[@]GRUB_SERIAL_DEV[@],$(GRUB_SERIAL_DEV),g" \
	-e "s,[@]GRUB_SERIAL_BAUD[@],$(GRUB_SERIAL_BAUD),g" \
	-e "s,[@]GRUB_USE_GFXTERM[@],$(GRUB_USE_GFXTERM),g" \
	-e "s,[@]GRUB_TERM[@],$(GRUB_TERM),g" \
	-e "s,[@]GRUB_TERM_GEOMETRY[@],$(GRUB_TERM_GEOMETRY),g" \
	-e "s,[@]GRUB_VERSION[@],$(GRUB_VERSION),g" \
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
	-e 's,[@]DATE[@],$(DATE),g' \
	\
	$(SUBST_EXPRESSIONS)


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


do_subst_file		= if test "x$(V)" == "x0";then \
			     echo "  SED      $(@)"; \
			  else \
			     echo "do_subst $(<) > ${@}"; \
			  fi; \
			  rm -f "$(@)" "$(@).new" || exit 1; \
			  mkdir -p "`dirname "$(@)"`" || exit 1; \
			  $(do_subst) $(<) > "$(@).new" || exit 1; \
			  mv "$(@).new" "$(@)" || exit 1; \
			  touch "$(@)"
do_subst_file_fn	= $(do_subst_file); chmod 0755 "$(@)"
do_subst_file_dt	= $(do_subst_file); chmod 0644 "$(@)"


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


do_gzip			= if test "x$(V)" == "x0";then \
			     echo "  GZIP     $${GZIP_FILE}"; \
			  else \
			     echo "gzip -cd '$${GZIP_FILE}' > '$${GZIP_DST}'"; \
			  fi; \
			  rm -f "$${GZIP_DST}" "$${GZIP_DST}.new" || exit 1; \
			  gzip -cd "$${GZIP_FILE}" > "$${GZIP_DST}.new" \
			     || exit 1; \
			  mv "$${GZIP_DST}.new" "$${GZIP_DST}" || exit 1


do_wget			= if test "x$(V)" == "x0";then \
			     echo "  WGET     $${WGET_FILE}"; \
			  else \
			     echo "wget -q -O $${WGET_FILE} $${WGET_URL}"; \
			  fi; \
			  rm -f "$${WGET_FILE}" "$${WGET_FILE}.new" || exit 1; \
			  wget -q \
			     -O "$${WGET_FILE}.new" \
			     "$${WGET_URL}" \
			     || exit; \
			  chmod 644 "$${WGET_FILE}.new" || exit 1; \
			  if test ! -z "$${WGET_SHA1}"; then \
			     echo "$${WGET_SHA1}" "$${WGET_FILE}.new" \
			        |sha1sum   --check > /dev/null || exit 1; \
			  fi; \
			  if test ! -z "$${WGET_SHA256}"; then \
			     echo "$${WGET_SHA256}" "$${WGET_FILE}.new" \
			        |sha256sum   --check > /dev/null || exit 1; \
			  fi; \
			  if test ! -z "$${WGET_SHA512}"; then \
			     echo "$${WGET_SHA512}" "$${WGET_FILE}.new" \
			        |sha512sum   --check > /dev/null || exit 1; \
			  fi; \
			  mv "$${WGET_FILE}.new" "$${WGET_FILE}" || exit 1; \
			  touch "$${WGET_FILE}"


do_bsdtar		= BSD_PWD="$$(pwd)"; \
			  if test "x$(V)" == "x0";then \
			     echo "  BSDTAR   $${BSDTAR_FILE}"; \
			  else \
			     echo "( cd '$${BSDTAR_DIR}' &&"; \
			     echo "  bsdtar -xf '$${BSDTAR_FILE}'; )"; \
			  fi; \
			  rm -Rf "$${BSDTAR_DIR}" || exit 1; \
			  mkdir -p "$${BSDTAR_DIR}" || exit 1; \
			  ( cd "$${BSDTAR_DIR}" && \
			    bsdtar -xf "$${BSD_PWD}/$${BSDTAR_FILE}" && \
			    chmod -R u+w .; \
			  )


do_chmod		= if test "x$(V)" == "x0";then \
			     echo "  CHMOD    $${CHMOD_DIR}"; \
			  else \
			     echo "find '$${CHMOD_DIR}' \\"; \
			     echo "     -exec chmod u+w  {} \\;"; \
			  fi; \
			  find "$${CHMOD_DIR}" \
			       -exec chmod u+w  {} \; \
			       || exit 1; \
			  if test "x$(V)" != "x0";then \
			     echo "find '$${CHMOD_DIR}' \\"; \
			     echo "     -type f \\"; \
			     echo "     -exec chmod ugo+r  {} \\;"; \
			  fi; \
			  find "$${CHMOD_DIR}" \
			       -type f \
			       -exec chmod ugo+r  {} \; \
			       || exit 1; \
			  if test "x$(V)" != "x0";then \
			     echo "find '$${CHMOD_DIR}' \\"; \
			     echo "     -type d \\"; \
			     echo "     -exec chmod ugo+rx  {} \\;"; \
			  fi; \
			  find "$${CHMOD_DIR}" \
			       -type d \
			       -exec chmod ugo+rx {} \; \
			       || exit 1


do_patch		= if test "x$(V)" == "x0";then \
			     echo "  PATCH    $${PATCH_FILE}"; \
			  else \
			     echo "( cd '$${PATCH_DIR}' &&"; \
			     echo "  patch -p1 < '$${PATCH_FILE}' )"; \
			  fi; \
			  ( cd "$${PATCH_DIR}" && \
			    patch -p1 < "$${PATCH_FILE}" > /dev/null )


do_tar			= if test "x$(V)" == "x0";then \
			     echo "  TAR      $${TAR_FILE}"; \
			  else \
			     echo "tar -C '$${TAR_DIR}' \\"; \
			     echo "    -xf '$${TAR_FILE}' \\"; \
			     echo "    --strip-components=1"; \
			  fi; \
			  rm -Rf "$${TAR_DIR}" || exit 1; \
			  mkdir -p "$${TAR_DIR}" || exit 1; \
			  tar -C "$${TAR_DIR}" \
			      -xf "$${TAR_FILE}" \
			      --strip-components=1 \
			     || exit 1


.PHONY: all clean configure defconfig distclean dist-all dist-iso download selfupdate update prune


all:
	@echo " "
	@echo "   IP Engineering Rescue Disk ($(IPERD_VERSION)) [$(IPERD_DATE)]"
	@echo " "
	@echo "   make selfupdate   # update source and build rules"
	@echo " "
	@echo "   make download     # download boot images"
	@echo "   make update       # update configurations and boot images"
	@echo " "
	@echo "   make prune        # clean non-essential files"
	@echo "   make clean        # remove generated files"
	@echo "   make distclean    # remove generated and downloaded files"
	@echo " "
	@echo "   make dist         # build archive using config"
	@echo "   make dist-iso     # build ISO image using config"
	@echo "   make dist-all     # build ISO and archive"
	@echo " "


defconfig:
	@echo "#"
	@echo "# IP Engineering Rescue Disk Configuration"
	@echo "#"
	@echo "# GRUB options"
	@echo "GRUB_RUNTIME_SETUP=y"
	@echo "GRUB_RUNTIME_NOTICE=y"
	@echo "GRUB_SERIAL_DEV=0"
	@echo "GRUB_SERIAL_BAUD=115200"
	@echo "GRUB_USE_GFXTERM=n"
	@echo "GRUB_TERM=vt100"
	@echo "GRUB_TERM_GEOMETRY=80x24"
	@echo "#"
	@echo "# Linux kernel options"
	@echo "LINUX_CONSOLE=tty0"
	@echo "#"
	@echo "# IPERD"
	@echo "IPERD_PREFIX="
	@echo "IPERD_NET_PREFIX=/httpboot"
	@for CFG in $(IPERD_DEFCONFIGS); do \
	   $(MAKE) -s \
	           -f src/distros/$${CFG}/Makefile.inc \
	           IPERD_DEFCONFIG="$(IPERD_DEFCONFIG)" \
	           $${CFG}-defconfig; \
	done
	@echo "#"
	@echo "# end of config"


.config:
	@if test ! -e "$(@)"; then \
	   echo "  CONF     $(@)"; \
	   $(MAKE) -s defconfig IPERD_DEFCONFIG=1 > "$(@)"; \
	fi;
	@touch "$(@)"


.version: $(IPERD_VERSION_DEPS)
	@rm -f "$(@)"
	@echo "IPERD_VERSION=$(shell git describe --long --abbrev=7 |sed -e 's/^v//g' -e 's/-/./g' )" > "$(@)"
	@echo "IPERD_DATE=$(shell git log -1 --format=%cs )" >> "$(@)"
	@touch "$(@)"


-include .config
-include .version
include src/dejavu/Makefile.inc
include src/unifont/Makefile.inc
include src/grub/Makefile.inc
include src/themes/Makefile.inc
include src/netdir/Makefile.inc
ifeq ($(DISTRO_ALPINE), y)
   include src/distros/alpine/Makefile.inc
endif
ifeq ($(DISTRO_DEBIAN), y)
   include src/distros/debian/Makefile.inc
endif
ifeq ($(DISTRO_FEDORA), y)
   include src/distros/fedora/Makefile.inc
endif
ifeq ($(DISTRO_ROCKY), y)
   include src/distros/rocky/Makefile.inc
endif
ifeq ($(DISTRO_SLACKWARE), y)
   include src/distros/slackware/Makefile.inc
endif
ifeq ($(DISTRO_UBUNTU), y)
   include src/distros/ubuntu/Makefile.inc
endif
include src/cfg/Makefile.inc


VERSION.md: $(IPERD_VERSION_DEPS)
	@echo "  GEN      $(@)"
	@rm -f "$(@)"
	@head -4 COPYING.md >> "$(@)"
	@echo "IPERD:         $(IPERD_VERSION) ($(IPERD_DATE))  " >> "$(@)"
	@echo "Generated On:  $(DATE)"  >> "$(@)"
	@echo "" >> "$(@)"
	@echo "GNU GRUB:      $(GRUB_VERSION)  " >> "$(@)"
	@echo "GNU Unifont:   $(UNIFONT_VERSION)  " >> "$(@)"
	@echo "DejaVu Fonts:  $(DEJAVU_VERSION)  " >> "$(@)"
	@echo "" >> "$(@)"


iperd-$(IPERD_VERSION).iso: Makefile .config .version $(IPERD_DEPS) $(IPERD_DOWNLOADS)
	@rm -f "$(@)"
	./tools/bin/grub-mkrescue \
	   --compress=xz  \
	   --core-compress=xz \
	   -o "$(@).new" \
	   -m '*.new' \
	   -m '*.swp' \
	   -m '.git' \
	   -m '.iperd' \
	   -m '.makefile.d' \
	   -m 'iperd-*/' \
	   -m 'iperd-*.iso' \
	   -m 'iperd-*.tar' \
	   -m 'iperd-*.tar.new.xz' \
	   -m 'iperd-*.tar.xz' \
	   -m 'tools/' \
	   -m 'var/distros/' \
	   -m 'var/*/source/' \
	   -volid IPERD \
	   -publisher "IP Engineering Rescue Disk (iperd.org)" \
	   ./
	@mv "$(@).new" "$(@)"
	@touch "$(@)"


iperd-$(IPERD_VERSION).tar.xz: Makefile .config .version $(IPERD_DEPS) $(IPERD_DOWNLOADS)
	@rm -f "$(@)" 'iperd-*.tar.new*'
	tar -c \
	   -f iperd-$(IPERD_VERSION).tar.new \
	   --transform='flags=r;s|^.|iperd-$(IPERD_VERSION)|g' \
	   --exclude='*.new' \
	   --exclude='*.swp' \
	   --exclude='.git' \
	   --exclude='.iperd' \
	   --exclude='.makefile.d' \
	   --exclude='iperd-*' \
	   --exclude='iperd-*.iso' \
	   --exclude='iperd-*.tar' \
	   --exclude='iperd-*.tar.new.xz' \
	   --exclude='iperd-*.tar.xz' \
	   --exclude='tools' \
	   --exclude='var/distros' \
	   --exclude='var/*/source' \
	   .
	xz --threads=0 -z iperd-$(IPERD_VERSION).tar.new
	@mv "iperd-$(IPERD_VERSION).tar.new.xz" "$(@)"
	@touch "$(@)"


dist: iperd-$(IPERD_VERSION).tar.xz


dist-xz: iperd-$(IPERD_VERSION).tar.xz


dist-iso: iperd-$(IPERD_VERSION).iso


dist-all: iperd-$(IPERD_VERSION).iso iperd-$(IPERD_VERSION).tar.xz


download: $(IPERD_DOWNLOADS)


update: $(IPERD_DEPS) $(IPERD_DOWNLOADS)


clean:
	rm -Rf $(CLEANFILES)


distclean: clean
	rm -Rf $(DISTCLEANFILES)


prune: $(IPERD_PRUNE)


selfupdate:
	if test ! -e .git; then \
	   rm -Rf iperd-git.new || exit 1; \
	   git clone \
	      --no-checkout \
	      $(IPERD_GIT_URL) \
	      iperd-git.new \
	      || exit 1; \
	   mv iperd-git.new/.git .git || exit 1; \
	   rm -Rf iperd-git.new || exit 1; \
	fi;
	git reset || exit 1;
	git diff --diff-filter=D --name-only --exit-code > /dev/null \
		||  git checkout .; \
	git fetch origin || exit 1;
	git merge origin/$$(git rev-parse --abbrev-ref HEAD) || exit 1;


# end of makefile
