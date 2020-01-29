objects = throw.o integer-printer.o integer-parser.o
debug =
optimisation = -O2

numbers: $(objects)
	ld $(objects) -o libnumbers.a -dylib

check: numbers buildtest
	./test

buildtest: debug = -g
buildtest: optimisation = -O0
buildtest: test.o
	cc -o test test.o $(optimisation) -L. -lnumbers

cleancheck: clean numbers buildtest
	./test

throw.o:
	as throw.s -o throw.o

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
