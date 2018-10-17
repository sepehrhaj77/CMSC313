#
# Leave the following lines alone!!!

CFLAGS=-m32 -ansi -Wall -g
LDFLAGS=-melf_i386 -g
%.o: %.asm
	nasm -f elf -g -l $*.lst $< -o $@

#
# End of provided rules
#

# Modify following to the name of your linked program
TARGET=sort_books.out

# Modify following to the list of component object files
OBJS=main7.o sort_books.o bookcmp.o

#
# Do not modify remainder of this Makefile
#
${TARGET}: ${OBJS}
	gcc -m32 -ansi -Wall -g ${OBJS} -o $@
