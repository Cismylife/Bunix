/*
 * Bunix, Bunny + Unix
 * Authored by: Cismylife
 *
 */

#include "bunix.h"

#define halt() for(;;);
extern u32int  start_esp;

int hilix_main(struct multiboot *mboot_ptr, u32int initial_stack)
{
	extern u32int placement_address;
	int kernel_ticks 	= 0;
	start_esp		= initial_stack;


	init_console();
	print("HiliX 0.2.0 (by AIXEL Systems Team..Ltd)\n\n");

	init_descriptors();

	ASSERT(mboot_ptr->mods_count > 0);
	u32int initrd_location	= *((u32int*)mboot_ptr->mods_addr);
	u32int initrd_end	= *(u32int*)(mboot_ptr->mods_addr+4);

	placement_address	= initrd_end;

	timer_install(50);	// set the PIT to run at 50Hz.
	keyboard_install();	// install the keboard

	asm volatile("sti");	// re-enable interrupts

	init_paging();
	initialise_tasking();

	fs_root			= initialise_initrd(initrd_location);

	init_syscalls();

	switch_to_user_mode();

	// loop forever to keep the Operating System alive
	for(;;);
}
