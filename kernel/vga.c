#include <vga.h>

#define VGA_WIDTH 80
#define VGA_HEIGHT 25

static uint16_t* const vga_buffer = (uint16_t*)0xB8000;

static size_t row;
static size_t col;
static uint8_t color;

static inline uint16_t vga_entry(char c, uint8_t color) {
    return (uint16_t)c | (uint16_t)color << 8;
}

static void scroll(void) {
    for (size_t y = 1; y < VGA_HEIGHT; y++) {
        for (size_t x = 0; x < VGA_WIDTH; x++) {
            vga_buffer[(y - 1) * VGA_WIDTH + x] =
                vga_buffer[y * VGA_WIDTH + x];
        }
    }

    for (size_t x = 0; x < VGA_WIDTH; x++) {
        vga_buffer[(VGA_HEIGHT - 1) * VGA_WIDTH + x] =
            vga_entry(' ', color);
    }

    row = VGA_HEIGHT - 1;
    col = 0;
}

void vga_init(void) {
    row = 0;
    col = 0;
    vga_set_color(VGA_LIGHT_GREY, VGA_BLACK);

    for (size_t y = 0; y < VGA_HEIGHT; y++) {
        for (size_t x = 0; < VGA_WIDTH; x++) {
            vga_buffer[y * VGA_WIDTH + x] =
                vga_entry(' ', color);
        }
    }
}

void vga_set_color(uint8_t fg, uint8_t bg) {
    color = fg | bg << 4;
}

void vga_putc(char c) {
    if (c == '\n') {
        col = 0;
        if (++row == VGA_HEIGHT)
            scroll();
        return;
    }

    vga_buffer[row * VGA_WIDTH + col] =
        vga_entry(c, color);

    if (++col == VGA_WIDTH) {
        col = 0;
        if (++row == VGA_HEIGHT)
            scroll();
    }
}

void vga_write(const char* str) {
    for (size_t i = 0; str[i]; i++)
        vga_putc(str[i]);
}