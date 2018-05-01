#!/bin/bash
#
#   IP Engineering Rescue Disk
#   Copyright (C) 2018 David M. Syzdek <david@syzdek.net>.
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

# set PROG_NAME and load profile
PROG_NAME="$(basename "${0}")"
IPERD_PROFILE="$(dirname "${0}")/iperd.profile"
if test ! -f "${IPERD_PROFILE}";then
   echo "${PROG_NAME}: unable to find iperd.profile" 1>&2;
   exit 1;
fi
. "${IPERD_PROFILE}"


# +-=-=-=-=-=-=-+
# |             |
# |  Functions  |
# |             |
# +-=-=-=-=-=-=-+

cleanup()
{
   # unmount image
   if test ! -z "${MKTEMP}";then
      mount | grep "${MKTEMP}" && sudo umount -f "${MKTEMP}"
      rm -Rf "${MKTEMP}"
      unset MKTEMP
   fi

   # remove loop dev
   test -z "${LOOPDEV}" || sudo losetup -d "${LOOPDEV}"
   unset LOOPDEV
}


exit_witherr()
{
   cleanup
   rm -f "${OUTPUT}"
   exit 1
}


usage()
{
   printf "Usage: %s [OPTIONS] <file>\n" "$PROG_NAME"
   printf "OPTIONS:\n"
   printf "   -h            display this message\n"
   printf "   -q            quiet\n"
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
unset MKTEMP


# parse CLI arguments
while getopts :hqs:t:v OPT; do
   case ${OPT} in
      h) usage; exit 0;;
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
OUTPUT="${1}"


# check configuration options
if test -z "${OUTPUT}";then
   echo "${PROG_NAME}: missing file"
   echo "Try '${PROG_NAME} -h' for more information." 1>&2
   exit 1
fi


# check for required files/directories/devices
for FILE in "${BASEDIR}/EFI/BOOT/BOOTX64.EFI" "${BASEDIR}/EFI/BOOT/BOOTIA32.EFI" \
            "${BASEDIR}/EFI/BOOT/ldlinux.e32" "${BASEDIR}/EFI/BOOT/ldlinux.e64" \
            "${BASEDIR}/EFI/BOOT/isolia32.cfg" "${BASEDIR}/EFI/BOOT/isolx64.cfg";do
   if test ! -f "${FILE}";then
      echo "${PROG_NAME}: $(basename "${FILE}"): file not found"
      exit 1
   fi
done
if test -f "${OUTPUT}";then
   echo "${PROG_NAME}: ${OUTPUT}: already exists"
   exit 1
fi


# set up exit traps
trap exit_witherr SIGHUP SIGINT SIGTERM
trap cleanup EXIT


# create empty 1900MB disk image
dd \
   if=/dev/zero \
   of="${OUTPUT}" \
   count=2880 \
   bs=512 \
   || { rm -f "${OUTPUT}"; exit 1; }


# create file-system
mkfs.msdos -F 12 -n 'EFIBOOT' "${OUTPUT}" || { rm -f "${OUTPUT}"; exit 1; }


# set up loop block device
LOOPDEV=$(sudo losetup -P -f --show "${OUTPUT}")
if test -z "${LOOPDEV}";then
   rm -f "${OUTPUT}"
   exit 1
fi


# mount disk image
MKTEMP="$(mktemp -d -p "${BASEDIR}/tmp" efiboot.XXXXXX)"
if test -z "${MKTEMP}";then
   rm -f "${OUTPUT}"
   exit 1
fi
sudo mount -o rw,uid=${USER} ${LOOPDEV} "${MKTEMP}" || exit_witherr


# create directory structure and copy files
mkdir -p "${MKTEMP}/EFI/BOOT/" || exit_witherr
cp "${BASEDIR}/EFI/BOOT/BOOTX64.EFI"   "${MKTEMP}/EFI/BOOT/"             || exit_witherr
cp "${BASEDIR}/EFI/BOOT/BOOTIA32.EFI"  "${MKTEMP}/EFI/BOOT/"             || exit_witherr
cp "${BASEDIR}/EFI/BOOT/ldlinux.e32"   "${MKTEMP}/EFI/BOOT/"             || exit_witherr
cp "${BASEDIR}/EFI/BOOT/ldlinux.e64"   "${MKTEMP}/EFI/BOOT/"             || exit_witherr
cp "${BASEDIR}/EFI/BOOT/isolia32.cfg"  "${MKTEMP}/EFI/BOOT/syslia32.cfg" || exit_witherr
cp "${BASEDIR}/EFI/BOOT/isolx64.cfg"   "${MKTEMP}/EFI/BOOT/syslx64.cfg"  || exit_witherr


# end of script
