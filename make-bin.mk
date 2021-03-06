# this generates an executable

INSTALL_DIR=/usr/local/bin/

bin: $$(foreach A, $(ARCHS), build/$$A/$(NAME).bin)
build/%/$(NAME).bin: $$(OBJECTS-$$(CURRENT_ARCH)) | $$(dir $$@)/.dirstamp
	$(NO_PRINT_COMMAND) $(CC_$(CURRENT_ARCH)) -T ../make-base/ldscript.lds \
		-o $@ \
		$^ \
		$(foreach L,$(LIBS),../$L/build/$(CURRENT_ARCH)/lib$L.a) $(LIB_FLAGS)
	
	$(NO_PRINT_COMMAND) chmod +x build/$(CURRENT_ARCH)/$(NAME).bin

all: bin

# TODO make this work for all architectures
#.PHONY:
#install: build/$$(firstword $$(subst -, ,$$(lastword $$(subst /, ,$$@))))-mish
#	@cp build/$(firstword $(subst -, ,$(lastword $(subst /, ,$@))))-mish $(INSTALL)
	
.PHONY:
install: build/x86_64/$(NAME).bin
	$(NO_PRINT_COMMAND) cp build/x86_64/$(NAME).bin $(INSTALL_DIR)/$(NAME)
