#include "terminal.h"

void kernel_main(void) {
    __asm__ volatile ("cli");
    
    term_init();

    for (;;)
        __asm__("hlt");

}

