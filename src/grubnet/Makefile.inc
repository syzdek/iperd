#
#   IP Engineering Rescue Disk
#   Copyright (C) 2026 David M. Syzdek <david@syzdek.net>.
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

DISTCLEANFILES			+=
CLEANFILES			+=


GRUBNET_MODULES			= http tftp net gzio \
				  all_video video video_bochs video_cirrus \
				  video_fb videoinfo \
				  serial terminfo terminal \
				  search search_fs_file search_fs_uuid \
				  search_label \
				  udf iso9660 ext2 fat exfat ntfs hfsplus lvm \
				  part_gpt part_msdos msdospart \
				  diskfilter parttool probe normal \
				  acpi ohci uhci ahci ehci \
				  cat ls chain configfile echo halt reboot \
				  ls lsmmap lspci lsacpi \
				  linux


boot/grub/.iperd: src/grub/.iperd src/themes/.iperd
	@rm -Rf grub
	./tools/bin/grub-mknetdir \
	   --modules="$(GRUBNET_MODULES)" \
	   --themes="starfield iperd" \
           --compress=xz \
	   --core-compress=xz \
	   --net-directory=$(IPERD_ROOT) \
	   --subdir=/boot/grub
	find boot/grub -type f -exec chmod go+r  {} \; || exit 1;
	find boot/grub -type d -exec chmod go+rx {} \; || exit 1;
	@touch $(@)


src/grubnet/.iperd: boot/grub/.iperd
	@touch $(@)


# end of makefile
