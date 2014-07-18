#include "idt.h"
#include <stdint.h>
#include <iomem.h>
#include <stdio.h>
#include <tty/console.h>
#include <tty/colors.h>
#include <cpu/isrs/isrs.h>

struct idt_entry idt[256];
struct idt_ptr   idtp;

void idt_set_gate(u8int num, u32int base, u16int sel, u8int flags)
{
	idt[num].base_lo	= (base & 0xFFFF);
	idt[num].base_hi	= (base >> 16) & 0xFFFF;

	idt[num].sel		= sel;
	idt[num].always0	= 0;
	idt[num].flags		= flags | 0x60;
}

void idt_install()
{
	printc("Installing ", BLACK, LIGHT_CYAN);
	printc("IDT\n", BLACK, WHITE);

	idtp.limit	= (sizeof (struct idt_entry) * 256) - 1;
	idtp.base	= (u32int)&idt;

	memset(&idt, 0, sizeof(struct idt_entry) * 256);
	isrs_install();
}
