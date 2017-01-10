ARCHS=x86_64 armeabi

CC-x86_64=g++
CF-x86_64=-mno-red-zone -DBITS64 -fshort-wchar
AA-x86_64=nasm
RR-x86_64=ar

CC-armeabi=arm-linux-gnueabi-g++
CF-armeabi=-DBITS32 -fPIC
AA-armeabi=
RR-armeabi=arm-linux-gnueabi-ar

$(foreach A, $(ARCHS), $(eval COBJECTS-$A=$(patsubst %, build/$(A)/%.o, $(CSOURCES))))
$(foreach A, $(ARCHS), $(eval AOBJECTS-$A=$(patsubst %, build/$(A)/%.o, $(ASOURCES))))
$(foreach A, $(ARCHS), $(eval OBJECTS-$A=$(COBJECTS-$A) $(AOBJECTS-$A)))
OBJECTS-all=$(foreach A, $(ARCHS), $(OBJECTS-$A))

CDFLAGS=$(if $(DEBUGGING), -g -O0 -D DEBUGGING, -O2)
CTFLAGS=$(if $(DO_TEST),-D DO_TEST -D ALLOW_TEST)
TFLAGS=$(if $(ALLOW_TEST),-D ALLOW_TEST)

INCLUDE_FLAGS=-I include $(patsubst %, -I ../%/include, $(LIBS))
LIB_FLAGS=

CFLAGS=-c -std=c++14 -Wall -Wextra -Wno-comment -fno-stack-protector -DEFI_FUNCTION_WRAPPER $(INCLUDE_FLAGS) $(CDFLAGS) $(CTFLAGS) $(TFLAGS)
AFLAGS=-f elf64

all: $(OBJECTS-all)

.SECONDEXPANSION:
CURRENT_ARCH=$(word 2,$(subst /, ,$@))
CURRENT_NAME=$(patsubst build/$(CURRENT_ARCH)/%.o,%,$@)
$(OBJECTS-all):build/%.o: src/$$(CURRENT_NAME).cpp | $$(dir $$@)/.dirstamp
	@$(CC-$(CURRENT_ARCH)) \
	    -o $@ $^ \
	    $(CFLAGS) $(CF-$(CURRENT_ARCH))

build/%.o: src/$$(firstword $$(subst ., ,$$(lastword $$(subst -, , $$@)))).s | $$(dir $$@)/.dirstamp
	@$(AA-$(CURRENT_ARCH)) \
	    -o $@ $^ \
	    $(AFLAGS)

%/.dirstamp:
	@mkdir -p $(@D)
	@touch $@

.PHONY:
clean:
	@rm -rf build

-include ../make-base/make-git.mk