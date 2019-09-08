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
// Conditions
%token IF
// Cycles
%token REPEAT
// Asign
%token OP_ASIG

%%
programa: 
        programa1 {
                pprintf("--- Compilacion ok ---");
        }
        ;

programa1:
        declaraciones cuerpo
        | declaraciones
        | cuerpo
        ;


cuerpo: cuerpo sentencia | sentencia;

sentencia:
        ciclo_repeat
        | asignacion
        | condicional
        ;

declaraciones: 
        VAR ENDVAR {
                pprintf("DECLARACIONES");
        };

ciclo_repeat:
        REPEAT {
                pprintf("CICLO REPEAT");
        };

asignacion:
        OP_ASIG {
                pprintf("ASIGNACION");
        };

condicional:
        IF {
                pprintf("CONDICIONAL");
        };

%%