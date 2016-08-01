CC ?= i686-elf-gcc # Both the compiler and assembler need crosscompiled http://wiki.osdev.org/GCC_Cross-Compiler
AS ?= nasm

COBJECTS=$(patsubst %, build/%.o, $(CSOURCES))
AOBJECTS=$(patsubst %, build/%.o, $(ASOURCES))

CDFLAGS=$(if $(DEBUGGING), -g -Og, -O2)
CTFLAGS=$(if $(TESTING),-D TESTING)

INCLUDE_FLAGS=-I include $(patsubst %, -I ../%/include, $(LIBS))
LIBS_FLAGS=$(foreach L, $(LIBS), -L ../$L/build -l$L,)

CFLAGS=-c -fno-exceptions -nostdlib -ffreestanding -fno-rtti -Wall -Wextra $(INCLUDE_FLAGS) $(LIBS_FLAGS) $(CDFLAGS) $(CTFLAGS)
AFLAGS=-f elf

all: $(COBJECTS) $(AOBJECTS)

.SECONDEXPANSION:

build/%.o: src/%.cpp | $$(dir $$@)/.dirstamp
	$(CC) $(CFLAGS) -o $@ $^

build/%.o: src/%.s | $$(dir $$@)/.dirstamp
	$(AS) $(AFLAGS) -o $@ $^

%/.dirstamp:
	mkdir -p $(@D)
	touch $@

clean:
	rm -rf build
