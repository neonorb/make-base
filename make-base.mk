ARCHS?=x86_64 armeabi

CC-x86_64=g++
CF-x86_64=-mno-red-zone -DBITS64 -fshort-wchar
AA-x86_64=as
AF-x86_64=--64
RR-x86_64=ar

CC-armeabi=arm-linux-gnueabi-g++
CF-armeabi=-DBITS32 -fPIC
AA-armeabi=
RR-armeabi=arm-linux-gnueabi-ar

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
	@$(CC-$(CURRENT_ARCH)) \
	    -o $@ $^ \
	    $(CFLAGS) $(CF-$(CURRENT_ARCH))

$(COBJECTS-all):build/%.o: src/$$(CURRENT_NAME).c | $$(dir $$@)/.dirstamp
	@$(CC-$(CURRENT_ARCH)) \
	    -o $@ $^ \
	    $(CFLAGS) $(CF-$(CURRENT_ARCH))

$(AOBJECTS-all):build/%.o: src/$$(CURRENT_NAME).s | $$(dir $$@)/.dirstamp
	@$(AA-$(CURRENT_ARCH)) \
	    -o $@ $^ \
	    $(AF-$(CURRENT_ARCH))

%/.dirstamp:
	@mkdir -p $(@D)
	@touch $@

.PHONY:
clean:
	@rm -rf build

-include ../make-base/make-git.mk