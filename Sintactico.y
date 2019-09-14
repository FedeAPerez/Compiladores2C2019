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
                pprintf("VAR ENDVAR -> declaraciones");
        }
        | VAR ENDVAR;

linea_declaraciones:
        CA lista_tipo_datos CC DOS_PUNTOS CA lista_variables CC{
                pprintf("\tCA lista_tipo_datos CC DOS_PUNTOS CA lista_variables CC -> linea_declaraciones");
        };

lista_tipo_datos:
        lista_tipo_datos COMA tipo_dato {
                pprintf("\tlista_tipo_datos COMA TIPO_DATO -> lista_tipo_datos");
        }
        | tipo_dato {
                pprintf("\ttipo_dato -> lista_tipo_datos");
        };

lista_variables:
        lista_variables COMA ID {
                pprintf("\tlista_variables COMA ID -> lista_variables");
        }
        | ID {
                pprintf("\t\tID -> lista_Variables");
        };

tipo_dato:
        INTEGER {
                pprintf("\t\tINTEGER -> tipo_dato");
        };
        | FLOAT{
                pprintf("\t\tFLOAT -> tipo_dato");
        };
//Fin Declaraciones

cuerpo: 
        cuerpo sentencia 
        | sentencia;

sentencia:
        ciclo_repeat
        | asignacion
        | asignacion_multiple
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

asignacion_multiple:
        CA lista_variables CC OP_ASIG CA lista_datos CC{
                pprintf("CA lista_variables CC OP_ASIG CA lista_datos CC --> asignacion_multiple\n");
        };

lista_datos:
        lista_datos COMA factor{
                pprintf("\tlista_datos COMA factor -> lista_datos");
        }
        | factor {
                pprintf("\t\tfactor -> lista_datos");
        };

termino:
        termino operacion factor {
                pprintf("\t\ttermino operacion factor -> termino");
        }
        | factor {
                pprintf("\t\tfactor -> termino");
        };

operacion:
        OP_MULTIPLICACION {
                pprintf("\tmultiplicacion -> operacion");
        }
        | OP_RESTA {
                pprintf("\tresta -> operacion");
        }
        | OP_SUMA {
                pprintf("\tsuma -> operacion");
        }
        | OP_DIVISION{
                pprintf("\tdivision -> operacion");
        };

factor:
        CONST_STRING {
                pprintf("\t\t\tCTE STRING -> factor");
        }
        | CONST_INT {
                pprintf("\t\t\tCTE INT -> factor");
        }
        | ID{
                pprintf("\t\t\tID -> factor");
        }
        | termino{
                pprintf("\t\t\toperacion-> factor");                
        }
        | PA termino PC {
                pprintf("\t\t\tParentesisA operacion parentesisC -> factor");
        };

%%