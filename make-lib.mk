ARLIBS=$(foreach L,$(LIBS),../$L/build/lib$L.a)
ARFLAGS=-fpic -shared $(ARLIBS)

lib: build/lib$(NAME).a
build/lib$(NAME).a: $(COBJECTS) $(AOBJECTS)
	ld $(COBJECTS) $(AOBJECTS) $(ARFLAGS) -o build/lib$(NAME).a

all: lib
