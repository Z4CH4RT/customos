CROSS   ?= x86_64-elf-
CC      := $(CROSS)gcc
LD      := $(CROSS)ld
AS      := nasm

CFLAGS  := -ffreestanding -O2 -Wall -Wextra -m64
LDFLAGS := -T linker.ld -nostdlib

KERNEL  := kernel.bin
ISO     := os.iso

all: $(KERNEL)

$(KERNEL): boot.o kernel.o
	$(LD) $(LDFLAGS) boot.o kernel.o -o $(KERNEL)

boot.o: boot/boot.asm
	$(AS) -f elf64 $< -o $@

kernel.o: kernel/kernel.c
	$(CC) $(CFLAGS) -c $< -o $@

iso: $(ISO)

$(ISO): $(KERNEL) grub.cfg
	mkdir -p iso/boot/grub
	cp $(KERNEL) iso/boot/kernel.bin
	cp grub.cfg iso/boot/grub/grub.cfg
	grub-mkrescue -o $(ISO) iso

run: $(ISO)
	qemu-system-x86_64 -cdrom $(ISO)

clean:
	rm -rf *.o iso $(ISO) $(KERNEL)
