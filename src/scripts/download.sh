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


# set logging function
LOGGER="/usr/bin/sed -e s/^/${PROGRAM_NAME}:/g"


# +-=-=-=-=-=-=-+
# |             |
# |  Functions  |
# |             |
# +-=-=-=-=-=-=-+

cleanup()
{
   if test ! -z "${TMPFILE}";then
      if test -f "${TMPFILE}.new";then
         rm -f "${TMPFILE}.new"
      fi
      if test "x${KEEPTEMPFILE}" != "xyes" && test -f "${TMPFILE}";then
         rm -f "${TMPFILE}"
      fi
   fi
   if test ! -z "${FILE}";then
      if test -f "${FILE}.new";then
         rm -f "${FILE}.new"
      fi
   fi
   if test ! -z "${EXTRACTDIR}";then
      if test ! -f "${EXTRACTDIR}/.iperd-extracted" && test -d "${EXTRACTDIR}";then
         rm -Rf "${EXTRACTDIR}"
      fi
   fi
   if test ! -z "${EXTRACT_MKTEMP}";then
      if test -d "${EXTRACT_MKTEMP}";then
         sudo umount -f "${EXTRACT_MKTEMP}"
         rm -Rf "${EXTRACT_MKTEMP}"
      fi
   fi
}


extactiso()
{
   # create temp mount point
   EXTRACT_MKTEMP="$(mktemp -d -p "tmp/" "$(basename "${EXTRACTDIR}").XXXXXX")"
   if test -z "${EXTRACT_MKTEMP}";then
      exit 1
   fi

   # create target directory
   mkdir -p "${EXTRACTDIR}" || exit 1

   # mount ISO
   sudo mount -o ro "${FILE}" "${EXTRACT_MKTEMP}" || exit 1

   # copy contents
   rsync -ra "${EXTRACT_MKTEMP}/" "${EXTRACTDIR}" || exit 1

   # make files user writeable
   chmod -R u+rw "${EXTRACTDIR}" || exit 
}


usage()
{
   printf "Usage: %s [OPTIONS] <file> <url>\n" "$PROG_NAME"
   printf "OPTIONS:\n"
   printf "   -e dir        extract contents of file to dir\n"
   printf "   -h            display this message\n"
   printf "   -H file       verify file with hash file\n"
   printf "   -k            do not delete temp file\n"
   printf "   -t file       store temp data to file\n"
   printf "\n"
   printf "SUPPORTED HASH FILES:\n"
   printf "   .sha1\n"
   printf "   .sha256\n"
   printf "   .sha512\n"
   printf "\n"
   printf "SUPPORTED ARCHIVES:\n"
   printf "   .iso\n"
   printf "   .tar.gz\n"
   printf "   .tgz\n"
   printf "   .tar.bz2\n"
   printf "   .tbz\n"
   printf "   .tbz2\n"
   printf "   .tar.xz\n"
   printf "   .txz\n"
   printf "\n"
}


# +-=-=-=-=-=-=-+
# |             |
# |  Main Body  |
# |             |
# +-=-=-=-=-=-=-+

# set defaults
unset TMPFILE
unset EXTRACTDIR
unset HASH_CMD
unset HASH_FILE
unset HASH_DATA
unset KEEPTEMPFILE
unset EXTRACT_MKTEMP
unset WGET_FLAGS


# parse CLI arguments
while getopts :e:hH:kt: OPT; do
   case ${OPT} in
      e) EXTRACTDIR="${OPTARG}";;
      h) usage; exit 0;;
      H) HASH_FILE="${OPTARG}";;
      k) KEEPTEMPFILE="yes";;
      t) TMPFILE="${OPTARG}";;
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
FILE="${1}"
URL="${2}"
if test ! -z "${3}";then
   echo "${PROG_NAME}: too many arguments" 1>&2
   echo "Try '${PROG_NAME} -h' for more information." 1>&2
   exit 1;
fi


# verify arguments
if test -z "${URL}";then
   echo "${PROG_NAME}: missing required argument" 1>&2
   echo "Try '${PROG_NAME} -h' for more information." 1>&2
   exit 1
fi


# adjust options
if test "x${CONFIG_TLS_CHECK}" == "xno";then
   WGET_FLAGS="${WGET_FLAGS} --no-check-certificate";
fi
if test -z "${TMPFILE}";then
   TMPFILE="${FILE}.tmp"
fi
if test ! -z "${HASH_FILE}";then
   if test -f "${HASH_FILE}";then
      HASH_DATA="$(awk '{print$1}' "${HASH_FILE}")"
   else
      HASH_DATA="missing hash"
   fi
   case "${HASH_FILE}" in
      *.sha1)   HASH_CMD="sha1sum";;
      *.sha256) HASH_CMD="sha256sum";;
      *.sha512) HASH_CMD="sha512sum";;
      *)
         echo "${PROG_NAME}: unknown hash type" 1>&2
         echo "Try '${PROG_NAME} -h' for more information." 1>&2
         exit 1
      ;;
   esac
fi
if test ! -z "${EXTRACTDIR}";then
   case "${FILE}" in
      *.iso)     EXTRACT_CMD="extactiso";;
      *.tar.gz)  EXTRACT_CMD="gzip  -cd '${FILE}' |tar -xf - -C '${EXTRACTDIR}'";;
      *.tgz)     EXTRACT_CMD="gzip  -cd '${FILE}' |tar -xf - -C '${EXTRACTDIR}'";;
      *.tar.bz2) EXTRACT_CMD="bzip2 -cd '${FILE}' |tar -xf - -C '${EXTRACTDIR}'";;
      *.tbz)     EXTRACT_CMD="bzip2 -cd '${FILE}' |tar -xf - -C '${EXTRACTDIR}'";;
      *.tbz2)    EXTRACT_CMD="bzip2 -cd '${FILE}' |tar -xf - -C '${EXTRACTDIR}'";;
      *.tar.xz)  EXTRACT_CMD="xz    -cd '${FILE}' |tar -xf - -C '${EXTRACTDIR}'";;
      *.txz)     EXTRACT_CMD="xz    -cd '${FILE}' |tar -xf - -C '${EXTRACTDIR}'";;
      *)
         echo "${PROG_NAME}: unknown file extension for extracting archive" 1>&2
         echo "Try '${PROG_NAME} -h' for more information." 1>&2
         exit 1
      ;;
   esac
fi


# test if file is already downloaded
if test -f "${FILE}" && test -z "${EXTRACTDIR}";then
   echo "${PROG_NAME}: nothing to be done for \"${FILE}\"";
   exit 0;
elif test -f "${FILE}" && test -f "${EXTRACTDIR}/.iped-extracted";then
   echo "${PROG_NAME}: nothing to be done for \"${FILE}\"";
   exit 0;
fi;


# set up exit traps
trap cleanup SIGHUP SIGINT SIGTERM EXIT


# download file
if test ! -f "${TMPFILE}" && test ! -f "${FILE}";then
   mkdir -p "$(dirname "${TMPFILE}")" || exit 1;
   wget \
      ${WGET_FLAGS} \
      -q \
      -O "${TMPFILE}.new" \
      "${URL}" \
      || { rm -f "${TMPFILE}.new"; exit 1; }

   # verify hash of file
   if test ! -z "${HASH_FILE}";then
      FILE_HASH="$(${HASH_CMD} "${TMPFILE}.new" 2> /dev/null |awk '{print$1}')"
      if test "x${FILE_HASH}" != "x${HASH_DATA}";then
         echo "${PROG_NAME}: downloaded file does not match specified hash" 1>&2
         echo "${PROG_NAME}: calculated \"${FILE_HASH}\"" 1>&2
         echo "${PROG_NAME}: expected \"${HASH_DATA}\"" 1>&2
         if test "x${KEEPTEMPFILE}" == "xyes";then
            rm -f "${TMPFILE}.badhash" 2> /dev/null
            mv "${TMPFILE}.new" "${TMPFILE}.badhash" 2> /dev/null
            echo "${PROG_NAME}: moved temp file to ${TMPFILE}.badhash" 1>&2
         else
            rm -f "${TMPFILE}.new"
         fi
         exit 1
      fi
   fi

   # move tmp file
   mv "${TMPFILE}.new" "${TMPFILE}" || exit 1
fi


# copy file into place
if test ! -f "${FILE}";then
   rm -f "${FILE}.new"
   mkdir -p "$(dirname "${FILE}")" || exit 1;
   cp "${TMPFILE}" "${FILE}.new" || { rm -f "${FILE}.new"; exit 1; }
   mv "${FILE}.new" "${FILE}"    || { rm -f "${FILE}.new"; exit 1; }
   if test "x${KEEPTEMPFILE}" != "xyes";then
      rm -f "${TMPFILE}" || exit 1;
   fi
fi


#  extract file
if test -z "${EXTRACTDIR}";then
   exit 0;
fi
echo "Extracting ${FILE} to ${EXTRACTDIR} ..."
rm -Rf "${EXTRACTDIR}/" || exit 1
${EXTRACT_CMD} || exit 1
touch "${EXTRACTDIR}/.iperd-extracted" || exit 1


exit 0
# end of script
