#ifndef KB_H
#define KB_H

#include <iomem.h>
#include <cpu/xtypes.h>

int state;

void keyboard_handler(struct regs *r);
void keyboard_install();

#endif
