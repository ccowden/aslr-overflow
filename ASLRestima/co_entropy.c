#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <sys/auxv.h>
#include <unistd.h>
#include <sys/types.h>
#include <dlfcn.h>
#include <gnu/libc-version.h>
#include <string.h>

unsigned long long libsoaddr;
unsigned long long textaddr;
unsigned long long text1addr;
unsigned long long stackaddr;
unsigned long long heapaddr;
unsigned long long vdsoaddr;
unsigned long long mmapaddr;

char libc_name[] = "libc-";

void hidden() {
   printf("How did you get here...?\n");
}

void hidden1() {
   printf("How did you get here...?\n");
}

int main() {
     FILE *fptexttext  = fopen("texttextbin.log", "a");
     FILE *fptextlibso = fopen("textlibsobin.log", "a");
     FILE *fptextvdso  = fopen("textvdsobin.log", "a");
     FILE *fplibsovdso = fopen("libsovdsobin.log", "a");
     FILE *fpheaplibso = fopen("heaplibsobin.log", "a");
     FILE *fpheapstack = fopen("heapstackbin.log", "a");

     char binaddr1[65] = {0};                                                              
     char binaddr2[65] = {0};                                                              
     char binaddr3[65] = {0};                                                              
     char binaddr4[65] = {0};                                                              
     char binaddr5[65] = {0};                                                              
     char binaddr6[65] = {0};                                                              
     unsigned long long entropy_addr;
     unsigned long long stackvar = 42;
     unsigned long long *haddr = NULL;
     char * maddr = NULL;
     int ret = -1;
     unsigned long long masked;

     haddr   = sbrk(0);
     maddr   = mmap(NULL, (size_t)132*1024, PROT_READ|PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 
     if(maddr == MAP_FAILED) {
        printf("mmap mapping failed!!!");
        exit(-1);
     }
     
     strcat(libc_name, gnu_get_libc_version());
     strcat(libc_name, ".so");

     void *handle = dlopen(libc_name, RTLD_LAZY | RTLD_NOLOAD);
     if (handle==NULL)
     {
          printf("ERROR\n");
          return 1;
     }

     libsoaddr  = (unsigned long long) dlsym(handle, "unlink");
     textaddr   = (unsigned long long) hidden;
     text1addr  = (unsigned long long) hidden1;
     stackaddr  = (unsigned long long) &stackvar;
     heapaddr   = (unsigned long long) haddr;
     vdsoaddr   = (unsigned long long) getauxval(AT_SYSINFO_EHDR);
     mmapaddr   = (unsigned long long) maddr;
  
     entropy_addr =   libsoaddr - textaddr;
     for(masked = 0x8000000000000000; masked > 0; masked >>=1) {
         strcat(binaddr1, ((entropy_addr & masked) == masked) ? "1" : "0");                   
     }
     binaddr1[65] = '\0';                                                                  
     fprintf(fptextlibso, "%s\n", binaddr1);                                                   

     entropy_addr =  ((text1addr & 0xFFFFFFFFFFFF) - (textaddr & 0xFFFFFFFFFFFF)) & 0xFFFFFFFFFFFF ;
     for(masked = 0x8000000000000000; masked > 0; masked >>=1) 
         strcat(binaddr2, ((entropy_addr & masked) == masked) ? "1" : "0");
     binaddr2[65] = '\0';
     fprintf(fptexttext, "%s\n", binaddr2);                                                   

     entropy_addr =  textaddr - vdsoaddr;
     for(masked = 0x8000000000000000; masked > 0; masked >>=1) 
         strcat(binaddr3, ((entropy_addr & masked) == masked) ? "1" : "0");                   
     binaddr3[65] = '\0';                                                                  
     fprintf(fptextvdso, "%s\n", binaddr3);                                                   

     entropy_addr =  libsoaddr - vdsoaddr;
     for(masked = 0x8000000000000000; masked > 0; masked >>=1) 
         strcat(binaddr4, ((entropy_addr & masked) == masked) ? "1" : "0");                   
     binaddr4[65] = '\0';                                                                  
     fprintf(fplibsovdso, "%s\n", binaddr4);                                                   

     entropy_addr =  heapaddr - libsoaddr;
     for(masked = 0x8000000000000000; masked > 0; masked >>=1) 
         strcat(binaddr5, ((entropy_addr & masked) == masked) ? "1" : "0");                   
     binaddr5[65] = '\0';                                                                  
     fprintf(fpheaplibso, "%s\n", binaddr5);                                                   

     entropy_addr =  heapaddr - stackaddr;
     for(masked = 0x8000000000000000; masked > 0; masked >>=1) 
         strcat(binaddr6, ((entropy_addr & masked) == masked) ? "1" : "0");                   
     binaddr6[65] = '\0';                                                                  
     fprintf(fpheapstack, "%s\n", binaddr6);                                                   

     ret = munmap(maddr, (size_t)132*1024);
     if (ret == -1 ) {
        printf("munmap failed. Exiting the process\n");
        exit(-1);
     }

     fclose(fptexttext);
     fclose(fptextlibso);
     fclose(fptextvdso);
     fclose(fplibsovdso);
     fclose(fpheaplibso);
                                                                                           
     return 0;                                                                             
} 
