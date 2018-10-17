LDFLAGS = -g -melf_i386
%.o: %.asm
	nasm -g -f elf -l $*.lst $< -o $@

TARGET=exam.out

OBJS=exam.o

${TARGET}: ${OBJS}
	${LD} ${LDFLAGS} $(OBJS} -o ${TARGET}

