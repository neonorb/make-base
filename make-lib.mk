ARFLAGS=

all: lib
lib: $$(foreach A, $(ARCHS), build/$$A/lib$(NAME).a)
build/%/lib$(NAME).a: $$(OBJECTS-$$(CURRENT_ARCH)) | $$(dir $$@)/.dirstamp
	$(NO_PRINT_COMMAND)$(RR-$(CURRENT_ARCH)) \
	    -r $@ \
	    $^ \
	    $(ARFLAGS) \
	    2> /tmp/makefilearoutput || (cat /tmp/makefilearoutput ; rm /tmp/makefilearoutput ; exit 1) && rm /tmp/makefilearoutput