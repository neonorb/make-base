ARLIBS=$(foreach L,$(LIBS),../$L/build/lib$L.a)
ARFLAGS=$(COBJECTS) $(AOBJECTS) $(ARLIBS)

lib: build/lib$(NAME).a
build/lib$(NAME).a: $(COBJECTS) $(AOBJECTS)
	ar -r build/lib$(NAME).a $(ARFLAGS)

all: lib
