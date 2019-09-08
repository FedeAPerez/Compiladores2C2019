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

%union
{
        int intValue;
        char *stringValue;
}

// Sector declaraciones
%token VAR ENDVAR
// Condiciones
%token IF
// Ciclos
%token REPEAT
// Asignacion
%token ID OP_ASIG
// Constantes
%token CONST_STRING CONST_INT
// Operadores
%token OP_MULTIPLICACION

%%
programa_aumentado: 
        programa {
                pprintf("--- Compilacion ok ---");
        };

programa:
        declaraciones cuerpo
        | declaraciones
        | cuerpo;

declaraciones: 
        VAR ENDVAR {
                pprintf("VAR ENDVAR -> declaraciones\n");
        };

cuerpo: 
        cuerpo sentencia 
        | sentencia;

sentencia:
        ciclo_repeat
        | asignacion
        | condicional;

condicional:
        IF {
                pprintf("IF -> condicional\n");
        };

ciclo_repeat:
        REPEAT {
                pprintf("REPEAT -> ciclo_repeat\n");
        };

asignacion:
        ID OP_ASIG termino {
                pprintf("id OP_ASIG termino -> asignacion\n");
        };

termino:
        termino OP_MULTIPLICACION factor {
                pprintf("\ttermino OP_MULTIPLICACION factor -> termino");
        }
        | factor {
                pprintf("\tfactor -> termino");
        };

factor:
        CONST_STRING {
                pprintf("\t\tCTE STRING -> factor");
        }
        | CONST_INT {
                pprintf("\t\tCTE INT -> factor");
        };


%%