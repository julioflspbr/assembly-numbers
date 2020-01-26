numbers: integer-printer.o
	ld integer-printer.o -o libintegerprinter.a -dylib

integer-printer.o:
	as integer-printer.s -o integer-printer.o

check: clean numbers test.o
	cc test.o -o test -O0 -L. -lintegerprinter
	./test

test.o:
	cc test.c -o test.o -g -c

clean:
	-rm -f *.o
	-rm libintegerprinter.a
	-rm test
