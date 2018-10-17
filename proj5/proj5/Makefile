CFLAGS=-m32 -g -ansi -Wall

test2.out: test2.o frac_heap.o
	gcc -m32 $^ -o $@

clean:
	rm -f *.o *.out *.lst
