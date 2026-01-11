#pragma once
#include <stddef.h>
#include <stdint.h>

void vga_init(void);
void vga_putc(char c);
void vga_write(const char* str);
void vga_set_color(uint8_t fg, uint8_t bg);
