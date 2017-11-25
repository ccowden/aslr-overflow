#include <dlfcn.h>
#include <stdio.h>
#include <gnu/libc-version.h>
#include <stdlib.h>
#include <string.h>

unsigned long long libsoaddr;
char libc_name[] = "libc-";

int main() {

     FILE *fpbin;
     char binaddr[65] = {0};                                                              
     unsigned long long masked;                                                            
     unsigned long long entropy_addr;
     
     fpbin = fopen("libsobin.log", "a");                                               

     strcat(libc_name, gnu_get_libc_version());
     strcat(libc_name, ".so");

     void *handle = dlopen(libc_name, RTLD_LAZY | RTLD_NOLOAD);
     if (handle==NULL)
     {
          printf("ERROR\n");
          return 1;
     }
                                                                                           
     libsoaddr  = (long long ) dlsym(handle, "unlink");
  
     entropy_addr =  libsoaddr;
                                                                                           
     for(masked = 0x8000000000000000; masked > 0; masked >>=1) {                                   
         strcat(binaddr, ((entropy_addr & masked) == masked) ? "1" : "0");                   
     }                                                                                     
     binaddr[65] = '\0';                                                                  
     fprintf(fpbin, "%s\n", binaddr);                                                   
                                                                                           
     fclose(fpbin);                                                                      
     return 0;                                                                             
} 
