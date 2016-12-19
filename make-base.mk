CC=g++
AS=nasm

COBJECTS=$(patsubst %, build/%.o, $(CSOURCES))
AOBJECTS=$(patsubst %, build/%.o, $(ASOURCES))
OBJECTS=$(COBJECTS) $(AOBJECTS)

CDFLAGS=$(if $(DEBUGGING), -g -O0 -D DEBUGGING, -O2)
CTFLAGS=$(if $(DO_TEST),-D DO_TEST -D ALLOW_TEST)
TFLAGS=$(if $(ALLOW_TEST),-D ALLOW_TEST)

INCLUDE_FLAGS=-I include $(patsubst %, -I ../%/include, $(LIBS))
LIBS_FLAGS=$(foreach L, $(LIBS), -L ../$L/build -l$L)

CFLAGS=-c -std=c++14 -fpic -Wall -Wextra -Wno-comment -fno-stack-protector -fshort-wchar -mno-red-zone -DEFI_FUNCTION_WRAPPER $(INCLUDE_FLAGS) $(LIBS_FLAGS) $(CDFLAGS) $(CTFLAGS) $(TFLAGS)
AFLAGS=-f elf64

all: $(OBJECTS)

.SECONDEXPANSION:

build/%.o: src/%.cpp | $$(dir $$@)/.dirstamp
	@$(CC) -o $@ $^ $(CFLAGS)

build/%.o: src/%.s | $$(dir $$@)/.dirstamp
	@$(AS) $(AFLAGS) -o $@ $^

%/.dirstamp:
	@mkdir -p $(@D)
	@touch $@

.PHONY:
clean:
	@rm -rf build

-include ../make-base/make-git.mk