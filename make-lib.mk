ARLIBS=$(foreach L,$(LIBS),../$L/build/lib$L.a)
ARFLAGS=$(ARLIBS)

lib: build/lib$(NAME).a
build/lib$(NAME).a: $(COBJECTS) $(AOBJECTS)
	ar -r build/lib$(NAME).a $(COBJECTS) $(AOBJECTS) $(ARFLAGS)

all: lib
