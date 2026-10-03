CC      = clang
AS      = nasm
OBJCOPY = llvm-objcopy

CFLAGS  = -target i686-none-elf -ffreestanding -fno-pic -fno-stack-protector -O2 -g -Wall -Isrc/include -Isrc/drivers
ASFLAGS = -f elf32

BUILD = build

OBJS = $(BUILD)/entry.o

all: $(BUILD)/bios.bin

$(BUILD):
	mkdir -p $(BUILD)

$(BUILD)/entry.o: src/boot/entry.asm | $(BUILD)
	$(AS) $(ASFLAGS) $< -o $@

$(BUILD)/bios.elf: $(OBJS)
	ld.lld -flavor gnu -m elf_i386 -T linker/link.ld -nostdlib -o $@ $(OBJS)

$(BUILD)/bios.bin: $(BUILD)/bios.elf
	$(OBJCOPY) -O binary $< $@
	python -c "f=open('$(BUILD)/bios.bin','r+b'); f.seek(0,2); sz=f.tell(); pad=65536-sz; f.write(b'\xf4'*pad) if pad>0 else None; f.close()"

run:
	$(MAKE) all
	qemu-system-i386 -readconfig qemu/qemu.conf -bios $(BUILD)/bios.bin -monitor tcp:127.0.0.1:5555,server,nowait

run-gdb:
	$(MAKE) all
	qemu-system-i386 -readconfig qemu/qemu.conf -bios $(BUILD)/bios.bin -S -s -monitor tcp:127.0.0.1:5555,server,nowait

clean:
	rm -rf $(BUILD)

.PHONY: all run run-gdb clean