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

void pprints()
{
    printf("\033[0;32m");
    printf("\t[Successful Compilation]\n");
    printf("\033[0m");
}

%}

%union
{
        int intValue;
        float floatValue;
        char *stringValue;
}

// Sector declaraciones
%token VAR ENDVAR TIPO_INTEGER TIPO_FLOAT

// Condiciones
%token IF

// Ciclos
%token REPEAT

// MOD / DIV
%token MOD DIV

// Asignacion
%token ID OP_ASIG

// Constantes
%token CONST_STRING CONST_INT CONST_FLOAT

// Operadores
%token OP_MULTIPLICACION OP_SUMA OP_RESTA OP_DIVISION

// Parentesis, corchetes, otros caracteres
%token PARENTESIS_ABRE PARENTESIS_CIERRA CORCHETE_ABRE CORCHETE_CIERRA COMA DOS_PUNTOS

%%
programa_aumentado: 
        programa {
                pprints();
        };

programa:
        declaraciones cuerpo
        | declaraciones
        | cuerpo;

// Declaraciones
declaraciones:
        VAR linea_declaraciones ENDVAR {
                pprintf("VAR ENDVAR -> declaraciones");
        };

linea_declaraciones:
        CORCHETE_ABRE lista_tipo_datos CORCHETE_CIERRA DOS_PUNTOS CORCHETE_ABRE lista_variables CORCHETE_CIERRA {
                pprintf("\tCA lista_tipo_datos CC DOS_PUNTOS CA lista_variables CC -> linea_declaraciones");
        };

lista_tipo_datos:
        lista_tipo_datos COMA tipo_dato {
                pprintf("\tlista_tipo_datos COMA tipo_dato -> lista_tipo_datos");
        }
        | tipo_dato {
                pprintf("\ttipo_dato -> lista_tipo_datos");
        };

lista_variables:
        lista_variables COMA ID {
                pprintf("\t\tlista_variables COMA ID -> lista_variables");
        }
        | ID {
                pprintf("\tID -> lista_Variables");
        };

tipo_dato:
        TIPO_INTEGER {
                pprintf("\t\tINTEGER -> tipo_dato");
        }
        | TIPO_FLOAT{
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
        ID OP_ASIG expresion {
                pprintf("id OP_ASIG expresion -> asignacion\n");
        };

asignacion_multiple:
        asignacion_multiple_declare OP_ASIG asignacion_multiple_asign {
                pprintf("asignacion_multiple_declare OP_ASIG asignacion_multiple_asign -> asignacion_multiple\n");
        };

asignacion_multiple_declare:
        CORCHETE_ABRE lista_variables CORCHETE_CIERRA {
                pprintf("\t\tCA lista_variables CC -> asignacion_multiple_declare\n");
        };

asignacion_multiple_asign: 
        CORCHETE_ABRE lista_datos CORCHETE_CIERRA {
                pprintf("\t\tCA lista_datos CC -> asignacion_multiple_asign\n");
        };

lista_datos:
        lista_datos COMA expresion  {
                pprintf("\tlista_datos COMA termino -> lista_datos");
        }
        | expresion {
                pprintf("\t\ttermino -> lista_datos");
        };

expresion:
        expresion OP_SUMA termino {
                pprintf("\texpresion OP_SUMA termino -> termino");
        }
        | termino {
                pprintf("\ttermino -> expresion");
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
                pprintf("\tOP_MULTIPLICACION -> operacion");
        }
        | OP_RESTA {
                pprintf("\tOP_RESTA -> operacion");
        }
        | OP_SUMA {
                pprintf("\tOP_SUMA -> operacion");
        }
        | OP_DIVISION{
                pprintf("\tOP_DIVISION -> operacion");
        };

factor:
        CONST_STRING {
                pprintf("\tCTE STRING -> factor");
        }
        | CONST_INT {
                pprintf("\tCTE INT -> factor");
        }
        | CONST_FLOAT {
                pprintf("\tCTE FLOAT -> factor");
        }
        | ID {
                pprintf("\tID -> factor");
        }
        | PARENTESIS_ABRE expresion PARENTESIS_CIERRA {
                pprintf("\tPARENTESIS_ABRE expresion PARENTESIS_CIERRA -> factor");
        }
        | expresion MOD expresion {
                pprintf("\t expresion MOD expresion -> factor");
        }
        | expresion DIV expresion {
                pprintf("\t expresion DIV expresion -> factor");
        };;

%%