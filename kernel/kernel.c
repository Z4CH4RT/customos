#include "vga.h"

void kernel_main(void) {
    vga_init();
    vga_set_color(VGA_LIGHT_GREEN, VGA_BLACK);

    vga_write("VGA driver online!\n");
    vga_write("Scrolling test:\n");

    for (int i = 0; i < 30; i++) {
        vga_write("Line ");
        vga_putc('0' + (i % 10));
        vga_putc('\n');
    }

    for (;;)
        __asm__("hlt");
}
