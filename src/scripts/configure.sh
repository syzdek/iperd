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
ACTION="${1,,}"


# set defaults
PROG_NAME="$(basename "${0}")"
BASEDIR="$(dirname "${0}")/../../"
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

cleanup()
{
   rm -f "${CONFIG}.new"
   rm -f "${CONFIG}.new.tmp"
}


configure()
{
   # enter main loop
   while test true;do

      # display main menu
      exec 3>&1
      RESULT="$(echo "" | xargs dialog \
         --title " Main Menu " \
         --backtitle "IP Engineering Rescue Disk Setup" \
         --ok-label "Select" \
         --extra-button \
         --extra-label "Save" \
         --cancel-label "Exit" \
         --menu "Select item to configure:" \
         20 70 13 \
         "disk"      "Change disk image options" \
         "images"    "Select individual boot images" \
         "all"       "Select all available images" \
         "defaults"  "Load defaults" \
         "revert"    "Revert changes" \
         2>&1 1>&3)"
      RC=$?
      exec 3>&-

      # inteprets selection
      if test $RC -eq 124;then # (exit)
         dialog \
            --title " Exit Setup " \
            --backtitle "IP Engineering Rescue Disk Setup" \
            --defaultno \
            --yesno "Exit without saving?" \
            6 30
         if test $? -eq 0;then
            return 0
         fi
      elif test $RC -eq 126;then # (save)
         deps
         return 0
      elif test $RC -eq 0 && test "x${RESULT}" == "xdisk";then
         configure_disk
      elif test $RC -eq 0 && test "x${RESULT}" == "ximages";then
         configure_distros
      elif test $RC -eq 0 && test "x${RESULT}" == "xall";then
         configure_all
      elif test $RC -eq 0 && test "x${RESULT}" == "xdefaults";then
         CONFIG_PART_TYPE="${DEFAULT_PART_TYPE}"
         CONFIG_PART_SIZE="${DEFAULT_PART_SIZE}"
         CONFIG_IMG_SIZE="${DEFAULT_IMG_SIZE}"
         CONFIG_ISO_TYPE="${DEFAULT_ISO_SIZE}"
         cat /dev/null > ${CONFIG}.new
         dialog \
            --backtitle "IP Engineering Rescue Disk Setup" \
            --no-tags \
            --msgbox "Defaults loaded." \
            6 30
      elif test $RC -eq 0 && test "x${RESULT}" == "xrevert";then
         prereqs
         dialog \
            --backtitle "IP Engineering Rescue Disk Setup" \
            --no-tags \
            --msgbox "Changes reverted." \
            6 30
      fi
   done

   return 0;
}


configure_all()
{
   # enable all options
   for DISTRO in $(list_distros);do
      if test -f ${DISTRODIR}/${DISTRO}/options;then
         list_vers ${DISTRODIR}/${DISTRO}/options 
      elif test -f ${DISTRODIR}/${DISTRO}/option;then
         list_vers_opts ${DISTRODIR}/${DISTRO}/option |grep ' on$'
         if test $? -ne 0;then
            list_vers_opts ${DISTRODIR}/${DISTRO}/option |tail -1
         fi
      fi
   done |awk '{print$1}' |sed -e 's/^/#/g' |sort -n > ${CONFIG}.new.tmp

   # set variables
   echo "CONFIG_PART_TYPE=${CONFIG_PART_TYPE}" >> ${CONFIG}.new.tmp
   echo "CONFIG_PART_SIZE=${CONFIG_PART_SIZE}" >> ${CONFIG}.new.tmp
   echo "CONFIG_IMG_SIZE=${CONFIG_IMG_SIZE}" >> ${CONFIG}.new.tmp
   echo "CONFIG_ISO_TYPE=${CONFIG_ISO_TYPE}" >> ${CONFIG}.new.tmp

   # copy new settings into place
   mv ${CONFIG}.new.tmp ${CONFIG}.new

   # confirm change
   dialog \
      --backtitle "IP Engineering Rescue Disk Setup" \
      --no-tags \
      --msgbox "All images configured." \
      6 30
}


configure_disk()
{
   # enter main loop
   while test true;do

      # display main menu
      exec 3>&1
      RESULT="$(echo "" | xargs dialog \
         --title " Disk Options " \
         --backtitle "IP Engineering Rescue Disk Setup" \
         --ok-label "Change" \
         --cancel-label "Back" \
         --menu "Select option to configure:" \
         20 70 13 \
         "usb"       "USB partition type (${CONFIG_PART_TYPE})" \
         "size"      "USB disk image size (${CONFIG_IMG_SIZE} MB)" \
         "iso"       "ISO partition type (${CONFIG_ISO_TYPE})" \
         2>&1 1>&3)"
      RC=$?
      exec 3>&-
      echo " "

      # inteprets selection
      if test $RC -eq 124;then # (exit)
         return 0;
      elif test $RC -eq 0 && test "x${RESULT}" == "xusb";then
         TMP_GPT=off; TMP_MBR=off; TMP_HYB=off;
         case "x${CONFIG_PART_TYPE}" in
            xgpt) TMP_GPT=on;;
            xhyb) TMP_HYB=on;;
            xmbr) TMP_MBR=on;;
            *)    TMP_HYB=on;;
         esac
         exec 3>&1
         RESULT="$(echo "" | xargs dialog \
            --title " USB Disk Parition Type " \
            --backtitle "IP Engineering Rescue Disk Setup" \
            --radiolist "Choose partition type:" \
            20 70 13 \
            "gpt"    "GUID Partition Table (UEFI)"      ${TMP_GPT} \
            "hybrid" "Hybrid (GPT and MBR)"             ${TMP_HYB} \
            "mbr"    "Master Boot Record (Legacy BIOS)" ${TMP_MBR} \
            2>&1 1>&3)"
         RC=$?
         exec 3>&-
         CONFIG_PART_TYPE="${RESULT}"
      elif test $RC -eq 0 && test "x${RESULT}" == "xsize";then
         exec 3>&1
         RESULT="$(echo "" | xargs dialog \
            --title " USB Disk Image Size " \
            --backtitle "IP Engineering Rescue Disk Setup" \
            --inputbox "Enter size of disk image file:" \
            9 40 ${CONFIG_IMG_SIZE} \
            2>&1 1>&3)"
         RC=$?
         exec 3>&-
         if test -z "${RESULT//[0-9]/}";then
            CONFIG_IMG_SIZE=$RESULT
         else
            dialog \
               --backtitle "IP Engineering Rescue Disk Setup" \
               --msgbox "Invalid disk image size.  Size must be specified as number of megabytes." \
               7 40
         fi
      elif test $RC -eq 0 && test "x${RESULT}" == "xiso";then
         TMP_UEFI=off; TMP_HYBRID=off; TMP_BIOS=off;
         case "x${CONFIG_ISO_TYPE}" in
            xuefi)   TMP_UEFI=on;;
            xhybrid) TMP_HYBRID=on;;
            xbios)   TMP_BIOS=on;;
            *)       TMP_BIOS=on;;
         esac
         exec 3>&1
         RESULT="$(echo "" | xargs dialog \
            --title " ISO Disk Type " \
            --backtitle "IP Engineering Rescue Disk Setup" \
            --radiolist "Choose ISO image type:" \
            20 70 13 \
            "uefi"   "GUID Partition Table (UEFI)"      ${TMP_UEFI} \
            "hybrid" "Hybrid (GPT and MBR)"             ${TMP_HYBRID} \
            "bios"   "Master Boot Record (Legacy BIOS)" ${TMP_BIOS} \
            2>&1 1>&3)"
         RC=$?
         exec 3>&-
         CONFIG_ISO_TYPE="${RESULT}"
      fi
   done
}


configure_distros()
{
   # loop until exit
   while test true;do
      # prompt for OS distributions
      exec 3>&1
      RESULT="$(list_distros \
         |xargs dialog \
            --title " Boot Distributions " \
            --backtitle "IP Engineering Rescue Disk Setup" \
            --no-tags \
            --ok-label "Configure" \
            --cancel-label "Back" \
            --menu "Choose distributions to install:" \
            20 70 13 \
            2>&1 1>&3)"
      RC=$?
      exec 3>&-

      # intepret the result
      if test $RC -ne 0;then
         return 0;
      else
         configure_image "${RESULT}"
      fi
   done
}


configure_image()
{
   DISTRO="${1}"

   # determine option file
   if test -f ${DISTRODIR}/${DISTRO}/option;then
      COUNT=$(grep "^#${DISTRO}-" ${CONFIG}.new |wc -l)
      if test $COUNT -eq 0;then
         SKIP=on
      else
         SKIP=off
      fi
      exec 3>&1
      RESULT="$(list_vers_opts ${DISTRODIR}/${DISTRO}/option \
         |xargs dialog \
            --no-tags \
            --title " Boot Images " \
            --backtitle "IP Engineering Rescue Disk Setup" \
            --radiolist "Choose image to install:" \
            20 70 13 \
            "____SKIP____" "Do not install" $SKIP \
            2>&1 1>&3)"
      RC=$?
      exec 3>&-
   elif test -f ${DISTRODIR}/${DISTRO}/options;then
      exec 3>&1
      RESULT="$(list_vers_opts ${DISTRODIR}/${DISTRO}/options \
         |xargs dialog \
            --no-tags \
            --title " Boot Images " \
            --backtitle "IP Engineering Rescue Disk Setup" \
            --checklist "Choose images to install:" \
            20 70 13 \
            2>&1 1>&3)"
      RC=$?
      exec 3>&-
   else
      return 0
   fi

   # test result
   if test $RC -ne 0;then
      return 0;
   fi
   if test "${RESULT}" == "____SKIP____";then
      return 0;
   fi

   # update configuration
   grep -v "^#${DISTRO}-" "${CONFIG}.new" > "${CONFIG}.new.tmp"
   for IMAGE in ${RESULT};do
      echo "#$IMAGE" >> "${CONFIG}.new.tmp"
   done
   sort -n "${CONFIG}.new.tmp" > "${CONFIG}.new"
}


deps()
{
   # save variables
   for STR in "CONFIG_PART_TYPE" "CONFIG_IMG_SIZE" "CONFIG_ISO_TYPE";do
      egrep "^${STR}=" "${CONFIG}.new" > /dev/null
      if test $? -ne 0;then
         echo "${STR}=" >> "${CONFIG}.new"
      fi
   done
   sed \
      -e "s/^CONFIG_ISO_TYPE=.*$/CONFIG_ISO_TYPE=${CONFIG_ISO_TYPE}/g" \
      -e "s/^CONFIG_IMG_SIZE=.*$/CONFIG_IMG_SIZE=${CONFIG_IMG_SIZE}/g" \
      -e "s/^CONFIG_PART_TYPE=.*$/CONFIG_PART_TYPE=${CONFIG_PART_TYPE}/g" \
      -e "s/^CONFIG_PART_SIZE=.*$/CONFIG_PART_SIZE=${CONFIG_PART_SIZE}/g" \
      "${CONFIG}.new" \
      > "${CONFIG}.new.tmp"
   mv "${CONFIG}.new.tmp" "${CONFIG}.new"

   # save new config
   mv "${CONFIG}.new" "${CONFIG}" || exit 1

   # build Makefile configuration
   rm -f ${BASEDIR}/Makefile.config
   {
      echo "ISOTYPE	?= ${CONFIG_ISO_TYPE}"
      echo "DISKSIZE	?= ${CONFIG_IMG_SIZE}"
      echo "DISKTYPE	?= ${CONFIG_PART_TYPE}"
      echo "PARTSIZE	?= ${CONFIG_PART_SIZE}"
      for DISTRO in $(egrep '^#[[:alnum:]]+-' "${CONFIG}" |cut -d- -f1 |cut -d'#' -f2 |sort |uniq);do
         if test -f "${DISTRODIR}/${DISTRO}/make.header";then
            cat "${DISTRODIR}/${DISTRO}/make.header"
         fi
         for VERS in $(egrep "^#${DISTRO}-" "${CONFIG}");do
            VERSION=$(echo "${VERS}" |cut -d- -f2)
            CODENAME=$(echo "${VERS}" |cut -d- -f3)
            ARCH=$(echo "${VERS}" |cut -d- -f4)
            if test -f "${DISTRODIR}/${DISTRO}/make.boot";then
               sed \
                  -e "s/@VERSION@/${VERSION}/g" \
                  -e "s/@CODENAME@/${CODENAME}/g" \
                  -e "s/@DISTRO@/${DISTRO}/g" \
                  -e "s/@ARCH@/${ARCH}/g" \
                  -e "s/@LABEL@/${LABEL}/g" \
                  "${DISTRODIR}/${DISTRO}/make.boot"
            fi
         done
         if test -f "${DISTRODIR}/${DISTRO}/make.footer";then
            cat "${DISTRODIR}/${DISTRO}/make.footer"
         fi
      done 
   } >  ${BASEDIR}/Makefile.config
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


prereqs()
{
   trap cleanup EXIT

   rm -f "${CONFIG}.new" || exit 1
   if test -f "${CONFIG}";then
      egrep -i "^#[a-z0-9_]{1,}-" "${CONFIG}" \
         |awk '{print$1}' \
         |sort \
         |uniq \
         > "${CONFIG}.new"
   else
      touch "${CONFIG}.new" || exit 1
   fi

   if test ! -f "${CONFIG}.new";then
      exit 1
   fi
}


####################
#                  #
#  Body of Script  #
#                  #
####################


# prompt for images to install
case "${ACTION}" in

   configure)
   prereqs   || exit 1
   configure || exit 1
   exit 0
   ;;


   deps)
   prereqs || exit 1
   deps    || exit 1
   exit 0
   ;;


   *)
   echo "Usage: ${PROG_NAME} [ configure | deps ]" 1>&2
   exit 1
   ;;
esac

# end of script
