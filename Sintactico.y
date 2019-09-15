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

// Operadores de Comparación
%token OP_MENOR OP_MENOR_IGUAL OP_MAYOR OP_MAYOR_IGUAL
%token OP_IGUAL OP_DISTINTO
%token AND NOT OR

// Ciclos
%token REPEAT UNTIL

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
                pprintf("VAR ENDVAR - es - declaraciones");
        };

linea_declaraciones:
        CORCHETE_ABRE lista_tipo_datos CORCHETE_CIERRA DOS_PUNTOS CORCHETE_ABRE lista_variables CORCHETE_CIERRA {
                pprintf("\tCA lista_tipo_datos CC DOS_PUNTOS CA lista_variables CC - es - linea_declaraciones");
        };

lista_tipo_datos:
        lista_tipo_datos COMA tipo_dato {
                pprintf("\tlista_tipo_datos COMA tipo_dato - es - lista_tipo_datos");
        }
        | tipo_dato {
                pprintf("\ttipo_dato - es - lista_tipo_datos");
        };

lista_variables:
        lista_variables COMA ID {
                pprintf("\t\tlista_variables COMA ID - es - lista_variables");
        }
        | ID {
                pprintf("\tID - es - lista_Variables");
        };

tipo_dato:
        TIPO_INTEGER {
                pprintf("\t\tINTEGER - es - tipo_dato");
        }
        | TIPO_FLOAT{
                pprintf("\t\tFLOAT - es - tipo_dato");
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
                pprintf("IF - es - condicional\n");
        };

ciclo_repeat:
        REPEAT cuerpo UNTIL expresion_logica {
                pprintf("REPEAT cuerpo UNTIL expresion_logica - es - ciclo_repeat\n");
        };

asignacion:
        ID OP_ASIG expresion {
                pprintf("id OP_ASIG expresion - es - asignacion\n");
        };

asignacion_multiple:
        asignacion_multiple_declare OP_ASIG asignacion_multiple_asign {
                pprintf("asignacion_multiple_declare OP_ASIG asignacion_multiple_asign - es - asignacion_multiple\n");
        };

asignacion_multiple_declare:
        CORCHETE_ABRE lista_variables CORCHETE_CIERRA {
                pprintf("\t\tCA lista_variables CC - es - asignacion_multiple_declare\n");
        };

asignacion_multiple_asign: 
        CORCHETE_ABRE lista_datos CORCHETE_CIERRA {
                pprintf("\t\tCA lista_datos CC - es - asignacion_multiple_asign\n");
        };

lista_datos:
        lista_datos COMA expresion  {
                pprintf("\tlista_datos COMA termino - es - lista_datos");
        }
        | expresion {
                pprintf("\t\ttermino - es - lista_datos");
        };

expresion_logica:
        termino_logico AND termino_logico {
                pprintf(" termino_logico AND termino_logico es expresion_logica");
        }
        | termino_logico OR termino_logico {
                pprintf("termino_logico OR termino_logico - es - expresion_logica");
        }
        | NOT termino_logico {
                pprintf("NOT termino_logico - es - expresion_logica");
        }
        | termino_logico {
                pprintf("termino_logico - es - expresion_logica");
        };

termino_logico: 
        expresion comparacion expresion {
                pprintf("\t\texpresion comparacion expresion  - es - expresion_logica");
        };

comparacion:
        OP_MENOR {
                pprintf("comparacion - es - OP_MENOR");
        }
        | OP_MENOR_IGUAL {
                pprintf("comparacion - es - OP_MENOR_IGUAL");
        }
	| OP_MAYOR {
                pprintf("comparacion - es - OP_MAYOR");
        }
	| OP_MAYOR_IGUAL {
                pprintf("comparacion - es - OP_MAYOR_IGUAL");
        }
	| OP_IGUAL {
                pprintf("comparacion - es - OP_IGUAL");
        }
	| OP_DISTINTO {
                pprintf("OP_DISTINTO - es - comparacion");
        };

expresion:
        expresion OP_SUMA termino {
                pprintf("\texpresion OP_SUMA termino - es - termino");
        }
        | termino {
                pprintf("\ttermino - es - expresion");
        };

termino:
        termino operacion factor {
                pprintf("\t\ttermino operacion factor - es - termino");
        }
        | factor {
                pprintf("\t\tfactor - es - termino");
        };

operacion:
        OP_MULTIPLICACION {
                pprintf("\tOP_MULTIPLICACION - es - operacion");
        }
        | OP_RESTA {
                pprintf("\tOP_RESTA - es - operacion");
        }
        | OP_SUMA {
                pprintf("\tOP_SUMA - es - operacion");
        }
        | OP_DIVISION{
                pprintf("\tOP_DIVISION - es - operacion");
        };

factor:
        CONST_STRING {
                pprintf("\tCTE STRING - es - factor");
        }
        | CONST_INT {
                pprintf("\tCTE INT - es - factor");
        }
        | CONST_FLOAT {
                pprintf("\tCTE FLOAT - es - factor");
        }
        | ID {
                pprintf("\tID - es - factor");
        }
        | PARENTESIS_ABRE expresion PARENTESIS_CIERRA {
                pprintf("\tPARENTESIS_ABRE expresion PARENTESIS_CIERRA - es - factor");
        }
        | expresion MOD expresion {
                pprintf("\t expresion MOD expresion - es - factor");
        }
        | expresion DIV expresion {
                pprintf("\t expresion DIV expresion - es - factor");
        };;

%%