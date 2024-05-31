# Define the compiler
AS = arm-none-eabi-as
GCC = arm-none-eabi-gcc
LD = arm-none-eabi-ld
OC = arm-none-eabi-objcopy

## Flags
CFLAGS ?= -std=gnu99 -Wall -mcpu=cortex-a8
COPT ?= -O0 # No optimizations

## List of assembly source files
PROC_AS_SRC := $(wildcard proc/*.s)
SYS_AS_SRC := $(wildcard sys/*.s)
CORE_AS_SRC := $(wildcard core/*.s)
KERNEL_C_SRC := $(wildcard kernel/*.c)

## Path to linker script
LINKER_SCRIPT := linker/mmap.ld

## List of object files generated from assembly source files
PROC_OBJ_FILES := $(patsubst proc/%.s, obj/proc/%.o, $(PROC_AS_SRC))
SYS_OBJ_FILES := $(patsubst sys/%.s, obj/sys/%.o, $(SYS_AS_SRC))
CORE_OBJ_FILES := $(patsubst core/%.s, obj/core/%.o, $(CORE_AS_SRC))
KERNEL_OBJ_FILES := $(patsubst kernel/%.c, obj/kernel/%.o, $(KERNEL_C_SRC))
ALL_OBJ_FILES := $(PROC_OBJ_FILES) $(SYS_OBJ_FILES) $(CORE_OBJ_FILES) $(KERNEL_OBJ_FILES)

nix.build: make clean
	nix-shell --run "make bin/image.bin"
.PHONY: nix.build

build: clean bin/image.bin
.PHONY: build

## Rule to create the binary
bin/image.bin: obj/image.elf
	mkdir -p bin
	$(OC) -O binary $< $@

## Rule to link object files into a bootable image
obj/image.elf: $(ALL_OBJ_FILES)
	mkdir -p map
	$(LD) -T $(LINKER_SCRIPT) -o $@ $(ALL_OBJ_FILES) -Map map/image.map

## Rule to compile assembly files into object files for proc
obj/proc/%.o: proc/%.s
	mkdir -p obj/proc
	$(AS) -c $< -g -o $@ -a > $@.lst

## Rule to compile assembly files into object files for sys
obj/sys/%.o: sys/%.s
	mkdir -p obj/sys
	$(AS) -c $< -g -o $@ -a > $@.lst

## Rule to compile assembly files into object files for core
obj/core/%.o: core/%.s
	mkdir -p obj/core
	$(AS) -c $< -g -o $@ -a > $@.lst

## Rule to compile assembly files into object files for core
obj/kernel/%.o: kernel/%.c
	mkdir -p obj/kernel
	$(GCC) -g $(COPT) $(CFLAGS) -c $< -o $@

DISASM := obj/image.elf
# Objdump
nix.objdump:
	nix-shell --run "arm-none-eabi-objdump -d $(DISASM)"

objdump:
	arm-none-eabi-objdump -d $(DISASM)


LOG_FILE ?= gdb_session0.log
# Debug
nix.debug: obj/image.elf
	nix-shell --run  'gdb -q \
	-ex "target remote :2159" \
	-ex "set logging file ${LOG_FILE}" \
	-ex "set logging on" \
	-ex "list" \
	$<'
.PHONY: nix.debug

debug: obj/image.elf
	gdb-multiarch -q \
	-ex "target remote :2159" \
	-ex "set logging file ${LOG_FILE}" \
	-ex "set logging on" \
	-ex "l" \
	$<
.PHONY: debug

# QEMU
nix.qemuA8: bin/image.bin
	nix-shell --run "qemu-system-arm \
	-M realview-pb-a8 -m 32M \
	-no-reboot -nographic \
	-monitor telnet:127.0.0.1:1234,server,nowait \
	-kernel $< -S -gdb tcp::2159"
.PHONY: nix.qemuA8

qemuA8: bin/image.bin
	qemu-system-arm \
	-M realview-pb-a8 -m 32M \
	-no-reboot -nographic \
	-monitor telnet:127.0.0.1:1234,server,nowait \
	-kernel $< -S -gdb tcp::2159
.PHONY: qemuA8

# Format
nix.fmt:
	nixfmt shell.nix
.PHONY: nix.fmt

nix.cfmt:
	nix-shell --run "clang-format -i kernel/*.c kernel/inc/*.h"
.PHONY: nix.cfmt

cfmt:
	clang-format -i kernel/*.c
.PHONY: cfmt

# Clean target
clean:
	rm -rf obj/*
	rm -rf bin/*
.PHONY: clean

# Help target
help:
	@echo -n "\033[38;5;196mA\033[0mv\033[38;5;202ma\033[0\033[0mi\033[38;5;214ml\033[0ma\033[38;5;220mb\033[0ml\033[38;5;226me\033[0m \033[38;5;190mt\033[0ma\033[38;5;154mr\033[0mg\033[38;5;118me\033[0mt\033[38;5;82ms\033[0m:\n"
	@echo "\e[92mnix.build\e[0m     : Build the project using nix-shell"
	@echo "\e[92mbuild\e[0m         : Build the project"
	@echo "\e[92mnix.objdump\e[0m   : Run objdump using nix-shell"
	@echo "\e[92mobjdump\e[0m       : Run objdump"
	@echo "\e[92mnix.debug\e[0m     : Debug the project using GDB with nix-shell"
	@echo "\e[92mdebug\e[0m         : Debug the project using GDB"
	@echo "\e[92mnix.qemuA8\e[0m    : Run QEMU with ARMv7 architecture using nix-shell"
	@echo "\e[92mqemuA8\e[0m        : Run QEMU with ARMv7 architecture"
	@echo "\e[92mnix.fmt\e[0m       : Format the Nix file"
	@echo "\e[92mcfmt\e[0m          : Format C files using clang-format"
	@echo "\e[92mnix.cfmt\e[0m      : Format C files using clang-format with nix-shell"
	@echo "\e[92mclean\e[0m         : Clean up generated files"
.PHONY: help
