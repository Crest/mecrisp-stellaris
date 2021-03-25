
ARMGNU?=arm-none-eabi

COPS = -Wall  -O2 -nostdlib -nostartfiles -ffreestanding -save-temps
AOPS = --warn --fatal-warnings

all : mecrisp-stellaris.bin 

mecrisp-stellaris.o : mecrisp-stellaris.s
	$(ARMGNU)-as mecrisp-stellaris.s -o mecrisp-stellaris.o

mecrisp-stellaris.bin : memmap mecrisp-stellaris.o
	$(ARMGNU)-ld -o mecrisp-stellaris.elf -T memmap mecrisp-stellaris.o
	$(ARMGNU)-objdump -D mecrisp-stellaris.elf > mecrisp-stellaris.list
	$(ARMGNU)-objcopy mecrisp-stellaris.elf mecrisp-stellaris.bin -O binary

clean:
	rm -f *.bin
	rm -f *.o
	rm -f *.elf
	rm -f *.list
