.PHONY: build clean

# Define the compiler
AS = arm-none-eabi-as
LD = arm-none-eabi-ld
OC = arm-none-eabi-objcopy

## List of assembly source files
AS_SRC := $(wildcard src/*.s)

## Path to linker script
LINKER_SCRIPT := linker/mmap.ld

## flags
#LDFLAGS := -T $(LINKER_SCRIPT)

## List of object files generated from assembly source files
OBJ_FILES := $(patsubst src/%.s, build/%.o, $(AS_SRC))

build: 
	nix-shell --run "make bin/hello.bin"

## Rule to create binary
bin/hello.bin: build/hello.elf
	mkdir -p bin
	$(OC) -O binary $< $@

## Rule to link object files into a bootable image
build/hello.elf: $(OBJ_FILES)
	mkdir -p map
	$(LD) -T $(LINKER_SCRIPT) -o $@ $(OBJ_FILES) -Map map/hello.map

## Rule to compile assembly files into object files
build/%.o: src/%.s
	mkdir -p build
	$(AS) -c $< -o $@ -a > $@.lst

# nix.objdump
DISASM := build/hello.o
nix.objdump:
	nix-shell --run "arm-none-eabi-objdump -d $(DISASM)"
	
# nix.gdbgui
nix.gdbgui:
	nix-shell --run "gdbgui"

# nix.qemu_zynq // Placeholder
nix.qemu_zynq:
	nix-shell --run "qemu-system-arm -M xilinx-zynq-a9 -m 256M -nographic -kernel build/kernel.bin"

# nix.qemuA8
nix.qemuA8: bin/hello.bin
	nix-shell --run "qemu-system-arm \
	-M realview-pb-a8 -m 32M \
	-no-reboot -nographic \
	-monitor telnet:127.0.0.1:1234,server,nowait \
	-kernel $< -S -gdb tcp::2159"

# nix.qemu
nix.qemu:
	nix-shell --run "qemu-arm -singlestep -g 1234 build/hello"

# nix.fmt
nix.fmt:
	nixfmt shell.nix

# Clean target
clean:
	rm -rf build
	rm -rf bin
