###############################################################################
# Makefile for the project RTOS-7
###############################################################################

## General Flags
PROJECT = RTOS-7
MCU = atmega128
TARGET = RTOS-7.elf
CC = 

CPP = avr-g++

## Options common to compile, link and assembly rules
COMMON = -mmcu=$(MCU)

## Compile options common for all C compilation units.
CFLAGS = $(COMMON)
CFLAGS += -Wall -gdwarf-2 -std=gnu99 -Os -funsigned-char -funsigned-bitfields -fpack-struct -fshort-enums
CFLAGS += -MD -MP -MT $(*F).o -MF dep/$(@F).d 

## Assembly specific flags
ASMFLAGS = $(COMMON)
ASMFLAGS += $(CFLAGS)
ASMFLAGS += -x assembler-with-cpp -Wa,-gdwarf2

## Linker flags
LDFLAGS = $(COMMON)
LDFLAGS +=  -Wl,-Map=RTOS-7.map


## Intel Hex file production flags
HEX_FLASH_FLAGS = -R .eeprom -R .fuse -R .lock -R .signature

HEX_EEPROM_FLAGS = -j .eeprom
HEX_EEPROM_FLAGS += --set-section-flags=.eeprom="alloc,load"
HEX_EEPROM_FLAGS += --change-section-lma .eeprom=0 --no-change-warnings


## Objects that must be built in order to link
OBJECTS = bsp.o main.o os_core.o os_cpu_a.o os_cpu_c.o os_dbg_r.o os_flag.o os_mbox.o os_mem.o os_mutex.o os_q.o os_sem.o os_task.o os_time.o os_tmr.o ucos_ii.o 

## Objects explicitly added by the user
LINKONLYOBJECTS = 

## Build
all: $(TARGET) RTOS-7.hex RTOS-7.eep RTOS-7.lss## Compile
bsp.o: ../bsp.c
	$(CC) $(INCLUDES) $(CFLAGS) -c  $<

main.o: ../main.c
	$(CC) $(INCLUDES) $(CFLAGS) -c  $<

os_core.o: ../os_core.c
	$(CC) $(INCLUDES) $(CFLAGS) -c  $<

os_cpu_a.o: ../os_cpu_a.s
	$(CC) $(INCLUDES) $(ASMFLAGS) -c  $<

os_cpu_c.o: ../os_cpu_c.c
	$(CC) $(INCLUDES) $(CFLAGS) -c  $<

os_dbg_r.o: ../os_dbg_r.c
	$(CC) $(INCLUDES) $(CFLAGS) -c  $<

os_flag.o: ../os_flag.c
	$(CC) $(INCLUDES) $(CFLAGS) -c  $<

os_mbox.o: ../os_mbox.c
	$(CC) $(INCLUDES) $(CFLAGS) -c  $<

os_mem.o: ../os_mem.c
	$(CC) $(INCLUDES) $(CFLAGS) -c  $<

os_mutex.o: ../os_mutex.c
	$(CC) $(INCLUDES) $(CFLAGS) -c  $<

os_q.o: ../os_q.c
	$(CC) $(INCLUDES) $(CFLAGS) -c  $<

os_sem.o: ../os_sem.c
	$(CC) $(INCLUDES) $(CFLAGS) -c  $<

os_task.o: ../os_task.c
	$(CC) $(INCLUDES) $(CFLAGS) -c  $<

os_time.o: ../os_time.c
	$(CC) $(INCLUDES) $(CFLAGS) -c  $<

os_tmr.o: ../os_tmr.c
	$(CC) $(INCLUDES) $(CFLAGS) -c  $<

ucos_ii.o: ../ucos_ii.c
	$(CC) $(INCLUDES) $(CFLAGS) -c  $<

##Link
$(TARGET): $(OBJECTS)
	 $(CC) $(LDFLAGS) $(OBJECTS) $(LINKONLYOBJECTS) $(LIBDIRS) $(LIBS) -o $(TARGET)

%.hex: $(TARGET)
	avr-objcopy -O ihex $(HEX_FLASH_FLAGS)  $< $@

%.eep: $(TARGET)
	-avr-objcopy $(HEX_EEPROM_FLAGS) -O ihex $< $@ || exit 0

%.lss: $(TARGET)
	avr-objdump -h -S $< > $@

## Clean target
.PHONY: clean
clean:
	-rm -rf $(OBJECTS) RTOS-7.elf dep/* RTOS-7.hex RTOS-7.eep RTOS-7.lss RTOS-7.map


## Other dependencies
-include $(shell mkdir dep 2>NUL) $(wildcard dep/*)

