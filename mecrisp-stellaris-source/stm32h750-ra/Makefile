
ARMGNU?=arm-none-eabi

COPS = -Wall  -Og -nostdlib -nostartfiles -ffreestanding -save-temps
AOPS = --warn --fatal-warnings

TARGET = stm32h750
PROJECT = mecrisp-stellaris-$(TARGET)

SRCS += ../../stm32h750-ra/utils.fs
SRCS += ../../stm32h750-ra/pwr.fs
SRCS += ../../stm32h750-ra/rcc.fs
SRCS += ../../stm32h750-ra/gpio.fs
SRCS += ../../common/disassembler-m3.txt
SRCS += ../../stm32h750-ra/spi.fs
SRCS += ../../common/cycles.txt
SRCS += ../../stm32h750-ra/dht22.fs
SRCS += ../../stm32h750-ra/mco.fs
SRCS += ../../stm32h750-ra/hash.fs

all : $(PROJECT).bin $(PROJECT).hex

$(PROJECT).o : *.s
	$(ARMGNU)-as -g $(PROJECT).s -o $(PROJECT).o

# offset 0x08000000 to enable flash with st-link utility
$(PROJECT).hex : $(PROJECT).bin
	$(ARMGNU)-objcopy -I binary -O ihex --change-addresses 0x08000000 $(PROJECT).bin $(PROJECT).hex

$(PROJECT).bin : memmap $(PROJECT).o
	$(ARMGNU)-ld -g -o $(PROJECT).elf -T memmap $(PROJECT).o
	$(ARMGNU)-objdump -D $(PROJECT).elf > $(PROJECT).list
	$(ARMGNU)-objcopy $(PROJECT).elf $(PROJECT).bin -O binary
	$(ARMGNU)-objdump --source --all-headers --demangle --line-numbers --wide $(PROJECT).elf > $(PROJECT).lst

clean:
	rm -f *.bin
	rm -f *.o
	rm -f *.elf
	rm -f *.list
	rm -f *.lst
	rm -f *.hex

erase:
	pkill swd2 || true
	st-flash erase

flash: $(PROJECT).bin
	pkill swd2 || true
	st-flash write $(PROJECT).bin 0x08000000

tmux:
	tmux new -ADs swd2 swd2
	
tmux-bg:
	tmux ls -F "#{session_name}" | fgrep -xq swd2 || tmux new -ds swd2 swd2
	sleep 1

upload: tmux-bg
	pkill -INT swd2
	sleep 1
	cat $(SRCS) >upload.fs
	pkill -QUIT swd2
