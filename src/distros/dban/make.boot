
DOWNLOAD_FILES          += boot/dban/dban-@VERSION@-@ARCH@.bzi


tmp/boot/dban/dban-@VERSION@_@ARCH@/.iperd-extracted:
	./src/scripts/download.sh \
	   -H $(DBAN_HASHES)/dban-@VERSION@_@ARCH@.sha512 \
	   -e tmp/boot/dban/dban-@VERSION@_@ARCH@ \
	   boot/dban/dban-@VERSION@_@ARCH@.iso \
	   $(MIRROR_DBAN)/dban-@VERSION@/dban-@VERSION@_@ARCH@.iso


boot/dban/dban-@VERSION@-@ARCH@.bzi: tmp/boot/dban/dban-@VERSION@_@ARCH@/.iperd-extracted
	@mkdir -p "$$(dirname "$(@)")"
	cp tmp/boot/dban/dban-@VERSION@_@ARCH@/dban.bzi "$(@)"
	@test -f "$(@)" && touch "$(@)"


