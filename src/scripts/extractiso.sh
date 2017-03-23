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
if test "x${1}" == "x";then
   echo "Usage: ${PROG_NAME} <image> [ <output> ]"
   exit 1
fi
IMAGE="${1}"
OUTPUT="${2:-$(dirname "${IMAGE,,}")/$(basename "${IMAGE,,}" .iso)}"


mkdir -p "${OUTPUT}" || exit 1


unset MKTEMP
unset LOOPDEV


cleanup()
{
   if test ! -z "${MKTEMP}";then
      sudo umount -f "${MKTEMP}"
      rm -Rf         "${MKTEMP}"
   fi
   if test ! -z "${LOOPDEV}";then
      sudo losetup -d "${LOOPDEV}"
   fi
};
trap cleanup EXIT


# create mount point
MKTEMP="$(mktemp -d -p "tmp/" "$(basename "${OUTPUT}").XXXXXX")"
if test -z "${MKTEMP}";then
   exit 1
fi


# set up loop block device
LOOPDEV=$(sudo losetup -P -f --show "${IMAGE}")
if test -z "${LOOPDEV}";then
   exit 1
fi


# mount ISO
sudo mount -o ro "${LOOPDEV}" "${MKTEMP}" || exit 1


# copy files
rsync -ra "${MKTEMP}/" "${OUTPUT}" || exit 1


# end of script