#ifndef PANIC_H
#define PANIC_H

#include <stdint.h>
#include <iomem.h>
#include <cpu/xtypes.h>

#define PANIC(msg) panic(msg, __FILE__, __LINE__);
#define ASSERT(b) ((b) ? (void)0 : panic_assert(__FILE__, __LINE__, #b))

void panic(char *err, struct regs *regs);
void panic_assert(const char *file, u32int line, const char *desc);

#endif
