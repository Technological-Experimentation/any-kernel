QEMU            = qemu-system-x86_64
QEMUFLAGS       = -m 1G -enable-kvm -cpu host -serial stdio -M q35 -cdrom

grub: nova
	@$(MAKE) -C guest/ all --no-print-directory
	cp guest/image.elf iso/boot/
	cp NOVA/build-x86_64/x86_64-nova iso/boot/hypervisor-x86_64
	grub-mkrescue -o any.iso iso/

limine: nova
	git clone https://github.com/limine-bootloader/limine.git --branch=v3.9-binary --depth=1 || echo ""
	make -C limine

	rm -rf iso_root
	mkdir -p iso_root
	cp guest/image.elf NOVA/build-x86_64/x86_64-nova \
		limine.cfg limine/limine.sys limine/limine-cd.bin limine/limine-cd-efi.bin iso_root/
	mv iso_root/x86_64-nova iso_root/hypervisor-x86_64

	xorriso -as mkisofs -b limine-cd.bin \
		-no-emul-boot -boot-load-size 4 -boot-info-table \
		--efi-boot limine-cd-efi.bin \
		-efi-boot-part --efi-boot-image --protective-msdos-label \
		iso_root -o any.iso
	limine/limine-deploy any.iso
	rm -rf iso_root
	
nova:
	git clone https://github.com/Udosteinberg/NOVA || echo ""
	@$(MAKE) -C NOVA/ ARCH=x86_64 --no-print-directory

guest/clean:
	@$(MAKE) -C guest/ clean --no-print-directory

hypervisor/clean:
	@$(MAKE) -C NOVA/ clean --no-print-directory

clean:
	@$(MAKE) -C NOVA/ clean --no-print-directory
	@$(MAKE) -C guest/ clean --no-print-directory
	rm -rf any.iso

run:
	$(QEMU) $(QEMUFLAGS) any.iso

uefi:
	$(QEMU) -bios /usr/share/ovmf/OVMF.fd $(QEMUFLAGS) any.iso