CC = cc
CFLAGS = -Wall -fPIE -pie -fno-stack-protector -O0

all: ASLRestima stack_entropy heap_entropy mmap_entropy libso_entropy

ASLRestima: ASLRestima.c
stack_entropy: stack_entropy.c
heap_entropy: heap_entropy.c
mmap_entropy: mmap_entropy.c
libso_entropy: libso_entropy.c -ldl

clean: 
	rm -f *.o ASLRestima stack_entropy heap_entropy mmap_entropy libso_entropy
