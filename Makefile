
CC = i586-elf-gcc
AS = nasm
LK = i586-elf-ld
OBJECTS = $(OBJDIR)/*.o
EXECTUABLE = ./kernel
CFLAGS = -g -m32 -fstrength-reduce -fno-builtin-time -fno-builtin-puts -fno-builtin-printf -fno-builtin-function -finline-functions -nostdinc -fno-stack-protector -fomit-frame-pointer -nostdlib  $(IDIRS)
LDFLAGS = -Tetc/link.ld -melf_i386
ASFLAGS = -Werror -felf
IDIRS = -Ikernel/ -Ikernel/lib -Ikernel/io
OBJDIR = build/objects

hilix:
	@mkdir -p build
	@mkdir -p build/objects
	@echo "Compiling the kernel..."
	@$(CC) -m32 -c kernel/hilix.c $(CFLAGS) 			-o $(OBJDIR)/hilix.o
	@$(CC) -m32 -c kernel/io/iomem.c $(CFLAGS) 			-o $(OBJDIR)/iomem.o
	@$(CC) -m32 -c kernel/tty/console.c $(CFLAGS) 			-o $(OBJDIR)/xnixconsole.o
	@$(CC) -m32 -c kernel/lib/stdio.c $(CFLAGS) 			-o $(OBJDIR)/stdio.o
	@$(CC) -m32 -c kernel/lib/stdlib.c $(CFLAGS) 			-o $(OBJDIR)/stdlib.o
	@$(CC) -m32 -c kernel/cpu/gdt/gdt.c $(CFLAGS) 		-o $(OBJDIR)/gdtc.o
	@$(CC) -m32 -c kernel/cpu/idt/idt.c $(CFLAGS) 		-o $(OBJDIR)/idt.o
	@$(CC) -m32 -c kernel/cpu/isrs/isrs.c $(CFLAGS) 		-o $(OBJDIR)/isrs.o
	@$(CC) -m32 -c kernel/cpu/irqs/irqs.c $(CFLAGS) 		-o $(OBJDIR)/irqs.o
	@$(CC) -m32 -c kernel/cpu/descriptors.c $(CFLAGS) 		-o $(OBJDIR)/descriptors.o
	@$(CC) -m32 -c kernel/cpu/handlers.c $(CFLAGS) 		-o $(OBJDIR)/handlers.o
	@$(CC) -m32 -c kernel/cpu/tss/tss.c $(CFLAGS)		-o $(OBJDIR)/tss.o
	@$(CC) -m32 -c kernel/io/kb/kb.c $(CFLAGS) 			-o $(OBJDIR)/kb.o
	@$(CC) -m32 -c kernel/io/kb/kbbuffer.c $(CFLAGS)		-o $(OBJDIR)/kbbuffer.o
	@$(CC) -m32 -c kernel/io/kb/layouts/us/qwerty/map.c $(CFLAGS) 	-o $(OBJDIR)/qwerty.o
	@$(CC) -m32 -c kernel/io/pit/pit.c $(CFLAGS) 			-o $(OBJDIR)/pit.o
	@$(CC) -m32 -c kernel/tty/spinner.c $(CFLAGS) 			-o $(OBJDIR)/spinner.o
	@$(CC) -m32 -c kernel/lib/panic.c $(CFLAGS) 			-o $(OBJDIR)/panic.o
	@$(CC) -m32 -c kernel/mem/ordered_array.c $(CFLAGS) 		-o $(OBJDIR)/ordered_array.o
	@$(CC) -m32 -c kernel/mem/paging.c $(CFLAGS) 			-o $(OBJDIR)/paging.o
	@$(CC) -m32 -c kernel/mem/malloc.c $(CFLAGS) 			-o $(OBJDIR)/malloc.o
	@$(CC) -m32 -c kernel/mem/heap.c $(CFLAGS) 			-o $(OBJDIR)/heap.o
	@$(CC) -m32 -c kernel/fs/fs.c $(CFLAGS) 			-o $(OBJDIR)/fs.o
	@$(CC) -m32 -c kernel/fs/initrd.c $(CFLAGS) 			-o $(OBJDIR)/initrd.o
	@$(CC) -m32 -c kernel/proc/task.c $(CFLAGS)			-o $(OBJDIR)/task.o
	@$(CC) -m32 -c kernel/sys/callhandler.c $(CFLAGS) 		-o $(OBJDIR)/callhandler.o
	@$(CC) -m32 -c kernel/io/rtc/rtc.c $(CFLAGS)			-o $(OBJDIR)/rtc.o
# TODO:	@$(CC) -m32 -c kernel/boot/param_parser.c $(CFLAGS)             -o $(OBJDIR)/param_parser.o

	@echo "Compiling the parts of the Assemblers."
	@$(AS) $(ASFLAGS) kernel/cpu/boot/prep/head.s 		-o $(OBJDIR)/head.o
	@$(AS) $(ASFLAGS) kernel/cpu/gdt/gdt.s 			-o $(OBJDIR)/gdtasm.o
	@$(AS) $(ASFLAGS) kernel/cpu/idt/idt.s 			-o $(OBJDIR)/idtasm.o
	@$(AS) $(ASFLAGS) kernel/cpu/isrs/isrs.s 			-o $(OBJDIR)/isrsasm.o
	@$(AS) $(ASFLAGS) kernel/cpu/irqs/irqs.s 			-o $(OBJDIR)/irqsasm.o
	@$(AS) $(ASFLAGS) kernel/mem/paging.s				-o $(OBJDIR)/pagingasm.o
	@$(AS) $(ASFLAGS) kernel/proc/process.s				-o $(OBJDIR)/processasm.o
 
	@echo "Running the linker..."
	@$(LK) $(LDFLAGS) -o build/kernel.bin $(OBJECTS)

	@echo "Build succuessful: kernel=build/kernel.bin"
help:
	@echo "NOTE: HiliX is kernel that built mostly from scratch. Do not complain why the kernel has the same code to others."
	@echo "List of commands for building the kernel"
	@echo "  "
	@echo "make clean    ---   Cleaning the build files"
	@echo "make floppy   ---   Making the floppy image"
	@echo "make          ---   Making the kernel"
	@echo "make github   ---   Upload your build to the repository"
	@echo " "
	
github: hilix
	@rm -rf build/kernel.bin
	@rm -rf build/floppy.img
	@rm -rf build/objects/*
	@git add --all
	git commit -m "Adding some utilites and programs for Hilix."
	git push -u origin master

clean:
	@rm -rf build/kernel.bin
	@rm -rf build/floppy.img
	@rm -rf build/objects/*
	@rm -rf etc/blog.txt etc/snapshot.txt

floppy: hilix
	@sudo /sbin/losetup /dev/loop0 etc/hilix.img
	@sudo mount /dev/loop0 /mnt2
	@sudo cp build/kernel.bin /mnt2/kernel
	@sudo cp build/hilix-harddisk.img /mnt2/hilix-harddisk
	@sleep 1
	@sudo umount /dev/loop0
	@sleep 1
	@sudo /sbin/losetup -d /dev/loop0
	@cp etc/hilix.img build/hilix.img
	
	@echo "Hilix-Build: build/hilix.img"

bochs: floppy
	@cd etc;xterm bochs&

kvm: floppy
	@kvm -fda build/hilix.img&
