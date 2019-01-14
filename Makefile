


all:
	make prepare
	make copy
	make build

prepare:
	test -d ipxe || git clone -v \
	http://git.ipxe.org/ipxe.git ipxe
	cd ipxe && git fetch
	echo '#!/bin/sh' > version.sh
	chmod 755 version.sh
	cd ipxe && \
	LOCAL=$$(git log -1 --date=short --format=%cd-%h origin/master) && \
	echo echo $$LOCAL >> ../version.sh
	./version.sh

copy:
	rm -rf ipxe-efi/
	cd ipxe && git archive --format=tar.gz --prefix=ipxe-efi/ \
	-o ../.ipxe-efi_orig.tar.gz origin/master
	tar -xzf .ipxe-efi_orig.tar.gz
	mv .ipxe-efi_orig.tar.gz ipxe-efi_$$(./version.sh).orig.tar.gz
	cp debian -R ipxe-efi/

build:
	cd ipxe-efi/ && dch --distribution unstable \
	-bv $$(../version.sh)-001 'New version' 
	cd ipxe-efi/ && dpkg-buildpackage
	
