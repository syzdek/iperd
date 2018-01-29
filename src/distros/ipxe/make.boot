
DOWNLOAD_FILES          += $(FILES_IPXE)


tmp/boot/ipxe/ipxe/.iperd-extracted:
	./src/scripts/download.sh \
	   -e tmp/boot/ipxe/ipxe \
	   tmp/boot/ipxe/ipxe.iso \
	   $(MIRROR_IPXE)


boot/ipxe/ipxe.krn: tmp/boot/ipxe/ipxe/.iperd-extracted
	@mkdir -p "$$(dirname "$(@)")"
	cp tmp/boot/ipxe/ipxe/ipxe.krn "$(@)"
	@test -f "$(@)" && touch "$(@)"


