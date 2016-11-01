ARLIBS=$(foreach L,$(LIBS),../$L/build/lib$L.a)
ARFLAGS=$(ARLIBS)

lib: build/lib$(NAME).a
build/lib$(NAME).a: $(COBJECTS) $(AOBJECTS)
	ar -r build/lib$(NAME).a $(COBJECTS) $(AOBJECTS) $(ARFLAGS) 2> /tmp/makefilearoutput || (cat /tmp/makefilearoutput ; rm /tmp/makefilearoutput ; exit 1) && rm /tmp/makefilearoutput

all: lib
