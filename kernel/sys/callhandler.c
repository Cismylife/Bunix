#include "callhandler.h"
#include "stdint.h"
#include "stdio.h"
#include "stdlib.h"
#include "panic.h"
#include <iomem.h>
#include <tty/console.h>
#include <tty/colors.h>
#include <cpu/handlers.h>

void syscall_handler(registers_t *regs);

DEFN_SYSCALL1(print, 0, char*);

void *syscalls[1] =
{
	&print,
};

u32int num_syscalls = 1;

void syscall_handler(registers_t *regs)
{

	if (regs->eax >= num_syscalls)
		return;

	void *location	= syscalls[regs->eax];
	int ret;

	asm volatile("		\
		push %1;	\
		push %2;	\
		push %3;	\
		push %4;	\
		push %5;	\
		call *%6;	\
		pop %%ebx;	\
		pop %%ebx;	\
		pop %%ebx;	\
		pop %%ebx;	\
		pop %%ebx;	\
				" :  "=a"(ret) : "r" (regs->edi), "r" (regs->esi), "r" (regs->edx), "r" (regs->ecx), "r" (regs->ebx), "r" (location));
	regs->eax = ret;
}

void init_syscalls()
{
        interrupt_install_handler(0x7f, syscall_handler, "syscall handler");
}

