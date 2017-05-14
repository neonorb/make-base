ARFLAGS=

all: lib
lib: $$(foreach A, $(ARCHS), build/$$A/lib$(NAME).a)
TMP_AR_OUT=/tmp/asiago_$(NAME)_ar_output.tmp
build/%/lib$(NAME).a: $$(OBJECTS-$$(CURRENT_ARCH)) | $$(dir $$@)/.dirstamp
	$(NO_PRINT_COMMAND)$(RR-$(CURRENT_ARCH)) \
	    -r $@ \
	    $^ \
	    $(ARFLAGS) \
	    2> $(TMP_AR_OUT) || (cat $(TMP_AR_OUT) ; rm $(TMP_AR_OUT) ; exit 1) && rm $(TMP_AR_OUT)