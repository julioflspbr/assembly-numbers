objects = integer-printer.o integer-parser.o

numbers: $(objects)
	ld integer-printer.o integer-parser.o -o libnumbers.a -dylib

integer-printer.o:
	as integer-printer.s -o integer-printer.o

integer-parser.o:
	as integer-parser.s -o integer-parser.o

test: clean numbers test.o
	cc test.o -o test -O0 -L. -lnumbers

check: test
	./test

test.o:
	cc test.c -o test.o -g -c

clean:
	-rm -f *.o
	-rm libnumbers.a
	-rm test
