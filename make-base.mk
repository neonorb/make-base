# common build scripts to be used by all projects

# all the architecutes to build for
ARCHS?=x86_64 armeabi

# for every architecture listed above, you need one of these:
# CC-<arch>=<cpp compiler>
# CF-<arch>=<cpp flags>
# AA-<arch>=<assembler>
# AF-<arch>=<assembler flags>
# RR-<arch>=<archiver>

CC-x86_64=g++
CF-x86_64=-mno-red-zone -DBITS64 -fshort-wchar
AA-x86_64=as
AF-x86_64=--64
RR-x86_64=ar

CC-armeabi=arm-linux-gnueabi-g++
CF-armeabi=-DBITS32 -fPIC
AA-armeabi=
RR-armeabi=arm-linux-gnueabi-ar

NO_PRINT_COMMAND=$(if $(PRINT_COMMANDS),,@)

$(foreach A, $(ARCHS), $(eval CPPOBJECTS-$A=$(patsubst %, build/$(A)/%.o, $(CPPSOURCES))))
$(foreach A, $(ARCHS), $(eval COBJECTS-$A=$(patsubst %, build/$(A)/%.o, $(CSOURCES))))
$(foreach A, $(ARCHS), $(eval AOBJECTS-$A=$(patsubst %, build/$(A)/%.o, $(ASOURCES))))
$(foreach A, $(ARCHS), $(eval OBJECTS-$A=$(CPPOBJECTS-$A) $(COBJECTS-$A) $(AOBJECTS-$A)))
CPPOBJECTS-all=$(foreach A, $(ARCHS), $(CPPOBJECTS-$A))
COBJECTS-all=$(foreach A, $(ARCHS), $(COBJECTS-$A))
AOBJECTS-all=$(foreach A, $(ARCHS), $(AOBJECTS-$A))
OBJECTS-all=$(CPPOBJECTS-all) $(COBJECTS-all) $(AOBJECTS-all)

CDFLAGS=$(if $(DEBUGGING), -g -O0 -D DEBUGGING, -O2)
CTFLAGS=$(if $(DO_TEST),-D DO_TEST -D ALLOW_TEST)
TFLAGS=$(if $(ALLOW_TEST),-D ALLOW_TEST)

INCLUDE_FLAGS=-I include $(patsubst %, -I ../%/include, $(LIBS))
LIB_FLAGS=

CFLAGS=-c -std=c++14 -Wall -Wextra -Wno-comment -fno-stack-protector $(INCLUDE_FLAGS) $(CDFLAGS) $(CTFLAGS) $(TFLAGS)

all: $(OBJECTS-all)

.SECONDEXPANSION:
CURRENT_ARCH=$(word 2,$(subst /, ,$@))
CURRENT_NAME=$(patsubst build/$(CURRENT_ARCH)/%.o,%,$@)
$(CPPOBJECTS-all):build/%.o: src/$$(CURRENT_NAME).cpp | $$(dir $$@)/.dirstamp
	$(NO_PRINT_COMMAND)$(CC-$(CURRENT_ARCH)) \
	    -o $@ $^ \
	    $(CFLAGS) $(CF-$(CURRENT_ARCH))

$(COBJECTS-all):build/%.o: src/$$(CURRENT_NAME).c | $$(dir $$@)/.dirstamp
	$(NO_PRINT_COMMAND)$(CC-$(CURRENT_ARCH)) \
	    -o $@ $^ \
	    $(CFLAGS) $(CF-$(CURRENT_ARCH))

$(AOBJECTS-all):build/%.o: src/$$(CURRENT_NAME).s | $$(dir $$@)/.dirstamp
	$(NO_PRINT_COMMAND)$(AA-$(CURRENT_ARCH)) \
	    -o $@ $^ \
	    $(AF-$(CURRENT_ARCH))

%/.dirstamp:
	@mkdir -p $(@D)
	@touch $@

.PHONY:
clean:
	$(NO_PRINT_COMMAND)rm -rf build

-include ../make-base/make-git.mk