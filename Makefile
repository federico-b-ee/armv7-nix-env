.PHONY: build clean

# Define the compiler
AS = arm-none-eabi-as
LD = arm-none-eabi-ld

## List of assembly source files
AS_SRC := $(wildcard src/*.s)

## Path to linker script
LINKER_SCRIPT := linker/zynq.ld

## flags
#LDFLAGS := -T $(LINKER_SCRIPT)

## List of object files generated from assembly source files
OBJ_FILES := $(patsubst src/%.s, build/%.o, $(AS_SRC))

build: 
	nix-shell --run "make build/hello"

## Rule to link object files into a bootable image
build/hello: $(OBJ_FILES)
	$(LD) -o $@ $(OBJ_FILES)

## Rule to compile assembly files into object files
build/%.o: src/%.s
	mkdir -p build
	$(AS) -c $< -o $@

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

# nix.qemu
nix.qemu:
	nix-shell --run "qemu-arm -singlestep -g 1234 build/hello"

# nix.fmt
nix.fmt:
	nixfmt shell.nix

# Clean target
clean:
	rm -rf build
