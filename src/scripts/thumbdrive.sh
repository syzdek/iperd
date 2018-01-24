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

PROG_NAME="$(basename "${0}")"
if test "x${2}" == "x";then
   echo "Usage: ${PROG_NAME} <source> <device>"
   exit 1
fi
SOURCE="${1}"
DEVICE="${2}"
PARTSIZE="${3}"


SCRIPTDIR=src/scripts
DIRS="boot src syslinux"
FILES="COPYING Makefile Makefile.config Makefile.local syslinux/pxelinux.cfg"


unset MKTEMP


# check for required files/directories/devices
if test -z "${DEVICE}";then
   echo "${PROG_NAME}: invalid device name"
   exit 1
fi
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


cleanup()
{
   if test ! -z "${MKTEMP}";then
      mount \
         | grep "${MKTEMP}" \
         && umount -f "${MKTEMP}"
      rm -Rf "${MKTEMP}"
   fi
}
trap cleanup EXIT


set -x


## wipe MBR partition table on USB device
#parted -a optimal -s "${DEVICE}" mktable msdos || exit 1

## create DOS partition on USB device
#parted -a optimal -s "${DEVICE}" mkpart primary fat32 0% 100% || exit 1

## restore valid master boot record
#dd conv=notrunc bs=440 count=1 if="${SOURCE}/syslinux/mbr.bin" of="${DEVICE}" || exit 1

## set DOS partition as boot partition
#parted -a optimal -s "${DEVICE}" set 1 boot on || exit 1


##sgdisk "${DEVICE}" --zap-all                       || exit 1
##sgdisk "${DEVICE}" --new=1:0:+${PARTSIZE}          || exit 1
##sgdisk "${DEVICE}" --typecode=1:ef00               || exit 1
##sgdisk "${DEVICE}" --change-name=1:'BIOS/EFI Boot' || exit 1
##sgdisk "${DEVICE}" --gpttombr=1                    || exit 1
##sfdisk "${DEVICE}" --activate 1                    || exit 1
##dd \
##   if="${SOURCE}/syslinux/gptmbr.bin" \
##   of="${DEVICE}" \
##   bs=440 \
##   conv=notrunc \
##   count=1 \
##   || exit 1


# partition disk
   # clear existing MBR and/or GPT data
   sgdisk "${DEVICE}" --zap-all || exit 1

   # create 1st partition: EFI
   sgdisk "${DEVICE}" --new=1:0:+1M     || exit 1
   sgdisk "${DEVICE}" --typecode=1:EF02 || exit 1

   # create 2nd parition
   sgdisk "${DEVICE}" --new=2:0:0       || exit 1
   sgdisk "${DEVICE}" --typecode=2:0700 || exit 1

   # make hybrid
   sgdisk "${DEVICE}" --hybrid=1:2 || exit 1

   # convert to MBR and activate partition 2
   sgdisk "${DEVICE}" --zap        || exit 1
   sfdisk --activate "${DEVICE}" 2 || exit 1

   # add boot code to MBR
   dd \
      bs=440 count=1 conv=notrunc \
      if="${SOURCE}/syslinux/gptmbr.bin" \
      of="${DEVICE}" \
      || exit 1

   # backup MBR table
   rm -f "${SOURCE}/tmp/mbr.backup"
   dd bs=512 count=1 conv=notrunc \
      if="${DEVICE}" \
      of="${SOURCE}/tmp/mbr.backup" \
      || exit 1

   # convert back to GPT and adjust partition numbers
   sgdisk "${DEVICE}" --mbrtogpt      || exit 1
   sgdisk "${DEVICE}" --transpose=1:2 || exit 1
   sgdisk "${DEVICE}" --transpose=2:3 || exit 1

   # re-adjust partition 2 information for GPT
   sgdisk "${DEVICE}" --typecode=2:EF00          || exit 1
   sgdisk "${DEVICE}" --change-name=2:"BootDisk" || exit 1
   sgdisk "${DEVICE}" --attributes=2:set:2       || exit 1

    # convert GPT to hybrid GPT
   sgdisk "${DEVICE}" --hybrid=1:2 || exit 1

   # restore MBR with bootable partition 2
   dd bs=512 count=1 conv=notrunc \
      if="${SOURCE}/tmp/mbr.backup" \
      of="${DEVICE}" \
      || exit 1
   rm -f "${SOURCE}/tmp/mbr.backup"

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
#fatlabel /dev/${DEVPART} IP_ENG_BOOT || exit 1
parted -a optimal -s "${DEVICE}" print


# install syslinux
"${SOURCE}/syslinux/bin/syslinux" -i /dev/${DEVPART} || exit 1


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
