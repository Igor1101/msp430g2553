#
# Makefile for msp430 assembler
# Build single GNU asm source
#
# 'make' builds everything
# 'make dump' generates assembler dump of target
# 'make burn' flashes target into launchpad
# 'make clean' deletes everything except source files and Makefile
#
# You need to set TARGET and MCU for your project
# eg if you have a source 'foo.S' then set target to 'foo'
# 
#default msp430 toolchain path (it asks to be installed somewhere there)
# add APPSRC srcs
DEF_GCC_DIR ?= ~/ti/msp430-gcc
TARGET   ?= PROG
MCU      = MSP430G2553

GCC_DIR = $(DEF_GCC_DIR)
GCC_DIR_BIN = $(DEF_GCC_DIR)/bin
GCC_DIR_INC = $(GCC_DIR)/include
INCLUDES += -I $(GCC_DIR_INC)
TARG_GCC = msp430-elf

# Add or subtract whatever MSPGCC flags you want. There are plenty more
#######################################################################################
CFLAGS   += -mmcu=$(MCU) -g3 -Os -Wall -Wunused -Wno-main $(INCLUDES) -g -ggdb
ASFLAGS  += -mmcu=$(MCU) -x assembler-with-cpp -Wa,-gstabs
#LDFLAGS  = -mmcu=$(MCU) -Wl,-Map=$(TARGET).map -nostdlib -nostartfiles -L $(GCC_DIR_INC)

LDFLAGS += -mmcu=$(MCU) -L $(GCC_DIR_INC) -Wl,-Map,$(TARGET).map,--gc-sections 
########################################################################################
CC      = $(GCC_DIR_BIN)/$(TARG_GCC)-gcc
GDB     = $(GCC_DIR_BIN)/$(TARG_GCC)-gdb
OBJCOPY	= $(GCC_DIR_BIN)/$(TARG_GCC)-objcopy
AR       = $(GCC_DIR_BIN)/$(TARG_GCC)-ar
AS       = $(GCC_DIR_BIN)/$(TARG_GCC)-gcc
NM       = $(GCC_DIR_BIN)/$(TARG_GCC)-nm
OBJCOPY  = $(GCC_DIR_BIN)/$(TARG_GCC)-objcopy
OBJDUMP  = $(GCC_DIR_BIN)/$(TARG_GCC)-objdump
RANLIB   = $(GCC_DIR_BIN)/$(TARG_GCC)-ranlib
STRIP    = $(GCC_DIR_BIN)/$(TARG_GCC)-strip
SIZE     = $(GCC_DIR_BIN)/$(TARG_GCC)-size
READELF  = $(GCC_DIR_BIN)/$(TARG_GCC)-readelf
MSPDEBUG = mspdebug
CP       = cp -p
ifeq ($(OS),Windows_NT)
	ifeq ($(shell uname -o),Cygwin)
		RM= rm -rf
	else
		RM= del /q
	endif
else
	RM= rm -rf
endif
MV       = mv
########################################################################################
.PHONY: all dump clean
	
TEMP = $(APPSRC:.c=.o)
APPOBJS_TMP = $(TEMP:.S=.o)
APPOBJS := $(APPOBJS_TMP)

all: $(TARGET).elf
$(TARGET).elf: $(APPOBJS)
	@echo "Linking $@"
	$(CC) $(APPOBJS) $(LDFLAGS) $(LIBS) -o $@
	@echo
	@echo ">>>> Size of Firmware <<<<"
	$(SIZE) $(TARGET).elf
	@echo
$(TARGET).hex: $(TARGET).elf
	$(OBJCOPY)  $(DEVICE).elf -O ihex $(DEVICE).hex
%.o: %.S
	@echo "Compiling $<"
	$(CC) -c $(CFLAGS) -o $@ $<
%.o: %.c
	@echo "Compiling $<"
	$(CC) -c $(CFLAGS) -o $@ $<
dump: $(TARGET).elf
	$(OBJDUMP) -D -S $< > $(TARGET).dump
burn: $(TARGET).elf
	$(MSPDEBUG) rf2500 "prog $(TARGET).elf"
clean:
	-$(RM) $(TARGET).elf $(TARGET).map *.o $(TARGET).dump $(TARGET).hex
debug: all
	$(GDB) $(TARGET).elf -ex "tar ext :2000"\
	       	-ex "layout asm" \
		-ex "layout reg" 
debug_start: all
	mspdebug rf2500 gdb --allow-fw-update

