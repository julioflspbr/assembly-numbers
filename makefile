objects = integer-printer.o integer-parser.o
debug =
optimisation = -O2

numbers: $(objects)
	ld integer-printer.o integer-parser.o -o libnumbers.a -dylib

build-test: debug = -g
build-test: optimisation = -O0
build-test: clean numbers test

check: numbers test
	./test

test: test.o
	cc test.o -o test $(optimisation) -L. -lnumbers

integer-printer.o:
	as integer-printer.s -o integer-printer.o

integer-parser.o:
	as integer-parser.s -o integer-parser.o

test.o:
	cc -c test.c -o test.o $(debug)

clean:
	-rm -f *.o
	-rm libnumbers.a
	-rm test
