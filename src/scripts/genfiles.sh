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
   SRCFILES="cfg.label ${2}"
   BROKEFILE="${3}"

   rm -f "${CONFIGDIR}/${INCFILE}" || return 1

   for GENDISTRO in $(list_cfg_distros);do
      if test ! -z "${BROKEFILE}";then
         if test -f "${DISTRODIR}/${GENDISTRO}/${BROKEFILE}";then
            continue;
         fi
      fi
      gen_dosubst "${GENDISTRO}" cfg "${SRCFILES}" || return 1
   done > "${CONFIGDIR}/${INCFILE}"
}


# build Makefile configuration
generate_makefile_config()
{
   CFG_DEP_FILES=""
   rm -f ${BASEDIR}/Makefile.config
   {
      echo "ISOTYPE	?= ${CONFIG_ISO_TYPE}"
      echo "DISKSIZE	?= ${CONFIG_IMG_SIZE}"
      echo "DISKTYPE	?= ${CONFIG_PART_TYPE}"
      echo "PARTSIZE	?= ${CONFIG_PART_SIZE}"
      echo "ISOLINUX_INC_DEPS	= ${ISOLINUX_INC_DEPS}"
      echo "PXELINUX_INC_DEPS	= ${PXELINUX_INC_DEPS}"
      echo "PXELX64_INC_DEPS	= ${PXELX64_INC_DEPS}"
      echo "SYSLINUX_INC_DEPS	= ${SYSLINUX_INC_DEPS}"
      echo "SYSLX64_INC_DEPS	= ${SYSLX64_INC_DEPS}"
      for MAKEDISTRO in $(list_cfg_distros);do
         gen_dosubst "${MAKEDISTRO}" "make" "make.boot"
      done
      echo "MAKEFILE_CONFIG_DEPS	= ${CFG_DEP_FILES}"
   } >  ${BASEDIR}/Makefile.config
}


gen_dosubst()
{
   DISTRO="${1}"
   PREFIX="${2}"
   FILES="${3}"

   if test -f "${DISTRODIR}/${DISTRO}/${PREFIX}.header";then
      CFG_DEP_FILES="${CFG_DEP_FILES} ${DISTRODIR}/${DISTRO}/${PREFIX}.header"
      cat "${DISTRODIR}/${DISTRO}/${PREFIX}.header"
   fi

   for VERS in $(egrep "^#${DISTRO}-" "${CONFIG}");do
      VERSION=$(echo "${VERS}" |cut -d- -f2)
      CODENAME=$(echo "${VERS}" |cut -d- -f3)
      ARCH=$(echo "${VERS}" |cut -d- -f4)
      for TMPFILE in ${FILES};do
         if test -f "${DISTRODIR}/${DISTRO}/${TMPFILE}";then
            CFG_DEP_FILES="${CFG_DEP_FILES} ${DISTRODIR}/${DISTRO}/${TMPFILE}"
            sed \
               -e "s/@VERSION@/${VERSION}/g" \
               -e "s/@CODENAME@/${CODENAME}/g" \
               -e "s/@DISTRO@/${DISTRO}/g" \
               -e "s/@ARCH@/${ARCH}/g" \
               -e "s/@LABEL@/${LABEL}/g" \
               "${DISTRODIR}/${DISTRO}/${TMPFILE}"
            break;
         fi
      done
   done

   if test -f "${DISTRODIR}/${DISTRO}/${PREFIX}.footer";then
      CFG_DEP_FILES="${CFG_DEP_FILES} ${DISTRODIR}/${DISTRO}/${PREFIX}.footer"
      cat "${DISTRODIR}/${DISTRO}/${PREFIX}.footer"
   fi
}


####################
#                  #
#  Body of Script  #
#                  #
####################


case "${REGEN_FILE}" in
   isolinux.inc)    generate_cfg isolinux.inc cfg.label.iso              || exit 1;;
   pxelinux.inc)    generate_cfg pxelinux.inc cfg.label.pxe              || exit 1;;
   pxelx64.inc)     generate_cfg pxelx64.inc  cfg.label.pxe broken.efi64 || exit 1;;
   syslinux.inc)    generate_cfg syslinux.inc cfg.label.sys              || exit 1;;
   syslx64.inc)     generate_cfg syslx64.inc  cfg.label.sys broken.efi64 || exit 1;;
   Makefile.config) generate_makefile_config                             || exit 1;;

   all)
   generate_cfg isolinux.inc cfg.label.iso              || exit 1
   generate_cfg pxelinux.inc cfg.label.pxe              || exit 1
   generate_cfg pxelx64.inc  cfg.label.pxe broken.efi64 || exit 1
   generate_cfg syslinux.inc cfg.label.sys              || exit 1
   generate_cfg syslx64.inc  cfg.label.sys broken.efi64 || exit 1
   generate_makefile_config                             || exit 1
   ;;

   *)
   echo "Usage: ${PROG_NAME} all"             1>&2
   echo "       ${PROG_NAME} isolinux.inc"    1>&2
   echo "       ${PROG_NAME} pxelinux.inc"    1>&2
   echo "       ${PROG_NAME} pxelx64.inc"     1>&2
   echo "       ${PROG_NAME} syslinux.inc"    1>&2
   echo "       ${PROG_NAME} syslx64.inc"     1>&2
   echo "       ${PROG_NAME} Makefile.config" 1>&2
   echo ""
   exit 1
   ;;
esac

exit 0

# end of script
