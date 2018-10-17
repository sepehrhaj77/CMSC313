LDFLAGS = -g -melf_i386
%.o: %.asm 
	nasm -g -f elf -l $*.lst $< -o $@

TARGET=escapeseqs.out

OBJS=escapeseqs.o

${TARGET}: ${OBJS}
	${LD} ${LDFLAGS} $(OBJS} -o ${TARGET}