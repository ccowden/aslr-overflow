#include <stdio.h>
#include <stdlib.h>
#include <string.h>

unsigned long long stackaddr;

int main() {

     unsigned long long stackvar = 42;                                                    
     char binaddr[65] = {0};                                                              
     unsigned long long masked;                                                            
     unsigned long long entropy_addr = 0;
                                                                                           
     stackaddr = (unsigned long long) &stackvar;
     entropy_addr = stackaddr;
                                                                                           
     for(masked = 0x8000000000000000; masked > 0; masked >>=1) {                                   
         strcat(binaddr, ((entropy_addr & masked) == masked) ? "1" : "0");                   
     }                                                                                     
                                                                                           
     binaddr[65] = '\0';                                                                  
     printf("%s\n", binaddr);                                                   
                                                                                           
     return 0;                                                                             
} 
