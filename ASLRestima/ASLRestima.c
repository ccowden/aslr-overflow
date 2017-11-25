#include <stdio.h>
#include <stdlib.h>
#include <string.h>

unsigned long long textaddr;
unsigned long long stackaddr;
unsigned long long heapaddr;
unsigned long long libsoaddr;
unsigned long long mapaddr;
unsigned long long vdsoaddr;
unsigned long long argument;
unsigned long long loadaddr;

void hidden() {
    printf("How did you get here...?\n");
}


int main() {

     unsigned long long stackvar = 42;                                                    
     FILE *fp;
     char binstack[65] = {0};                                                              
     unsigned long long masked;                                                            
     unsigned long long delta_addr;

     fp = fopen("textstack.log", "a");                                               
                                                                                           
     stackaddr = (unsigned long long) &stackvar;                                                                
     textaddr  = (unsigned long long) hidden;
  
     delta_addr = stackaddr - textaddr ;
                                                                                           
     for(masked = 0x8000000000000000; masked > 0; masked >>=1) {                                   
         strcat(binstack, ((delta_addr & masked) == masked) ? "1" : "0");                   
     }                                                                                     
                                                                                           
     binstack[65] = '\0';                                                                  
     fprintf(fp, "%s\n", binstack);                                                   
                                                                                           
     fclose(fp);                                                                      
     return 0;                                                                             
} 
