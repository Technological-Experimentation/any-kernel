QEMU            = qemu-system-x86_64
QEMUFLAGS       = -m 1G -enable-kvm -cpu host -serial stdio

grub: nova
	$(MAKE) -C guest/ all
	cp guest/image.elf iso/boot/
	cp NOVA/build/hypervisor-x86_64 iso/boot/hypervisor-x86_64
	grub-mkrescue -o any.iso iso/

limine: nova
	git clone https://github.com/limine-bootloader/limine.git --branch=v3.0-branch-binary --depth=1 || echo ""
	make -C limine

	rm -rf iso_root
	mkdir -p iso_root
	cp NOVA/build/hypervisor-x86_64 \
		limine.cfg limine/limine.sys limine/limine-cd.bin limine/limine-cd-efi.bin iso_root/
	xorriso -as mkisofs -b limine-cd.bin \
		-no-emul-boot -boot-load-size 4 -boot-info-table \
		--efi-boot limine-cd-efi.bin \
		-efi-boot-part --efi-boot-image --protective-msdos-label \
		iso_root -o any.iso
	limine/limine-deploy any.iso
	rm -rf iso_root

	
nova:
	git clone https://github.com/alex-ab/NOVA || echo ""
	$(MAKE) -C NOVA/build/ ARCH=x86_64

clean:
	$(MAKE) -C NOVA/build clean
	rm -rf any.iso

run:
	$(QEMU) $(QEMUFLAGS) any.iso