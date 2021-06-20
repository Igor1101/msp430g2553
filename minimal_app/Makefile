OBJECTS=blink.o
MAP=blink.map
MAKEFILE=Makefile

#
#default msp430 toolchain path (it asks to be installed somewhere there)
DEF_GCC_DIR ?= /root/ti/msp430-gcc

ifeq ($(OS),Windows_NT)
	ifeq ($(shell uname -o),Cygwin)
		RM= rm -rf
	else
		RM= del /q
	endif
else
	RM= rm -rf
endif

GCC_DIR = $(DEF_GCC_DIR)
GCC_DIR_BIN = $(DEF_GCC_DIR)/bin
GCC_DIR_INC = $(GCC_DIR)/include
TARG_GCC = msp430-elf
DEVICE  = MSP430G2553
CC      = $(GCC_DIR_BIN)/$(TARG_GCC)-gcc
GDB     = $(GCC_DIR_BIN)/$(TARG_GCC)-gdb
OBJCOPY	= $(GCC_DIR_BIN)/$(TARG_GCC)-objcopy

CFLAGS = -I $(GCC_DIR_INC) -mmcu=$(DEVICE) -Og -Wall -g -ggdb
LFLAGS = -L $(GCC_DIR_INC) -Wl,-Map,$(MAP),--gc-sections 

all: ${OBJECTS}
	$(CC) $(CFLAGS) $(LFLAGS) $? -o $(DEVICE).elf
	$(OBJCOPY)  $(DEVICE).elf -O ihex $(DEVICE).hex


clean: 
	$(RM) $(OBJECTS)
	$(RM) $(MAP)
	$(RM) *.out
	$(RM) *.hex
	$(RM) *.elf
	
debug: all
	$(GDB) $(DEVICE).elf -ex "tar ext :2000"\
	       	-ex "layout asm" \
		-ex "layout reg" 
debug_start: all
	mspdebug rf2500 gdb --allow-fw-update
flash: all
	mspdebug -n rf2500 "prog $(DEVICE).elf"
