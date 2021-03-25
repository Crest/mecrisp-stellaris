
#ARMGNU=arm-thumb-elf
#ARMGNU=arm-none-linux-gnueabi
ARMGNU?=arm-none-eabi

COPS = -Wall  -O2 -nostdlib -nostartfiles -ffreestanding -save-temps
AOPS = --warn --fatal-warnings

gcc : mecrisp-stellaris.gcc.thumb2.bin 

all : gcc

#vectors.o : vectors.s
#	$(ARMGNU)-as vectors.s -o vectors.o

#mecrisp-stellaris.gcc.thumb2.o : mecrisp-stellaris.c
#	$(ARMGNU)-gcc $(COPS) -mthumb -mcpu=cortex-m4 -c mecrisp-stellaris.c -o mecrisp-stellaris.gcc.thumb2.o

mecrisp-stellaris.gcc.thumb2.o : mecrisp-stellaris.s
	$(ARMGNU)-as mecrisp-stellaris.s -o mecrisp-stellaris.gcc.thumb2.o

mecrisp-stellaris.gcc.thumb2.bin : memmap mecrisp-stellaris.gcc.thumb2.o
	$(ARMGNU)-ld -o mecrisp-stellaris.gcc.thumb2.elf -T memmap mecrisp-stellaris.gcc.thumb2.o
	$(ARMGNU)-objdump -D mecrisp-stellaris.gcc.thumb2.elf > mecrisp-stellaris.gcc.thumb2.list
	$(ARMGNU)-objcopy mecrisp-stellaris.gcc.thumb2.elf mecrisp-stellaris.gcc.thumb2.bin -O binary

clean:
	rm -f *.bin
	rm -f *.o
	rm -f *.i
	rm -f *.elf
	rm -f *.list
	rm -f *.bc
	rm -f *.opt.s
	rm -f *.norm.s

