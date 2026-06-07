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

DISTCLEANFILES		+= iperd-*.iso
CLEANFILES		+= src/images/.iperd


iperd-$(IPERD_VERSION).iso: src/images/Makefile.inc $(IPERD_DEPS) .config
	@rm -f "$(@)"
	./tools/bin/grub-mkrescue \
	   --compress=xz  \
	   --core-compress=xz \
	   -o "$(@).new" \
	   -m '*.iso' \
	   -m '*.new' \
	   -m '*.swp' \
	   -m '.git' \
	   -m '.gitignore' \
	   -m '.iperd' \
	   -m 'src/*/source' \
	   -m 'src/distros/*/grub.d' \
	   -m 'src/distros/*/source' \
	   -m 'tools/' \
	   -volid IPERD \
	   -publisher "IP Engineering Rescue Disk $(IPERD_VERSION) (iperd.org)" \
	   ./
	@mv "$(@).new" "$(@)"
	@touch "$(@)"


src/images/.iperd: iperd-$(IPERD_VERSION).iso
	@touch "$(@)"


# end of makefile
