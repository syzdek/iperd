#!/bin/sh
#
#   IP Engineering Rescue Disk
#   Copyright (C) 2017, 2018 David M. Syzdek <david@syzdek.net>.
#
#   @SYZDEK_BSD_LICENSE_START@
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
#   @SYZDEK_BSD_LICENSE_END@
#

# set base directory
REGEN_FILE="${1,,}"
if test -z "${REGEN_FILE}";then
   REGEN_FILE=all
fi


# set PROG_NAME and load profile
PROG_NAME="$(basename "${0}")"
IPERD_PROFILE="$(dirname "${0}")/iperd.profile"
if test ! -f "${IPERD_PROFILE}";then
   echo "${PROG_NAME}: unable to find iperd.profile" 1>&2;
   exit 1;
fi
. "${IPERD_PROFILE}"


###############
#             #
#  Functions  #
#             #
###############


# generate syslinux configurations
generate_cfg()
{
   INCFILE="${1}"
   SRCHEADER="${2:-cfg.header}"
   SRCFILES="${3:-cfg.label}"
   SRCFOOTER="${4:-cfg.footer}"
   BROKEFILES="${5:-broken}"

   rm -f "${CONFIGDIR}/${INCFILE}" || return 1
   for GENDISTRO in $(list_cfg_distros);do
      BROKEN=no
      for BROKEFILE in "broken ${BROKEFILES}";do
         if test ! -z "${BROKEFILE}";then
            if test -f "${DISTRODIR}/${GENDISTRO}/${BROKEFILE}";then
               BROKEN=yes;
            fi
         fi
      done
      if test "x${BROKEN}" == "xyes";then
         continue;
      fi
      gen_dosubst "${GENDISTRO}" "${SRCHEADER}" "${SRCFILES}" "${SRCFOOTER}" || return 1
   done > "${CONFIGDIR}/${INCFILE}"
   touch "${CONFIGDIR}/${INCFILE}"
}


# build Makefile configuration
generate_makefile_config()
{
   rm -f ${BASEDIR}/Makefile.config
   {
      # add configured options
      echo "DISKSIZE	?= ${CONFIG_IMG_SIZE}"
      echo "DISKTYPE	?= ${CONFIG_PART_TYPE}"
      echo "PARTSIZE	?= ${CONFIG_PART_SIZE}"
      echo "TLSCHECK	?= ${CONFIG_TLS_CHECK}"

      # define standard dependencies
      STD_DEP_FILES="src/scripts/genfiles.sh"
      STD_DEP_FILES="${STD_DEP_FILES} src/scripts/iperd.profile"
      STD_DEP_FILES="${STD_DEP_FILES} var/config/iperd.conf"

      # save Makekfile dependencies
      CFG_DEP_FILES="${STD_DEP_FILES}"
      for MAKEDISTRO in $(list_cfg_distros);do
         for FILE in $(cd ${BASEDIR} && ls src/distros/${MAKEDISTRO}/make.*);do
            CFG_DEP_FILES="${CFG_DEP_FILES} ${FILE}"
         done
      done
      echo "MAKEFILE_CONFIG_DEPS	= ${CFG_DEP_FILES}"

      # save syslinux config include dependencies
      CFG_DEP_FILES="${STD_DEP_FILES}"
      for MAKEDISTRO in $(list_cfg_distros);do
         for FILE in $(cd ${BASEDIR} && ls src/distros/${MAKEDISTRO}/cfg.*);do
            CFG_DEP_FILES="${CFG_DEP_FILES} ${FILE}"
         done
      done
      echo "SYSLINUX_INC_DEPS		= ${CFG_DEP_FILES}"

      # add distro specific rules
      for MAKEDISTRO in $(list_cfg_distros);do
         gen_dosubst "${MAKEDISTRO}" "make.header" "make.boot" make.footer
      done
   } >  ${BASEDIR}/Makefile.config
   touch "${BASEDIR}/Makefile.config"
}


gen_dosubst()
{
   DISTRO="${1}"
   HEADER="${2}"
   FILES="${3}"
   FOOTER="${4}"

   if test -f "${DISTRODIR}/${DISTRO}/${HEADER}";then
      cat "${DISTRODIR}/${DISTRO}/${HEADER}"
   fi

   for VERS in $(list_cfg_vers "${DISTRO}");do
      VERSION=$(echo  "${VERS}" |cut -d- -f2)
      CODENAME=$(echo "${VERS}" |cut -d- -f3)
      ARCH=$(echo     "${VERS}" |cut -d- -f4)
      for TMPFILE in ${FILES};do
         if test -f "${DISTRODIR}/${DISTRO}/${TMPFILE}";then
            sed \
               -e "s/@VERSION@/${VERSION}/g" \
               -e "s/@CODENAME@/${CODENAME}/g" \
               -e "s/@DISTRO@/${DISTRO}/g" \
               -e "s/@ARCH@/${ARCH}/g" \
               "${DISTRODIR}/${DISTRO}/${TMPFILE}"
            break;
         fi
      done
   done

   if test -f "${DISTRODIR}/${DISTRO}/${FOOTER}";then
      cat "${DISTRODIR}/${DISTRO}/${FOOTER}"
   fi
}


####################
#                  #
#  Body of Script  #
#                  #
####################


case "${REGEN_FILE}" in

   all);;
   makefile.config);;
   var/config/grub.inc);;
   var/config/isolinux.inc);;
   var/config/pxelinux.inc);;
   var/config/pxelia32.inc);;
   var/config/pxelx64.inc);;
   var/config/syslinux.inc);;
   var/config/syslia32.inc);;
   var/config/syslx64.inc);;

   *)
   echo "Usage: ${PROG_NAME} all"                     1>&2
   echo "       ${PROG_NAME} Makefile.config"         1>&2
   echo "       ${PROG_NAME} var/config/grub.inc"     1>&2
   echo "       ${PROG_NAME} var/config/isolinux.inc" 1>&2
   echo "       ${PROG_NAME} var/config/pxelinux.inc" 1>&2
   echo "       ${PROG_NAME} var/config/pxelia32.inc" 1>&2
   echo "       ${PROG_NAME} var/config/pxelx64.inc"  1>&2
   echo "       ${PROG_NAME} var/config/syslinux.inc" 1>&2
   echo "       ${PROG_NAME} var/config/syslia32.inc" 1>&2
   echo "       ${PROG_NAME} var/config/syslx64.inc"  1>&2
   echo ""
   exit 1
   ;;
esac


if test "x${REGEN_FILE}" = "xall";then
   REGEN_FILE=""
   REGEN_FILE="${REGEN_FILE} makefile.config"
   REGEN_FILE="${REGEN_FILE} var/config/grub.inc"
   REGEN_FILE="${REGEN_FILE} var/config/isolinux.inc"
   REGEN_FILE="${REGEN_FILE} var/config/pxelinux.inc"
   REGEN_FILE="${REGEN_FILE} var/config/pxelia32.inc"
   REGEN_FILE="${REGEN_FILE} var/config/pxelx64.inc"
   REGEN_FILE="${REGEN_FILE} var/config/syslinux.inc"
   REGEN_FILE="${REGEN_FILE} var/config/syslia32.inc"
   REGEN_FILE="${REGEN_FILE} var/config/syslx64.inc"
fi


for FILE in ${REGEN_FILE};do
   case "${FILE}" in
      makefile.config)
      generate_makefile_config \
         || exit 1
      ;;

      var/config/grub.inc)
      generate_cfg \
         grub.inc \
         "cfg.header.iso.efi" \
         "cfg.label.iso.efi" \
         "cfg.footer.iso.efi" \
         "broken.iso broken.efi" \
         || exit 1;
      ;;

      var/config/isolinux.inc)
      generate_cfg \
         isolinux.inc \
         "cfg.header" \
         "cfg.label cfg.label.iso" \
         "cfg.footer" \
         "broken.iso" \
         || exit 1;
      ;;

      var/config/pxelinux.inc)
      generate_cfg \
         pxelinux.inc \
         "cfg.header" \
         "cfg.label cfg.label.pxe" \
         "cfg.footer" \
         "broken.pxe" \
         || exit 1;
      ;;

      var/config/pxelia32.inc)
      generate_cfg \
         pxelia32.inc \
         "cfg.header" \
         "cfg.label cfg.label.pxe" \
         "cfg.footer" \
         "broken.pxe broken.efi broken.efi32" \
         || exit 1;
      ;;

      var/config/pxelx64.inc)
      generate_cfg \
         pxelx64.inc \
         "cfg.header" \
         "cfg.label cfg.label.pxe" \
         "cfg.footer" \
         "broken.pxe broken.efi broken.efi64" \
         || exit 1;
      ;;

      var/config/syslinux.inc)
      generate_cfg \
         syslinux.inc \
         "cfg.header" \
         "cfg.label cfg.label.sys" \
         "cfg.footer" \
         "broken.sys" \
         || exit 1;
      ;;

      var/config/syslia32.inc)
      generate_cfg \
         syslia32.inc \
         "cfg.header" \
         "cfg.label cfg.label.sys" \
         "cfg.footer" \
         "broken.sys broken.efi broken.efi32" \
         || exit 1;
      ;;

      var/config/syslx64.inc)
      generate_cfg \
         syslx64.inc \
         "cfg.header" \
         "cfg.label cfg.label.sys" \
         "cfg.footer" \
         "broken.sys broken.efi broken.efi64" \
         || exit 1;
      ;;

      *)
      ;;
   esac
done


exit 0

# end of script
