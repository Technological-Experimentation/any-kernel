all:
	nasm -f elf64 boot/start.asm -o boot/start.o
	gcc -c kern/main.c -o kern/main.o
	ld.lld -T link.ld kern/main.o boot/start.o -o image.elf