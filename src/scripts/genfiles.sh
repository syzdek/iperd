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

# generate include file for isolinux.cfg
deps_isolinux_inc()
{
   CFG_DEP_FILES=""
   rm -f ${CONFIGDIR}/isolinux.inc
   for ISODISTRO in $(list_cfg_distros);do
      gen_dosubst "${ISODISTRO}" cfg "cfg.label cfg.label.iso"
   done  > "${CONFIGDIR}/isolinux.inc"
   ISOLINUX_INC_DEPS="${CFG_DEP_FILES}"
}


# generate include file for pxelinux.cfg
deps_pxelinux_inc()
{
   CFG_DEP_FILES=""
   rm -f ${CONFIGDIR}/pxelinux.inc
   for ISODISTRO in $(list_cfg_distros);do
      gen_dosubst "${ISODISTRO}" cfg "cfg.label cfg.label.pxe"
   done  > "${CONFIGDIR}/pxelinux.inc"
   PXELINUX_INC_DEPS="${CFG_DEP_FILES}"
}


# generate include file for pxelx64.cfg
deps_pxelx64_inc()
{
   CFG_DEP_FILES=""
   rm -f ${CONFIGDIR}/pxelx64.inc
   for ISODISTRO in $(list_cfg_distros);do
      if test ! -f "${DISTRODIR}/${DISTRO}/broken.efi64";then
         gen_dosubst "${ISODISTRO}" cfg "cfg.label cfg.label.pxe"
      fi
   done  > "${CONFIGDIR}/pxelx64.inc"
   PXELX64_INC_DEPS="${CFG_DEP_FILES}"
}


# generate include file for syslinux.cfg
deps_syslinux_inc()
{
   CFG_DEP_FILES=""
   rm -f ${CONFIGDIR}/syslinux.inc
   for ISODISTRO in $(list_cfg_distros);do
      gen_dosubst "${ISODISTRO}" cfg "cfg.label cfg.label.sys"
   done  > "${CONFIGDIR}/syslinux.inc"
   SYSLINUX_INC_DEPS="${CFG_DEP_FILES}"
}


# generate include file for syslx64.cfg
deps_syslx64_inc()
{
   CFG_DEP_FILES=""
   rm -f ${CONFIGDIR}/syslx64.inc
   for ISODISTRO in $(list_cfg_distros);do
      if test ! -f "${DISTRODIR}/${DISTRO}/broken.efi64";then
         gen_dosubst "${ISODISTRO}" cfg "cfg.label cfg.label.sys"
      fi
   done  > "${CONFIGDIR}/syslx64.inc"
   SYSLX64_INC_DEPS="${CFG_DEP_FILES}"
}


# build Makefile configuration
deps_makefile_config()
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
   var/config/isolinux.inc) deps_isolinux_inc    || exit 1;;
   var/config/pxelinux.inc) deps_pxelinux_inc    || exit 1;;
   var/config/pxelx64.inc)  deps_pxelx64_inc     || exit 1;;
   var/config/syslinux.inc) deps_syslinux_inc    || exit 1;;
   var/config/syslx64.inc)  deps_syslx64_inc     || exit 1;;
   Makefile.config)         deps_makefile_config || exit 1;;

   all)
   deps_isolinux_inc    || exit 1
   deps_pxelinux_inc    || exit 1
   deps_pxelx64_inc     || exit 1
   deps_syslinux_inc    || exit 1
   deps_syslx64_inc     || exit 1
   deps_makefile_config || exit 1
   ;;

   *)
   echo "Usage: ${PROG_NAME} all"                     1>&2
   echo "       ${PROG_NAME} var/config/isolinux.inc" 1>&2
   echo "       ${PROG_NAME} var/config/pxelinux.inc" 1>&2
   echo "       ${PROG_NAME} var/config/pxelx64.inc"  1>&2
   echo "       ${PROG_NAME} var/config/syslinux.inc" 1>&2
   echo "       ${PROG_NAME} var/config/syslx64.inc"  1>&2
   echo "       ${PROG_NAME} Makefile.config"         1>&2
   echo ""
   exit 1
   ;;
esac

exit 0

# end of script
