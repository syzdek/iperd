
DOWNLOAD_FILES          += boot/memtest/memtest-@VERSION@.bin


boot/memtest/memtest-@VERSION@.bin:
	@rm -f $(@)
	@mkdir -p $$(dirname "$(@)")
	./src/scripts/download.sh \
	   tmp/boot/memtest/memtest86-@VERSION@.bin.gz \
	   $(MIRROR_MEMTEST)/@VERSION@/memtest86+-@VERSION@.bin.gz
	gzip -cd tmp/boot/memtest/memtest86-@VERSION@.bin.gz > $(@)
	@touch "$(@)"

