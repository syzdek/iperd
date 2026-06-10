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
CLEANFILES		+=


THEME_DEPENDENCIES	:= src/dejavu/.iperd \
			   var/grub/.iperd \
			   src/unifont/.iperd
THEME_FONTS		:= tools/share/grub/themes/iperd/dejavu_10.pf2 \
			   tools/share/grub/themes/iperd/dejavu_12.pf2 \
			   tools/share/grub/themes/iperd/dejavu_14.pf2 \
			   tools/share/grub/themes/iperd/dejavu_14_bold.pf2 \
			   tools/share/grub/themes/iperd/dejavu_14_bolditalic.pf2 \
			   tools/share/grub/themes/iperd/dejavu_16.pf2 \
			   tools/share/grub/themes/iperd/dejavu_18.pf2
THEME_FILES		:= src/themes/iperd/desktop.png \
			   src/themes/iperd/menu_c.png \
			   src/themes/iperd/menu_e.png \
			   src/themes/iperd/menu_n.png \
			   src/themes/iperd/menu_ne.png \
			   src/themes/iperd/menu_nw.png \
			   src/themes/iperd/menu_s.png \
			   src/themes/iperd/menu_se.png \
			   src/themes/iperd/menu_sw.png \
			   src/themes/iperd/menu_w.png \
			   src/themes/iperd/select_c.png \
			   src/themes/iperd/select_e.png \
			   src/themes/iperd/select_n.png \
			   src/themes/iperd/select_ne.png \
			   src/themes/iperd/select_nw.png \
			   src/themes/iperd/select_s.png \
			   src/themes/iperd/select_se.png \
			   src/themes/iperd/select_sw.png \
			   src/themes/iperd/select_w.png \
			   src/themes/iperd/slider_c.png \
			   src/themes/iperd/slider_n.png \
			   src/themes/iperd/slider_s.png \
			   src/themes/iperd/terminal_c.png \
			   src/themes/iperd/terminal_e.png \
			   src/themes/iperd/terminal_n.png \
			   src/themes/iperd/terminal_ne.png \
			   src/themes/iperd/terminal_nw.png \
			   src/themes/iperd/terminal_s.png \
			   src/themes/iperd/terminal_se.png \
			   src/themes/iperd/terminal_sw.png \
			   src/themes/iperd/terminal_w.png \
			   src/themes/iperd/theme.txt


tools/share/grub/themes/iperd/.iperd: $(THEME_DEPENDENCIES) $(THEME_FILES)
	@rm -Rf grub/themes/iperd
	mkdir -p tools/share/grub/themes
	rsync -ra --delete src/themes/iperd/ tools/share/grub/themes/iperd
	@touch $(@)


tools/share/grub/themes/iperd/dejavu_10.pf2: src/dejavu/source/ttf/DejaVuSansMono.ttf tools/share/grub/themes/iperd/.iperd
	rm -f $(@)
	./tools/bin/grub-mkfont --verbose --output=$(@) --size=10 $(<)
	@touch $(@)


tools/share/grub/themes/iperd/dejavu_12.pf2: src/dejavu/source/ttf/DejaVuSansMono.ttf tools/share/grub/themes/iperd/.iperd
	rm -f $(@)
	./tools/bin/grub-mkfont --verbose --output=$(@) --size=12 $(<)
	@touch $(@)


tools/share/grub/themes/iperd/dejavu_14.pf2: src/dejavu/source/ttf/DejaVuSansMono.ttf tools/share/grub/themes/iperd/.iperd
	rm -f $(@)
	./tools/bin/grub-mkfont --verbose --output=$(@) --size=14 $(<)
	@touch $(@)


tools/share/grub/themes/iperd/dejavu_14_bold.pf2: src/dejavu/source/ttf/DejaVuSansMono-Bold.ttf tools/share/grub/themes/iperd/.iperd
	rm -f $(@)
	./tools/bin/grub-mkfont --verbose --output=$(@) --size=14 $(<)
	@touch $(@)


tools/share/grub/themes/iperd/dejavu_14_bolditalic.pf2: src/dejavu/source/ttf/DejaVuSansMono-BoldOblique.ttf tools/share/grub/themes/iperd/.iperd
	rm -f $(@)
	./tools/bin/grub-mkfont --verbose --output=$(@) --size=14 $(<)
	@touch $(@)


tools/share/grub/themes/iperd/dejavu_16.pf2: src/dejavu/source/ttf/DejaVuSansMono.ttf tools/share/grub/themes/iperd/.iperd
	rm -f $(@)
	./tools/bin/grub-mkfont --verbose --output=$(@) --size=16 $(<)
	@touch $(@)


tools/share/grub/themes/iperd/dejavu_18.pf2: src/dejavu/source/ttf/DejaVuSansMono.ttf tools/share/grub/themes/iperd/.iperd
	rm -f $(@)
	./tools/bin/grub-mkfont --verbose --output=$(@) --size=18 $(<)
	@touch $(@)



src/themes/.iperd: $(THEME_FONTS)
	@touch $(@)


# end of makefile
