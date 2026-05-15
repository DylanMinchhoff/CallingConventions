CC=gcc
# CC32=i686-w64-mingw32-gcc
CC32=i686-w64-mingw32-gcc
ASM=nasm

CFLAGS64=-m64 -g
ASMFLAGS64=-f win64

CFLAGS32=-g
ASMFLAGS32=-f win32

all: main64

cc_64.o: cc_64.asm
	$(ASM) $(ASMFLAGS64) cc_64.asm -o cc_64.o

cc_mem64.o: cc_mem64.asm
	$(ASM) $(ASMFLAGS64) cc_mem64.asm -o cc_mem64.o

cc_32.o: cc_32.asm
	$(ASM) $(ASMFLAGS32) cc_32.asm -o cc_32.o

cc_mem32.o: cc_mem32.asm
	$(ASM) $(ASMFLAGS32) cc_mem32.asm -o cc_mem32.o

main64.o: main64.c
	$(CC) $(CFLAGS64) -c main64.c -o main64.o

main32.o: main32.c
	$(CC32) $(CFLAGS32) -c main32.c -o main32.o

main64: main64.o cc_64.o cc_mem64.o
	$(CC) $(CFLAGS64) main64.o cc_64.o cc_mem64.o -o main64

main32: main32.o cc_32.o cc_mem32.o
	$(CC32) $(CFLAGS32) main32.o cc_32.o cc_mem32.o -o main32

clean:
	rm -f *.o main64 main32

clean_obj:
	rm -f *.o