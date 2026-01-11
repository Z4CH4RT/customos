CROSS   ?= x86_64-elf-
CC      := $(CROSS)gcc
LD      := $(CROSS)ld
AS      := nasm

CFLAGS  := -ffreestanding -O2 -Wall -Wextra -m64 -Ikernel -mcmodel=kernel
ASFLAGS := -f elf64
LDFLAGS := -T linker.ld -nostdlib



KERNEL  := kernel.bin
ISO     := os.iso

all: $(KERNEL)


$(KERNEL): boot.o longmode.o kernel.o vga.o terminal.o
	$(LD) $(LDFLAGS) boot.o longmode.o kernel.o vga.o terminal.o -o $(KERNEL)

boot.o: boot/boot.asm
	$(AS) -f elf32 $< -o $@

kernel.o: kernel/kernel.c kernel/vga.h
	$(CC) $(CFLAGS) -c kernel/kernel.c -o kernel.o

vga.o: kernel/vga.c kernel/vga.h
	$(CC) $(CFLAGS) -c kernel/vga.c -o vga.o

terminal.o: kernel/terminal.c kernel/terminal.h kernel/vga.h
	$(CC) $(CFLAGS) -c kernel/terminal.c -o terminal.o


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
