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


DISTCLEANFILES		+=
CLEANFILES              +=


UNIFONT_VERSION		:= 17.0.04
UNIFONT_MIRROR		:= https://unifoundry.com/pub/unifont/unifont-$(UNIFONT_VERSION)/font-builds/unifont-$(UNIFONT_VERSION).bdf.gz
UNIFONT_SHA1		:= ae0dcc91404d1c5203c29ff11322a3a5b87b3083
UNIFONT_SHA256		:= 9a2de4826388242771121c7fe00e412523c318318b8ee38e6be6cd454e7ec802
UNIFONT_SHA512		:= ad67446632a58f0b3b8a428ea8601e4ad9dfd4d2b1f11e481a2f9dedcf539423ec1c7fb508849c1d535c8a811ce9ccd321c9474035f9ad36950b42e77206a3ea
UNIFONT_ROOT		:= $(IPERD_ROOT)/build/unifont


build/unifont/unifont-$(UNIFONT_VERSION).bdf.gz:
	@mkdir -p "$(@D)"
	@WGET_FILE="$(@)"; \
		WGET_URL="$(UNIFONT_MIRROR)"; \
		WGET_SHA1="$(UNIFONT_SHA1)"; \
		WGET_SHA256="$(UNIFONT_SHA256)"; \
		WGET_SHA512="$(UNIFONT_SHA512)"; \
		$(do_wget);
	@touch $(@)


build/unifont/source/unifont.bdf: build/unifont/unifont-$(UNIFONT_VERSION).bdf.gz
	@mkdir -p "$(@D)"
	@GZIP_FILE="$(^)"; GZIP_DST="$(@)"; $(do_gzip);
	@touch $(@)


build/unifont/.iperd: build/unifont/source/unifont.bdf
	@touch $(@)


# end of makefile
