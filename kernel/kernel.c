#include "vga.h"

void kernel_main(void) {
    term_init();

    for (;;)
        __asm__("hlt");
}