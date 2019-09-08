%{
#include <stdio.h>
#include <string.h>
 
void yyerror(const char *str)
{
        fprintf(stderr,"error: %s\n",str);
}
 
int yywrap()
{
        return 1;
} 
  
int main()
{
        yyparse();
}

void pprintf(const char *str) {
        printf("\t %s \n", str);
}

%}

// Declare
%token VAR ENDVAR

%%
programa: 
        programa1 {
                pprintf("--- Compilacion ok ---");
        }
        ;

programa1:
        declaraciones
        ;

declaraciones: 
        VAR ENDVAR {
                pprintf("DECLARACIONES");
        };

%%