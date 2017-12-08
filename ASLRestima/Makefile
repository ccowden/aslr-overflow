CC = cc
CFLAGS = -Wall -fPIE -pie -fno-stack-protector -O0

all: text_entropy stack_entropy heap_entropy mmap_entropy mmaplarge_entropy libso_entropy vdso_entropy entropy64 co_entropy

text_entropy: text_entropy.c
stack_entropy: stack_entropy.c
heap_entropy: heap_entropy.c
mmap_entropy: mmap_entropy.c
vdso_entropy: vdso_entropy.c
libso_entropy: libso_entropy.c -ldl
entropy64: entropy64.c
co_entropy:co_entropy.c -ldl
mmaplarge_entropy:mmaplarge_entropy.c 

clean: 
	rm -f *.o text_entropy stack_entropy heap_entropy mmap_entropy mmaplarge_entropy libso_entropy vdso_entropy entropy64 co_entropy

superclean:
	rm -f *.o *.png *.txt text_entropy stack_entropy heap_entropy mmap_entropy mmaplarge_entropy libso_entropy vdso_entropy entropy64 co_entropy
