#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <string.h>

/* Allocate memory using mmap--

    Signature:
    void * mmap(void * addr, size_t length, int prot, int flags, int fd, off_t offset);

    We assign addr to NULL so the kernel decides the address to create the mapping. */

int main()
{
    /**** Call Mmap ****/
      //printf("PID:%d\n", getpid());
    int ret = -1;
    char* addr = NULL;
    addr = (char *) mmap(NULL, (size_t)2*1024*1024, PROT_READ|PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS | MAP_POPULATE | MAP_HUGETLB, -1, 0);

    if (addr == MAP_FAILED) {
        printf("mapping failed. Exiting the process\n");
        exit(-1);
    }

    /**** Print the result in binary ****/
    char binary[65] = {0};
    long address = (long)addr;
      //printf("%lu\n", address);

      //Print the resulting mmap address
      //printf("%p\n", addr);

    int i;
    long k;
    for (i = 63; i >= 0; i--) {
        k = address >> i;
        if (k & 1)
            strcat(binary, "1");
        else
            strcat(binary, "0");
    }
    
    binary[64] = '\0';
    printf("%s\n", binary);

    /**** Clean Up ****/
    ret = munmap(addr, (size_t)2*1024*1024);
    if(ret == -1) {
        printf("munmap failed. Exiting the process\n");
        exit(-1);
    }

    return 0;
}

//TODO: write errors to a file instead of printing, so if there is an error it won't impact result analysis.
