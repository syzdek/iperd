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

# set defaults
BASEDIR="$(cd "$(dirname "${IPERD_PROFILE}")/../../"; pwd)"
SCRIPTDIR="${SCRIPTDIR:-${BASEDIR}/src/scripts}"
DISTRODIR="${DISTRODIR:-${BASEDIR}/src/distros}"
CONFIGDIR="${CONFIGDIR:-${BASEDIR}/var/config}"
CONFIG="${CONFIG:-${CONFIGDIR}/iperd.conf}"


# load configuration
if test -f ${CONFIG};then
   . ${CONFIG}
fi


# set missing defaults
DEFAULT_PART_TYPE="hybrid"
DEFAULT_PART_SIZE="0"
DEFAULT_IMG_SIZE="1900"
DEFAULT_ISO_TYPE="bios"
CONFIG_PART_TYPE="${CONFIG_PART_TYPE:-${DEFAULT_PART_TYPE}}"
CONFIG_PART_SIZE="${CONFIG_PART_SIZE:-${DEFAULT_PART_SIZE}}"
CONFIG_IMG_SIZE="${CONFIG_IMG_SIZE:-${DEFAULT_IMG_SIZE}}"
CONFIG_ISO_TYPE="${CONFIG_ISO_TYPE:-${DEFAULT_ISO_TYPE}}"


# set exit codes to trigger specific xargs exit codes
DIALOG_OK=0        # xargs => 0
DIALOG_CANCEL=255  # xargs => 124
DIALOG_ESC=255     # xargs => 124
DIALOG_EXTRA=126   # xargs => 126
DIALOG_HELP=0      # xargs => 0
export DIALOG_OK DIALOG_CANCEL DIALOG_HELP DIALOG_EXTRA DIALOG_ESC


###############
#             #
#  Functions  #
#             #
###############

list_cfg_distros()
{
   egrep '^#[[:alnum:]]+-' "${CONFIG}" \
      |cut -d- -f1 \
      |cut -d'#' -f2 \
      |sort \
      |uniq
}


list_cfg_vers()
{
   egrep "^#${1}-" "${CONFIG}" \
      |cut -d\# -f2
}


list_distros()
{
   egrep '^[[:space:]]{0,}[a-zA-Z0-9]{1,}[[:space:]]' ${DISTRODIR}/*/option* \
      |sed \
         -e 's/^[a-zA-Z0-9/]\{1,\}://g' \
         -e 's/ @[[:alnum:][:punct:]]\{1,\}@$//g' \
         -e "s/[[:space:]]\{2,\}/ /g" \
         -e 's/^ //g' \
         -e 's/ $//g' \
      |cut -d: -f2 \
      |sort -n \
      |uniq
}


list_vers()
{
   egrep '^[[:space:]]{0,}[a-zA-Z0-9]{1,}-' "${1}" \
      |sed \
         -e 's/[[:space:]]\{1,\}/ /g' \
         -e 's/[-a-z0-9_/]\{1,\}: //g' \
         -e 's/^ //g' \
      |cut -d\  -f1 \
      |sort -n \
      |uniq
}


list_vers_opts()
{
   OPTFILE="${1}"

   # generate list of options
   for VERS in $(list_vers ${OPTFILE});do
      grep "^#${VERS}$" "${CONFIG}.new" > /dev/null 2> /dev/null
      if test $? -eq 0;then
         STATE=on
      else
         STATE=off
      fi
      egrep "^[[:space:]]{0,}${VERS}[[:space:]]" ${OPTFILE} |sed -e "s/$/ ${STATE}/g"
   done \
      |sed \
         -e "s/[[:space:]]\{1,\}/ /g" \
         -e 's/^ //g' \
        -e 's/ $//g' \
      |sort -n
}


# end of profile
