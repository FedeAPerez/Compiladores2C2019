%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "PilaDinamica.h" 
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

pila pilaFactor;
pila pilaID;
pila pilaExpresion;
pila pilaRepeat;
 
int main()
{
        crearPila(&pilaRepeat);
        crearPila(&pilaFactor);
        crearPila(&pilaID);
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
        int Eizqind = -1;
        int Aind = -1;
        int LVind = -1;
        int LDind = -1;

        int Cind = -1;
        int ELind = -1;
        int TLind = -1;
        int TLSalto = -1;

        char *comparacionActual = "";
%}

%type <intValue> factor termino CONST_INT
%type <floatValue> CONST_FLOAT
%type <stringValue> ID
%type <stringValue> CONST_STRING

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
        CORCHETE_ABRE lista_tipo_datos CORCHETE_CIERRA DOS_PUNTOS CORCHETE_ABRE lista_id CORCHETE_CIERRA {
                pprintf("\tCA lista_tipo_datos CC DOS_PUNTOS CA lista_id CC - es - linea_declaraciones");
        };

lista_tipo_datos:
        lista_tipo_datos COMA tipo_dato {
                pprintf("\tlista_tipo_datos COMA tipo_dato - es - lista_tipo_datos");
        }
        | tipo_dato {
                pprintf("\ttipo_dato - es - lista_tipo_datos");
        };

lista_id:
        lista_id COMA ID
        | ID;

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
        PRINT io_salida_imprimibles;

io_salida_imprimibles: 
        CONST_STRING
        | ID;

condicional:
        IF expresion_logica THEN cuerpo ELSE cuerpo ENDIF {
                pprintf("IF expresion_logica THEN cuerpo ELSE cuerpo ENDIF - es - condicional");
        }
        | IF expresion_logica THEN cuerpo ENDIF {
                pprintf("IF expresion_logica THEN cuerpo ENDIF - es - condicional");
        };

ciclo_repeat:
        REPEAT {
                // ACA SE GUARDO EL COMIENZO EL DEL CUERPO
                ponerEnPila(&pilaRepeat, numeracionTercetos );
                avanzarTerceto(numeracionTercetos);
        } 
        
        cuerpo UNTIL expresion_logica {
                 // ACA SE SALTARIA COMPARANDO EL RESULTADO DE LA EXPRESION LOGICA, POR LO QUE NO SERIA JMP, LO DEJE PARA QUE SE ENTIENDA
                Cind = crearTercetoID("JMP","_", sacarDePila(&pilaRepeat),numeracionTercetos);
                avanzarTerceto(numeracionTercetos);
        
                pprintf("REPEAT cuerpo UNTIL expresion_logica - es - ciclo_repeat");
        };

asignacion:
        ID OP_ASIG expresion {
                Aind = crearTercetoID(":=", $1, Eind, numeracionTercetos);
                numeracionTercetos = avanzarTerceto(numeracionTercetos);
        };

asignacion_multiple:
        asignacion_multiple_declare OP_ASIG asignacion_multiple_asign {
                while(!pilaVacia(&pilaID) && !pilaVacia(&pilaExpresion))
                {
                        Aind = crearTercetoOperacion(":=", sacarDePila(&pilaID), sacarDePila( &pilaExpresion), numeracionTercetos);
                        numeracionTercetos = avanzarTerceto(numeracionTercetos);
                }
        };

asignacion_multiple_declare:
        CORCHETE_ABRE lista_variables CORCHETE_CIERRA;
		
lista_variables:
        lista_variables COMA ID {
                LVind = crearTerceto($3, "_", "_", numeracionTercetos);
                ponerEnPila(&pilaID, LVind);
                numeracionTercetos = avanzarTerceto(numeracionTercetos);
        }
        | ID { 
                LVind = crearTerceto($1, "_", "_", numeracionTercetos);
                ponerEnPila(&pilaID, LVind);
                numeracionTercetos = avanzarTerceto(numeracionTercetos);
        };
		
asignacion_multiple_asign: 
        CORCHETE_ABRE lista_datos CORCHETE_CIERRA;

lista_datos:
        lista_datos COMA expresion  {
				LDind = Eind;
				ponerEnPila(&pilaExpresion, LDind);
                pprintf("\tlista_datos COMA termino - es - lista_datos");
        }
        | expresion {
				LDind = Eind;
				ponerEnPila(&pilaExpresion, LDind);
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
        expresion {Eizqind = Eind;} comparacion expresion {
                pprintf("\t\texpresion comparacion expresion  - es - expresion_logica");
                TLind = crearTercetoOperacion("CMP",Eizqind , Eind , numeracionTercetos);
                avanzarTerceto(numeracionTercetos);
                //SEGUIR
                TLSalto = crearTercetoOperacion(comparacionActual, ,  , numeracionTercetos); // ACA FALTA COMPLETAR 
        };

comparacion:
        OP_MENOR {
                comparacionActual = "JNAE";
        }
        | OP_MENOR_IGUAL {
                comparacionActual = "JNA";
        }
	| OP_MAYOR {
                comparacionActual = "JNBE";
        }
	| OP_MAYOR_IGUAL {
                comparacionActual = "JNB";
        }
	| OP_IGUAL {
                comparacionActual = "JE";
        }
	| OP_DISTINTO {
                comparacionActual = "JNE";
        };

expresion:
        expresion operacion_expresion
        | termino {
                Eind = Tind;
                status("termino a exp");
        };

operacion_expresion:
        OP_SUMA termino {
                Eind = crearTercetoOperacion("+", Eind, Tind, numeracionTercetos);
                numeracionTercetos = avanzarTerceto(numeracionTercetos);
                status("suma");
        }
        | OP_RESTA termino {      
                Eind = crearTercetoOperacion("-", Eind, Tind, numeracionTercetos);
                numeracionTercetos = avanzarTerceto(numeracionTercetos);
                status("resta");
        };
		
termino:
        termino operacion_termino
        | factor {
                $$ = $1;
                Tind = Find;                
                status("factor a termino");
        };

operacion_termino: 
        OP_MULTIPLICACION factor {
                Tind = crearTercetoOperacion("*", Tind, Find, numeracionTercetos);
                numeracionTercetos = avanzarTerceto(numeracionTercetos);
                status("multiplicar");
        }
        | OP_DIVISION factor {
                Tind = crearTercetoOperacion("/", Tind, Find, numeracionTercetos);
                numeracionTercetos = avanzarTerceto(numeracionTercetos);
                status("dividir");
        };

factor:
        CONST_INT {
                $$ = $1;
                Find = crearTercetoInt($1, "_", "_", numeracionTercetos);
		//ponerEnPila(&pilaFactor, Find);
                numeracionTercetos = avanzarTerceto(numeracionTercetos);
                status("crear int");
        }
        | CONST_FLOAT {
                $$ = $1;
                Find = crearTercetoFloat($1, "_", "_", numeracionTercetos);
		//ponerEnPila(&pilaFactor, Find);
                numeracionTercetos = avanzarTerceto(numeracionTercetos);
                status("crear float");
        }
        | ID {
		
                $$ = $1;
                Find = crearTerceto($1, "_", "_", numeracionTercetos);
                ponerEnPila(&pilaFactor, Find);
                numeracionTercetos = avanzarTerceto(numeracionTercetos);
                status("crear id");
        }
        | PARENTESIS_ABRE expresion PARENTESIS_CIERRA {
                Find = Eind;
                status("exp a find - parentesis");
        }
        | expresion expresion_algebraica;

expresion_algebraica:
        MOD expresion {
                Find = crearTercetoOperacion("OP_MOD", Eind, Find, numeracionTercetos);
                numeracionTercetos = avanzarTerceto(numeracionTercetos);
                status("crear MOD");
        }
        | DIV expresion {
        };
%%

void status(char *str)
{
        crearStatus(str, Eind, Tind, Find, numeracionTercetos);
}