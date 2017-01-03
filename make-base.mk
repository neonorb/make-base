ARCH="x86_64 g++ ar" "aarch64 "

CC_x86=g++
CC_AARCH64=aarch64-linux-gnu-g++
CC=$(CC_x86)
AS=nasm
AR_x86=ar
AR_AARCH64=aarch64-linux-gnu-ar
AR=$(AR_x86)

COBJECTS=$(patsubst %, build/%.o, $(CSOURCES))
AOBJECTS=$(patsubst %, build/%.o, $(ASOURCES))
OBJECTS=$(COBJECTS) $(AOBJECTS)

CDFLAGS=$(if $(DEBUGGING), -g -O0 -D DEBUGGING, -O2)
CTFLAGS=$(if $(DO_TEST),-D DO_TEST -D ALLOW_TEST)
TFLAGS=$(if $(ALLOW_TEST),-D ALLOW_TEST)

INCLUDE_FLAGS=-I include $(patsubst %, -I ../%/include, $(LIBS))
LIBS_FLAGS=$(foreach L, $(LIBS), -L ../$L/build -l$L)

CFLAGS=-c -std=c++14 -fpic -Wall -Wextra -Wno-comment -fno-stack-protector -fshort-wchar -DEFI_FUNCTION_WRAPPER $(INCLUDE_FLAGS) $(LIBS_FLAGS) $(CDFLAGS) $(CTFLAGS) $(TFLAGS)
# x86_64 -mno-red-zone 
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