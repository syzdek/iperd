#!/bin/sh
#
#   IP Engineering Rescue Disk
#   Copyright (C) 2017 David M. Syzdek <david@syzdek.net>.
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
ACTION="${1,,}"
BASEDIR="${2:-$(pwd)}"


# set defaults
PROG_NAME="$(basename "${0}")"
DISTRODIR="${DISTRODIR:-${BASEDIR}/src/distros}"
CONFIGDIR="${CONFIGDIR:-${BASEDIR}/src/config}"
CONFIG="${CONFIG:-${CONFIGDIR}/iperd.conf}"
OPTIONS="${OPTIONS:-${CONFIGDIR}/iperd.opts}"


cleanup()
{
   rm -f "${OPTIONS}"
   rm -f "${CONFIGDIR}/*.new"
}
trap cleanup EXIT


configure()
{
   # remove stale files
   rm -f "${OPTIONS}"
   rm -f "${CONFIG}.dist"
   rm -f "${CONFIG}.vers"


   # prepare options
   mkdir -p "$(dirname "${OPTIONS}")"
   cat ${DISTRODIR}/*/*.opts |sort > "${OPTIONS}" || exit 1
   sed -i \
      -e 's/[[:space:]]\{2,\}/ /g' \
      -e 's/^ //g' \
      -e 's/ $//g' \
      -e 's/ @[[:alnum:][:punct:]]\{1,\}@$//g' \
      -e 's/^\(\([[:alnum:][:punct:]]\{1,\}\) [[:print:]]\{1,\}$\)/\1 @\2@/g' \
      "${OPTIONS}" \
      || exit 1
   if test -f "${CONFIG}";then
      for IMAGE in $(cat "${CONFIG}");do
         sed -i -e "s/@${IMAGE}@/on/g" "${OPTIONS}"
      done
      sed -i -e "s/@[-.a-zA-Z0-9]\{1,\}@/off/g" "${OPTIONS}"
   fi
   sed \
      -i \
      -e "s/@[-.a-zA-Z0-9]\{1,\}@/on/g" \
      -e "s/^[[:space:]]\{1,\}//g" \
      -e "s/[[:space:]]\{2,\}/ /g" \
      "${OPTIONS}"


   # prompt for OS distributions
   egrep '^[a-zA-Z0-9]{1,} ' "${OPTIONS}" \
      |xargs dialog \
         --no-tags \
         --title "Distros" \
         --backtitle "Select distros to install." \
         --checklist "Choose distros to install:" \
         20 70 13 \
         2> "${CONFIG}.dist.new" \
         || { echo " "; exit 1; }
   for DISTRO in $(cat "${CONFIG}.dist.new");do
      echo "${DISTRO}"
   done |sort -n > "${CONFIG}.dist"
   rm -f "${CONFIG}.dist.new"


   # prompt for OS distribution versions
   for DISTRO in $(cat "${CONFIG}.dist");do
      echo -n ' ' >> "${CONFIG}.vers.new"
      COUNT=$(egrep "^${DISTRO}-" "${OPTIONS}" |wc -l)
      if test $COUNT == 1;then
         egrep "^${DISTRO}-" "${OPTIONS}" \
            |awk '{print$1}' \
            >> "${CONFIG}.vers.new"
      else
         egrep "^${DISTRO}-" "${OPTIONS}" \
            |xargs dialog \
               --no-tags \
               --title "Boot Images" \
               --backtitle "Select images to install." \
               --checklist "Choose images to install:" \
               20 70 13 \
               2>> "${CONFIG}.vers.new" \
               || { echo " "; exit 1; }
      fi
   done
   for VERS in $(cat "${CONFIG}.vers.new");do
      echo "${VERS}"
   done |sort -n > "${CONFIG}.vers"
   rm -f "${CONFIG}.vers.new"


   # update cached config
   rm -f "${CONFIG}"
   cat "${CONFIG}.dist" "${CONFIG}.vers" > "${CONFIG}"


   # generate dependencies
   deps
}


deps()
{
   # build Makefile configuration
   for DISTRO in $(cat "${CONFIG}.dist");do
      if test -f "${DISTRODIR}/${DISTRO}/${DISTRO}-header.make";then
         cat "${DISTRODIR}/${DISTRO}/${DISTRO}-header.make"
      fi
      for VERS in $(egrep "^${DISTRO}-" "${CONFIG}.vers");do
         VERSION=$(echo "${VERS}" |cut -d- -f2)
         CODENAME=$(echo "${VERS}" |cut -d- -f3)
         ARCH=$(echo "${VERS}" |cut -d- -f4)
         if test -f "${DISTRODIR}/${DISTRO}/${DISTRO}-boot.make";then
            sed \
               -e "s/@VERSION@/${VERSION}/g" \
               -e "s/@CODENAME@/${CODENAME}/g" \
               -e "s/@DISTRO@/${DISTRO}/g" \
               -e "s/@ARCH@/${ARCH}/g" \
               -e "s/@LABEL@/${LABEL}/g" \
               "${DISTRODIR}/${DISTRO}/${DISTRO}-boot.make"
         fi
      done
      if test -f "${DISTRODIR}/${DISTRO}/${DISTRO}-footer.make";then
         cat "${DISTRODIR}/${DISTRO}/${DISTRO}-footer.make"
      fi
   done > ${BASEDIR}/Makefile.config
}


# prompt for images to install
case "${ACTION}" in

   configure)
   configure
   exit $?
   ;;


   deps)
   deps
   exit $?
   ;;


   *)
      echo "Usage: ${PROG_NAME} [ configure | deps ]" 1>&2
      exit 1
   ;;
esac

# end of script
