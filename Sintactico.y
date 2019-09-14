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
%token VAR ENDVAR INTEGER FLOAT
// Condiciones
%token IF
// Ciclos
%token REPEAT
// Asignacion
%token ID OP_ASIG
// Constantes
%token CONST_STRING CONST_INT
// Operadores
%token OP_MULTIPLICACION OP_SUMA OP_RESTA OP_DIVISION
// Parentesis, corchetes, otros caracteres
%token PA PC CA CC COMA DOS_PUNTOS



%%
programa_aumentado: 
        programa {
                pprintf("--- Compilacion ok ---");
        };

programa:
        declaraciones cuerpo
        | declaraciones
        | cuerpo;

// Declaraciones
declaraciones:
        VAR linea_declaraciones ENDVAR {
                pprintf("VAR ENDVAR -> declaraciones\n");
        }
        | VAR ENDVAR;

linea_declaraciones:
        CA lista_tipo_datos CC DOS_PUNTOS CA lista_variables CC{
                pprintf("CA lista_tipo_datos CC DOS_PUNTOS CA lista_variables CC -> linea_declaraciones\n");
        };

lista_tipo_datos:
        lista_tipo_datos COMA tipo_dato {
                pprintf("lista_tipo_datos COMA TIPO_DATO -> lista_tipo_datos\n");
        }
        | tipo_dato {
                pprintf("TIPO_DATO -> lista_tipo_datos\n");
        };

lista_variables:
        lista_variables COMA ID {
                pprintf("lista_variables COMA ID -> lista_variables\n");
        }
        | ID {
                pprintf("lista_variables -> lista_Variables\n");
        };

tipo_dato:
        INTEGER
        | FLOAT;
//Fin Declaraciones

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
        termino operacion factor {
                pprintf("\ttermino operacion factor -> termino\n");
        }
        | factor {
                pprintf("\tfactor -> termino");
        };

operacion:
        OP_MULTIPLICACION {
                pprintf("\t multiplicacion -> operacion");
        }
        | OP_RESTA {
                pprintf("\t resta -> operacion");
        }
        | OP_SUMA {
                pprintf("\t suma -> operacion");
        }
        | OP_DIVISION{
                pprintf("\t division -> operacion");
        };

factor:
        CONST_STRING {
                pprintf("\t\tCTE STRING -> factor");
        }
        | CONST_INT {
                pprintf("\t\tCTE INT -> factor");
        }
        | ID{
                pprintf("\t\t ID -> factor");
        }
        | PA termino PC {
                pprintf("\t\tParentesisA operacion parentesisC -> factor");
        };

%%