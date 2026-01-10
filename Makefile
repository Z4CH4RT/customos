CC = x86_64-elf-gcc
AS = nasm
LD = x86_64-elf-LD

CFLAGS = -ffreestanding -O2 -Wall -Wextra -m64
LDFLAGS = -T linker.ld -nostdlib

all: kernel.bin

kernel.bin:
	$(AS) -f elf64 boot/boot.asm -o boot.o
	$(CC) $(CFLAGS) -c kernel/kernel.c -o kernel.o
	$(LD) $(LDFLAGS) boot.o kernel.o -o kernel.bin

iso:
	mkdir -p iso/boot/grub
	cp kernel.bin iso/boot/
	cp grub.cfg iso/boot/grub/
	grub-mkrescue -o os.iso iso

run:
	qemu-system-x86_64 -cdrom os.iso

