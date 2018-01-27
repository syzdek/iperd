#!/bin/bash
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

# +-=-=-=-=-=-+
# |           |
# |  Headers  |
# |           |
# +-=-=-=-=-=-+

PROG_NAME="$(basename "${0}")"


# +-=-=-=-=-=-=-+
# |             |
# |  Functions  |
# |             |
# +-=-=-=-=-=-=-+

cleanup()
{
   test -z "${LOOPDEV}" || sudo losetup -d "${LOOPDEV}"
}


catchsig()
{
   rm -f "${OUTPUT}"
   exit 1
}


usage()
{
   printf "Usage: %s [OPTIONS] <source> <file>\n" "$PROG_NAME"
   printf "OPTIONS:\n"
   printf "   -h            display this message\n"
   printf "   -q            quiet\n"
   printf "   -s size       size of image in megabytes (default: 1900)"
   printf "   -t type       partition type (mbr, hybrid [default], or gpt)\n"
   printf "   -v            verbose\n"
   printf "\n"
}


# +-=-=-=-=-=-=-+
# |             |
# |  Main Body  |
# |             |
# +-=-=-=-=-=-=-+

# set defaults
unset VERBOSE
PARTSIZE="1900"
PARTTYPE="hybrid"


# parse CLI arguments
while getopts :hqs:t:v OPT; do
   case ${OPT} in
      h) usage; exit 0;;
      s) PARTSIZE="${OPTARG}";;
      t) PARTTYPE="${OPTARG}";;
      v) VERBOSE="1";;
      q) unset VERBOSE;;
      ?)
         echo "${PROG_NAME}: illegal option -- ${OPTARG}" 1>&2
         echo "Try '${PROG_NAME} -h' for more information." 1>&2
         exit 1;
      ;;
      *)
      ;;
   esac
done
shift "$((OPTIND-1))"
SOURCE="${1}"
OUTPUT="${2}"


# check configuration options
if test -z "${SOURCE}";then
   echo "${PROG_NAME}: missing source"
   echo "Try '${PROG_NAME} -h' for more information." 1>&2
   exit 1
fi
if test -z "${OUTPUT}";then
   echo "${PROG_NAME}: missing file"
   echo "Try '${PROG_NAME} -h' for more information." 1>&2
   exit 1
fi
if test "x${PARTTYPE}" != "xhybrid" &&
   test "x${PARTTYPE}" != "xmbr" &&
   "x${PARTTYPE}" != "xgpt";then
   echo "${PROG_NAME}: invalid partition type"
   echo "Try '${PROG_NAME} -h' for more information." 1>&2
   exit 1;
fi
if test ! -z "${PARTSIZE//[0-9]/}";then
   echo "${PROG_NAME}: invalid partition size"
   echo "Try '${PROG_NAME} -h' for more information." 1>&2
   exit 1;
fi


# check for required files/directories/devices
if test ! -f "${SOURCE}/src/scripts/thumbdrive.sh";then
   echo "${PROG_NAME}: thumbdrive.sh: file not found"
   exit 1
fi
if test -f "${OUTPUT}";then
   echo "${PROG_NAME}: ${OUTPUT}: already exists"
   exit 1
fi


# set up exit traps
trap catchsig SIGHUP SIGINT SIGTERM
trap cleanup EXIT


# create empty 1900MB disk image
dd \
   if=/dev/zero \
   of="${OUTPUT}" \
   count=0 \
   bs=512 \
   seek=$((2048*${PARTSIZE})) \
   || { rm -f "${OUTPUT}"; exit 1; }


# set up loop block device
LOOPDEV=$(sudo losetup -P -f --show "${OUTPUT}")
if test -z "${LOOPDEV}";then
   rm -f "${OUTPUT}"
   exit 1
fi


sudo bash "${SOURCE}/src/scripts/thumbdrive.sh" -t ${PARTTYPE} "${SOURCE}" "${LOOPDEV}" \
   || { rm -f "${OUTPUT}"; exit 1; }


# end of script
