%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "tercetos.h"
#include "status.h"
 
int yylex();
int yyparse();
void yyerror(const char *str);
void status();

void yyerror(const char *str)
{

        printf("\033[0;31m");        
        printf("\t[SYNTAX ERROR]: %s\n", str);
        printf("\033[0m");
}

int yywrap()
{
        return 1;
} 
  
int main()
{
        yyparse();
        exit(0);
}

void pprintf(char *str) {
        printf("\t %s \n", str);
}

void pprintfd(int str) {
        printf("\t %d \n", str);
}

void pprintff(float str) {
        printf("\t %f \n", str);
}

void pprints()
{
    printf("\033[0;32m");
    printf("\t[COMPILACION EXITOSA]\n");
    printf("\033[0m");
    exit(0);
}

%}

%union
{
        int intValue;
        float floatValue;
        char *stringValue;
}

%{
        // Aux
        int numeracionTercetos = 0;
        // Índices
        int Tind = -1;
        int Find = -1;
        int Eind = -1;
%}

%type <intValue> factor termino CONST_INT
%type <floatValue> CONST_FLOAT

// Sector declaraciones
%token VAR ENDVAR TIPO_INTEGER TIPO_FLOAT

// Condiciones
%token IF THEN ELSE ENDIF

// Operadores de Comparación
%token OP_MENOR OP_MENOR_IGUAL OP_MAYOR OP_MAYOR_IGUAL
%token OP_IGUAL OP_DISTINTO
%token AND NOT OR

// Ciclos
%token REPEAT UNTIL

// I/O
%token PRINT READ

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
        declaraciones cuerpo {
                pprintf("\tdeclaraciones cuerpo - es -  programa\n");
        }
        | declaraciones {
                pprintf("\tdeclaraciones - es -  programa");
        }
        | cuerpo {
                pprintf("\tcuerpo - es -  programa");
        };

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

//Seccion codigo
cuerpo: 
        cuerpo sentencias {
                pprintf("\tcuerpo sentencia - es - cuerpo\n");
        }
        | sentencias {
                pprintf("\tsentencia - es - cuerpo\n");
        };

sentencias: 
        sentencia1;

sentencia1: 
        sentencia sentencia1
        | sentencia;       

sentencia:
        ciclo_repeat {
                pprintf("\tciclo_repeat - es - sentencia");
        }
        | asignacion {
                pprintf("\tasignacion - es - sentencia");
        }
        | asignacion_multiple {
                pprintf("\tsignacion_multiple - es - sentencia");
        }
        | condicional {
                pprintf("\tcondicional - es - sentencia");
        }
        | io_lectura {
                pprintf("\t io_lectura - es - sentencia");
        }
        | io_salida {
                pprintf("\t io_salida - es - sentencia");
        };

io_lectura:
        READ ID {
                pprintf("READ ID - es - io_lectura");
        };

io_salida:
        PRINT CONST_STRING {
                pprintf("PRINT CONST_STRING - es - io_salida");
        }
        | PRINT ID
        {
                pprintf("PRINT ID - es - io_salida");
        };

condicional:
        IF expresion_logica THEN cuerpo ELSE cuerpo ENDIF {
                pprintf("IF expresion_logica THEN cuerpo ELSE cuerpo ENDIF - es - condicional");
        }
        | IF expresion_logica THEN cuerpo ENDIF {
                pprintf("IF expresion_logica THEN cuerpo ENDIF - es - condicional");
        };

ciclo_repeat:
        REPEAT cuerpo UNTIL expresion_logica {
                pprintf("REPEAT cuerpo UNTIL expresion_logica - es - ciclo_repeat");
        };

asignacion:
        ID OP_ASIG expresion {
                crearTercetoOperacion(":=", 1, Eind, numeracionTercetos);
        };

asignacion_multiple:
        asignacion_multiple_declare OP_ASIG asignacion_multiple_asign {
                pprintf("asignacion_multiple_declare OP_ASIG asignacion_multiple_asign - es - asignacion_multiple");
        };

asignacion_multiple_declare:
        CORCHETE_ABRE lista_variables CORCHETE_CIERRA {
                pprintf("\t\tCA lista_variables CC - es - asignacion_multiple_declare");
        };

asignacion_multiple_asign: 
        CORCHETE_ABRE lista_datos CORCHETE_CIERRA {
                pprintf("\t\tCA lista_datos CC - es - asignacion_multiple_asign");
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
                pprintf("termino_logico AND termino_logico - es - expresion_logica");
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
        }
        | OP_MENOR_IGUAL {
        }
	| OP_MAYOR {
        }
	| OP_MAYOR_IGUAL {
        }
	| OP_IGUAL {
        }
	| OP_DISTINTO {
        };

expresion:
        expresion OP_SUMA termino {
                numeracionTercetos = crearTercetoOperacion("OP_SUMA", Eind, Tind, numeracionTercetos);
                Eind = numeracionTercetos - 1;
                status("suma");
        }
        | expresion OP_RESTA termino {      
                numeracionTercetos = crearTercetoOperacion("OP_RESTA", Eind, Tind, numeracionTercetos);
                Eind = numeracionTercetos - 1;
                status("resta");
        }
        | termino {
                Eind = Tind;
                status("termino a exp");
        };
		
termino:
        termino OP_MULTIPLICACION factor {
                numeracionTercetos = crearTercetoOperacion("OP_MULTIPLICACION", Tind, Find, numeracionTercetos);
                Tind = numeracionTercetos - 1;
                status("multiplicar");
        }
        | termino OP_DIVISION factor {
                numeracionTercetos = crearTercetoOperacion("OP_DIVISION", Tind, Find, numeracionTercetos);
                Tind = numeracionTercetos - 1;
                status("dividir");
        }
        | factor {
                $$ = $1;
                Tind = Find;                
                status("factor a termino");
        };

factor:
        CONST_INT {
                $$ = $1;
                Find = numeracionTercetos;
                numeracionTercetos = crearTercetoInt($1, "_", "_", numeracionTercetos);
                status("crear int");
        }
        | CONST_FLOAT {
                $$ = $1;
                Find = numeracionTercetos;
                numeracionTercetos = crearTercetoFloat($1, "_", "_", numeracionTercetos);
                status("crear float");
        }
        | ID {
        }
        | PARENTESIS_ABRE expresion PARENTESIS_CIERRA {
                Find = Eind;
                status("exp a find - parentesis");
        }
        | expresion MOD expresion {
                numeracionTercetos = crearTercetoOperacion("OP_MOD", Eind, Find, numeracionTercetos);
                Find = numeracionTercetos;
                status("crear MOD");
        }
        | expresion DIV expresion {
        };;
%%

void status(char *str)
{
        crearStatus(str, Eind, Tind, Find, numeracionTercetos);
}