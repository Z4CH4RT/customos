#include <stdint.h>

volatile uint16_t* vga = (uint16_t*)0xB8000;

void kernel_main(void) {
    const char* msg = "Hello from C kernel";
    for (int i = 0; msg[i]; i++) {
        vga[i] = (0x0F << 8) | msg[i];
    }

    while (1) {
        __asm__("hlt");
    }
}