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


DISTCLEANFILES		+= src/dejavu/dejavu-fonts-ttf-*.tar.bz2 \
			   src/dejavu/source/ \
			   src/dejavu/.iperd
CLEANFILES              += src/dejavu/dejavu-fonts-ttf-*.tar.bz2.new


DEJAVU_VERSION		:= 2.37
DEJAVU_MIRROR		:= https://github.com/dejavu-fonts/dejavu-fonts/releases/download/version_2_37/dejavu-fonts-ttf-$(DEJAVU_VERSION).tar.bz2
DEJAVU_SHA1		:= 7fa15e7b9676fc3915338c41e76ad454c344fff5
DEJAVU_SHA256		:= fa9ca4d13871dd122f61258a80d01751d603b4d3ee14095d65453b4e846e17d7
DEJAVU_SHA512		:= bafa39321021097432777f0825d700190c23f917d754a4504722cd8946716c22c083836294dab7f3ae7cf20af63c4d0944f3423bf4aa25dbca562d1f30e00654
DEJAVU_ROOT		:= $(IPERD_ROOT)/src/dejavu


src/dejavu/dejavu-fonts-ttf-$(DEJAVU_VERSION).tar.bz2:
	@rm -f $(@) $(@).new
	wget -q -O $(@).new "$(DEJAVU_MIRROR)"
	@echo "$(DEJAVU_SHA1) $(@).new"   |sha1sum   --check > /dev/null
	@echo "$(DEJAVU_SHA256) $(@).new" |sha256sum --check > /dev/null
	@echo "$(DEJAVU_SHA512) $(@).new" |sha512sum --check > /dev/null
	mv $(@).new $(@)
	@touch $(@)


src/dejavu/source/.iperd: src/dejavu/dejavu-fonts-ttf-$(DEJAVU_VERSION).tar.bz2
	@rm -Rf src/dejavu/source
	@mkdir  src/dejavu/source
	tar -C  src/dejavu/source -xf src/dejavu/dejavu-fonts-ttf-$(DEJAVU_VERSION).tar.bz2 --strip-components=1
	@touch $(@)


src/dejavu/.iperd: src/dejavu/source/.iperd
	@touch $(@)


# end of makefile
