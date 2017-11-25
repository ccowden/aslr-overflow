#include <stdio.h>
#include <stdlib.h>
#include <sys/auxv.h>
#include <string.h>

int main(void) {
    //void *addr = (uintptr_t) getauxval(AT_SYSINFO_EHDR);
    //printf("%p\n", addr);

    //long address = (long)addr;
    //printf("%lu\n", address);

    unsigned long address = getauxval(AT_SYSINFO_EHDR);
    //printf("%lu\n", addr);

    char binary[65] = {0};

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
    return 0;
}
