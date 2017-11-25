CC = cc
CFLAGS = -Wall -fPIE -pie -fno-stack-protector -O0

all: ASLRestima text_entropy stack_entropy heap_entropy mmap_entropy libso_entropy

ASLRestima: ASLRestima.c
text_entropy: text_entropy.c
stack_entropy: stack_entropy.c
heap_entropy: heap_entropy.c
mmap_entropy: mmap_entropy.c
libso_entropy: libso_entropy.c -ldl

clean: 
	rm -f *.o ASLRestima text_entropy stack_entropy heap_entropy mmap_entropy libso_entropy
