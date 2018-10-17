CFLAGS=-m32 -g -ansi -Wall

test4.out: test4.o frac_heap.o
	gcc -m32 $^ -o $@

clean:
	rm -f *.o *.out *.lst
