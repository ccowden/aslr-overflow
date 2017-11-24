#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <string.h>

int main()
{
    //void *brk = NULL;

    /* sbrk(0) gives current program break location */
    void * address= NULL;
    address = sbrk(0);
    //printf("%p\n", address);
    char binary[65] = {0};
    //unsigned int mask;
    long address2 = (long)address;
    //printf("%lu\n", address2);

    int i;
    long k;
    for (i = 63; i >= 0; i--) {
        k = address2 >> i;
        if (k & 1)
            strcat(binary, "1");
        else
            strcat(binary, "0");
    }
    
    binary[64] = '\0';
    printf("%s\n", binary);

    return 0;
}
