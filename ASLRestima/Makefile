CC = cc
CFLAGS = -Wall -fPIE -pie -fno-stack-protector -O0

all: ASLRestima heap_entropy mmap_entropy

ASLRestima: ASLRestima.c
heap_entropy: heap_entropy.c
mmap_entropy: mmap_entropy.c

clean: 
	rm -f *.o ASLRestima heap_entropy mmap_entropy
