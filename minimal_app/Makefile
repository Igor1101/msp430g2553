OBJECTS=blink.o
MAP=blink.map
MAKEFILE=Makefile

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
GDB     = $(GCC_DIR_BIN/$(TARG_GCC)-gdb

CFLAGS = -I $(GCC_DIR_INC) -mmcu=$(DEVICE) -Og -Wall -g
LFLAGS = -L $(GCC_DIR_INC) -Wl,-Map,$(MAP),--gc-sections 

all: ${OBJECTS}
	$(CC) $(CFLAGS) $(LFLAGS) $? -o $(DEVICE).out

clean: 
	$(RM) $(OBJECTS)
	$(RM) $(MAP)
	$(RM) *.out
	
debug: all
	$(GDB) $(DEVICE).out
