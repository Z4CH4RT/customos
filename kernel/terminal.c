#include "terminal.h"
#include "vga.h"

static const char* PROMPT = "> ";

void term_init(void) {
    vga_init();
    vga_write("LuisSYS\n");
    term_prompt();
}

void term_putchar(char c) {
    vga_putc(c);
}

void term_write(const char* s) {
    vga_write(s);
}

void term_prompt(void) {
    vga_write(PROMPT);

}

