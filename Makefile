Build, disassembly, and QEMU execution
PREFIX ?= arm-none-eabi-
CC := $(PREFIX)gcc
OBJDUMP := $(PREFIX)objdump
SIZE := $(PREFIX)size
QEMU ?= qemu-system-arm
CPUFLAGS := -mcpu=cortex-m0 -mthumb
ASFLAGS := $(CPUFLAGS) -x assembler-with-cpp -ffreestanding -g3
LDFLAGS := $(CPUFLAGS) -nostdlib -Wl,--gc-sections -Wl,-Map=firmware.map -T linker.ld
OBJECTS := startup.o rle.o main.o
.PHONY: all run inspect clean test-host
all: firmware.elf firmware.bin firmware.dis
%.o: %.s
$(CC) $(ASFLAGS) -c $< -o $@
firmware.elf: $(OBJECTS) linker.ld
$(CC) $(LDFLAGS) $(OBJECTS) -o $@
$(SIZE) $@
firmware.bin: firmware.elf
$(PREFIX)objcopy -O binary $< $@
firmware.dis: firmware.elf
$(OBJDUMP) -h -d $< > $@
run: firmware.elf
$(QEMU) -M microbit -cpu cortex-m0 -kernel $< -nographic \
-semihosting-config enable=on,target=native
inspect: firmware.elf
$(OBJDUMP) -h -t -d $< | less
test-host:
python3 test_rle.py
clean:
rm -f $(OBJECTS) firmware.elf firmware.bin firmware.dis firmware.map
