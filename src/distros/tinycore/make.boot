
DOWNLOAD_FILES		+=  boot/tinycore/@VERSION@/core.gz \
			   boot/tinycore/@VERSION@/vmlinuz
CLEANFILES		+= cde/


tmp/boot/tinycore/tinycore-@VERSION@/.iperd-extracted:
	./src/scripts/download.sh \
	   -H src/distros/tinycore/hashes//tinycore-@VERSION@.sha512 \
	   -e tmp/boot/tinycore/tinycore-@VERSION@ \
	   tmp/boot/tinycore/tinycore-@VERSION@.iso \
	   $(MIRROR_TINYCORE)/@CODENAME@/x86/release/TinyCore-@VERSION@.iso


cde/iperd-synced: tmp/boot/tinycore/tinycore-@VERSION@/.iperd-extracted
	rsync -ra tmp/boot/tinycore/tinycore-@VERSION@/cde/ cde
	@chmod -R u+w cde
	@touch "$(@)"


boot/tinycore/@VERSION@/core.gz: cde/iperd-synced
	@mkdir -p "$$(dirname "$(@)")"
	cp tmp/boot/tinycore/tinycore-@VERSION@/boot/core.gz "$(@)"
	@test -f "$(@)" && touch "$(@)"


boot/tinycore/@VERSION@/vmlinuz: cde/iperd-synced
	@mkdir -p "$$(dirname "$(@)")"
	cp tmp/boot/tinycore/tinycore-@VERSION@/boot/vmlinuz "$(@)"
	@test -f "$(@)" && touch "$(@)"

