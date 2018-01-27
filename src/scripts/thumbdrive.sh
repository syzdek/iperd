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


SCRIPTDIR=src/scripts
DIRS="boot src syslinux"
FILES="COPYING Makefile Makefile.config Makefile.local syslinux/pxelinux.cfg"


# +-=-=-=-=-=-=-+
# |             |
# |  Functions  |
# |             |
# +-=-=-=-=-=-=-+

cleanup()
{
   if test ! -z "${MKTEMP}";then
      mount \
         | grep "${MKTEMP}" \
         && umount -f "${MKTEMP}"
      rm -Rf "${MKTEMP}"
   fi
}


part_gpt()
{
   # create 1st partition: EFI
   sgdisk "${DEVICE}" --new=1:0:+1M     || return 1
   sgdisk "${DEVICE}" --typecode=1:EF02 || return 1

   # create 2nd parition
   sgdisk "${DEVICE}" --new=2:0:${PARTSIZE} || return 1
   sgdisk "${DEVICE}" --typecode=2:0700      || return 1
}


part_hybrid()
{
   # create base partition table
   part_gpt || return 1

   # convert to hybrid partition table
   sgdisk "${DEVICE}" --hybrid=1:2 || return 1

   # convert to MBR and activate partition 2
   sgdisk "${DEVICE}" --zap        || return 1
   sfdisk --activate "${DEVICE}" 2 || return 1

   # add boot code to MBR
   dd \
      bs=440 count=1 conv=notrunc \
      if="${SOURCE}/syslinux/gptmbr.bin" \
      of="${DEVICE}" \
      || return 1

   # backup MBR table
   rm -f "${SOURCE}/tmp/mbr.backup"
   dd bs=512 count=1 conv=notrunc \
      if="${DEVICE}" \
      of="${SOURCE}/tmp/mbr.backup" \
      || return 1

   # convert back to GPT and adjust partition numbers
   sgdisk "${DEVICE}" --mbrtogpt      || return 1
   sgdisk "${DEVICE}" --transpose=1:2 || return 1
   sgdisk "${DEVICE}" --transpose=2:3 || return 1

   # re-adjust partition 2 information for GPT
   sgdisk "${DEVICE}" --typecode=2:EF00          || return 1
   sgdisk "${DEVICE}" --change-name=2:"BootDisk" || return 1
   sgdisk "${DEVICE}" --attributes=2:set:2       || return 1

    # convert GPT to hybrid GPT
   sgdisk "${DEVICE}" --hybrid=1:2 || return 1

   # restore MBR with bootable partition 2
   dd bs=512 count=1 conv=notrunc \
      if="${SOURCE}/tmp/mbr.backup" \
      of="${DEVICE}" \
      || return 1
   rm -f \
      "${SOURCE}/tmp/mbr.backup" \
      || return 1

   return 0;
}


part_mbr()
{
   # create base partition table
   part_gpt || return 1

   # convert to hybrid partition table
   sgdisk "${DEVICE}" gpttombr=1:2 || return 1

   # convert to MBR and activate partition 2
   sgdisk "${DEVICE}" --zap        || return 1
   sfdisk --activate "${DEVICE}" 2 || return 1

   # add boot code to MBR
   dd \
      bs=440 count=1 conv=notrunc \
      if="${SOURCE}/syslinux/mbr.bin" \
      of="${DEVICE}" \
      || return 1

   return 0;
}


usage()
{
   printf "Usage: %s [OPTIONS] <source> <device>\n" "$PROG_NAME"
   printf "OPTIONS:\n"
   printf "   -h            display this message\n"
   printf "   -q            quiet\n"
   printf "   -s size       size of data partition (default: 100%)"
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
unset MKTEMP
unset VERBOSE
PARTTYPE="hybrid"
PARTSIZE=0


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
DEVICE="${2}"


# check configuration options
if test -z "${SOURCE}";then
   echo "${PROG_NAME}: missing source"
   echo "Try '${PROG_NAME} -h' for more information." 1>&2
   exit 1
fi
if test -z "${DEVICE}";then
   echo "${PROG_NAME}: missing device"
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
if test ! -z "$(echo ${PARTSIZE} |sed -e 's/^[0-9]\+M\{0,1\}$//g'";then
   echo "${PROG_NAME}: invalid data partition size"
   echo "Try '${PROG_NAME} -h' for more information." 1>&2
   exit 1;
fi


# adjusts PARTSIZE
if test "x${PARTSIZE//[0-9]/}" == "x" &&
   test "x${PARTSIZE}" != "x0"then
   PARTSIZE="${PARTSIZE}M"
fi


# check for required files/directories/devices
if test ! -b "${DEVICE}";then
   echo "${PROG_NAME}: device not found"
   exit 1
fi
for DIR in ${DIRS};do
   if test ! -d "${SOURCE}/${DIR}";then
      echo "${PROG_NAME}: SOURCE/${DIR}: source directory not found"
      exit 1
   fi
done
for FILE in ${FILES};do
   if test ! -f "${SOURCE}/${FILE}";then
      echo "${PROG_NAME}: SOURCE/${FILE}: source file not found"
      exit 1
   fi
done


# set up exit traps
trap cleanup SIGHUP SIGINT SIGTERM EXIT


# enable verbose output
if test "x${VERBOSE}" == "x1";then
   set -x
fi


# clear existing MBR and/or GPT data
sgdisk "${DEVICE}" --zap-all || exit 1


# partition disk
case "${PARTTYPE}" in
   'mbr') part_mbr       || exit 1;;
   'gpt') part_gpt       || exit 1;;
   'hybrid') part_hybrid || exit 1;;
   *)
   echo "${PROG_NAME}: unknown partition table type" 1>&2
   echo "Try '${PROG_NAME} -h' for more information." 1>&2
   exit 1;
   ;;
esac


# refresh partition table in kernel memory
partprobe "${DEVICE}" || exit 1



# calculate partition device name
DEVPART="$(basename "${DEVICE}")"
DEVPART="$(grep "[0-9] ${DEVPART}p\{0,1\}2$" /proc/partitions|awk '{print$4}')"
if test -z "${DEVPART}";then
   echo "${PROG_NAME}: partition is not detected"
   exit 1
fi


# make vFAT file systems
mkfs.vfat -F 32 -I -n "IP_ENG_BOOT" /dev/${DEVPART} || exit 1
parted -a optimal -s "${DEVICE}" print


# install syslinux
if test "${PARTTYPE}" == "mbr" ||
   test "${PARTTYPE}" == "hybrid";then
   "${SOURCE}/syslinux/bin/syslinux" -i /dev/${DEVPART} || exit 1
fi


# mount disk image
MKTEMP="$(mktemp -d -p tmp/ thumbdrive.XXXXXX)"
if test -z "${MKTEMP}";then
   exit 1
fi
mount -o rw /dev/${DEVPART} "${SOURCE}/${MKTEMP}" || exit 1


# install files
rsync \
   --exclude=/.git/ \
   --exclude=/images/ \
   --exclude=/tmp/ \
   --prune-empty-dirs \
   --recursive \
   "${SOURCE}/" \
   "${SOURCE}/${MKTEMP}" \
   || exit 1


# create local git repository
if test ! -d "${SOURCE}/.git";then
   exit 0
fi
git --git-dir="${SOURCE}/${MKTEMP}/.git" init \
   && git config --file "${SOURCE}/${MKTEMP}/.git/config" core.bare true \
   && git push "${SOURCE}/${MKTEMP}/.git" master:master \
   && git config --file "${SOURCE}/${MKTEMP}/.git/config" core.bare false \
   && git --git-dir="${SOURCE}/${MKTEMP}/.git" remote add origin \
          https://github.com/syzdek/iperd.git \
   && git config --file "${SOURCE}/${MKTEMP}/.git/config" \
          branch.master.remote origin \
   && ( cd "${SOURCE}/${MKTEMP}/" && git reset; ) \
   || rm -Rf "${SOURCE}/${MKTEMP}/.git"


sync


# end of script
