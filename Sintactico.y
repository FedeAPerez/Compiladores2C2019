%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "prints.h"
#include "pila-dinamica.h" 
#include "tercetos.h"
#include "status.h"
#include "archivos.h"
#include "assembler.h"
#include "ts.h" 

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
pila_s pilaIDDeclare;
pila_s pilaTipoDeclare;
pila pilaExpresion;
pila pilaTermino;
pila pilaRepeat;

 
int main()
{
        clean();
        crearPila(&pilaRepeat);
        crearPila(&pilaFactor);
        crearPila(&pilaID);
        crearPila(&pilaExpresion);
        crearPila(&pilaTermino);
        yyparse();
        generarAssembler();
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

        // Separen los punteros por comentarios que los agrupen
        int Tind = -1;
        int Find = -1;
        int Eind = -1;
        int Eizqind = -1;
        int Aind = -1;
        int LVind = -1;
        int LDind = -1;
        int Tind1 = -1;
        int Tind2 = -1;
        int ELind = -1;
        int Cind = -1;
        char valor_comparacion[3] = "";
        int TLind = -1;
        int TLSalto = -1;

        char *comparacionActual = "";

%}

%type <intValue> CONST_INT
%type <floatValue> CONST_FLOAT
%type <stringValue> ID CONST_STRING TIPO_FLOAT TIPO_INTEGER

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

%start programa_aumentado
%%
programa_aumentado: 
        programa {
                pprints("COMPILACION EXITOSA");
        };

programa:
        declaraciones cuerpo
        | declaraciones
        | cuerpo;

// Declaraciones
declaraciones:
        VAR lista_linea_declaraciones ENDVAR;

lista_linea_declaraciones:
        lista_linea_declaraciones linea_declaraciones
        | linea_declaraciones;

linea_declaraciones:
        CORCHETE_ABRE {
                crearPilaS(&pilaIDDeclare);
                crearPilaS(&pilaTipoDeclare);
        } lista_tipo_datos CORCHETE_CIERRA DOS_PUNTOS CORCHETE_ABRE lista_id CORCHETE_CIERRA {
                while(!pilaVaciaS(&pilaIDDeclare) && !pilaVaciaS(&pilaTipoDeclare)){
                        char *id = sacarDePilaS(&pilaIDDeclare);
                        char *type = sacarDePilaS(&pilaTipoDeclare);
                        modifyTypeTs(id, type);
                }
        };

lista_tipo_datos:
        lista_tipo_datos COMA tipo_dato
        | tipo_dato;

lista_id:
        lista_id COMA ID {
                ponerEnPilaS(&pilaIDDeclare, $3);
        }
        | ID {
                ponerEnPilaS(&pilaIDDeclare, $1);
        };

tipo_dato:
        TIPO_INTEGER {
                ponerEnPilaS(&pilaTipoDeclare, $1);
        }
        | TIPO_FLOAT {
                ponerEnPilaS(&pilaTipoDeclare, $1);
        };

//Fin Declaraciones

//Seccion codigo
cuerpo: 
        cuerpo sentencia
        | sentencia;

sentencia:
        ciclo_repeat
        | asignacion
        | asignacion_multiple
        | condicional
        | io_lectura
        | io_salida;

io_lectura:
        READ ID;

io_salida:
        PRINT CONST_STRING | PRINT ID;

condicional:
        IF expresion_logica THEN cuerpo {
                Cind = crearTerceto("JI","#", "_", numeracionTercetos);
                while(!pilaVacia(&pilaExpresion)){
                        ActualizarArchivo(sacarDePila(&pilaExpresion), Cind + 1);
                }
                ponerEnPila(&pilaExpresion,Cind);
                numeracionTercetos = avanzarTerceto(numeracionTercetos);
        } ELSE cuerpo ENDIF {				
                ActualizarArchivo(sacarDePila(&pilaExpresion), numeracionTercetos);
                numeracionTercetos = avanzarTerceto(numeracionTercetos);
        }
        | IF expresion_logica THEN cuerpo {
                Cind = crearTerceto("JI","#", "_", numeracionTercetos);
                while(!pilaVacia(&pilaExpresion)){
                        ActualizarArchivo(sacarDePila(&pilaExpresion), Cind + 1);
                }
                ponerEnPila(&pilaExpresion,Cind);
                numeracionTercetos = avanzarTerceto(numeracionTercetos);
        } ENDIF {
                ActualizarArchivo(sacarDePila(&pilaExpresion), numeracionTercetos);
                numeracionTercetos = avanzarTerceto(numeracionTercetos);
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
        };

asignacion:
        ID OP_ASIG expresion_algebraica {
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
        lista_datos COMA expresion_algebraica  {
                LDind = Eind;
                ponerEnPila(&pilaExpresion, LDind);
        }
        | expresion_algebraica {
                LDind = Eind;
                ponerEnPila(&pilaExpresion, LDind);
        };

expresion_logica:
        termino_logico {
                ELind = Tind;
                ELind = crearTerceto(valor_comparacion,"#", "_", numeracionTercetos);
                ponerEnPila(&pilaExpresion,ELind);
                numeracionTercetos = avanzarTerceto(numeracionTercetos);
	} AND termino_logico {
                ELind = Tind;
                ELind = crearTerceto(valor_comparacion,"#", "_", numeracionTercetos);
                ponerEnPila(&pilaExpresion,ELind);
                numeracionTercetos = avanzarTerceto(numeracionTercetos);
        }
        | termino_logico {
                ELind = Tind;
                ELind = crearTercetoSalto(valor_comparacion,numeracionTercetos + 1, "_", numeracionTercetos);
                numeracionTercetos = avanzarTerceto(numeracionTercetos);
        } OR termino_logico {
                ELind = Tind;
                ELind = crearTerceto(valor_comparacion,"#", "_", numeracionTercetos);
                ponerEnPila(&pilaExpresion,ELind);
                numeracionTercetos = avanzarTerceto(numeracionTercetos);
        }
        | NOT termino_logico {
                ELind = Tind;
                ELind = crearTerceto(valor_comparacion,"#", "_", numeracionTercetos);
                ponerEnPila(&pilaExpresion,ELind);
                numeracionTercetos = avanzarTerceto(numeracionTercetos);
        }
        | termino_logico {
                ELind = Tind;
                ELind = crearTerceto(valor_comparacion,"#", "_", numeracionTercetos);
                ponerEnPila(&pilaExpresion,ELind);
                numeracionTercetos = avanzarTerceto(numeracionTercetos);
        };

termino_logico: 
        expresion_algebraica {Tind1 = Eind;} comparacion expresion_algebraica {Tind2 = Eind;} {
                Tind = crearTercetoOperacion("CMP", Tind1, Tind2, numeracionTercetos);
                numeracionTercetos = avanzarTerceto(numeracionTercetos);
        };

comparacion:
        OP_MENOR {
                strcpy(valor_comparacion, "JB");
        }
        | OP_MENOR_IGUAL {
                strcpy(valor_comparacion, "JBE");
        }
	| OP_MAYOR {
                strcpy(valor_comparacion, "JA");
        }
	| OP_MAYOR_IGUAL {
		strcpy(valor_comparacion, "JAE");
        }
	| OP_IGUAL {
		strcpy(valor_comparacion, "JE");
        }
	| OP_DISTINTO {
		strcpy(valor_comparacion, "JNE");
        };

expresion_algebraica: expresion;

expresion:
        expresion OP_SUMA termino {
                Eind = crearTercetoOperacion("+", Eind, Tind, numeracionTercetos);
                numeracionTercetos = avanzarTerceto(numeracionTercetos);
                status("expresion suma termino a expresion");
        }
        | expresion OP_RESTA termino {      
                Eind = crearTercetoOperacion("-", Eind, Tind, numeracionTercetos);
                numeracionTercetos = avanzarTerceto(numeracionTercetos);
                status("expresion resta termino a expresion");
        }
        | termino {
                Eind = Tind;
                status("termino a exp");
        };
		
termino:
        termino OP_MULTIPLICACION factor {
                Tind = crearTercetoOperacion("*", Tind, Find, numeracionTercetos);
                numeracionTercetos = avanzarTerceto(numeracionTercetos);
                status("multiplicar a termino");
        }
        | termino OP_DIVISION factor {
                Tind = crearTercetoOperacion("/", Tind, Find, numeracionTercetos);
                numeracionTercetos = avanzarTerceto(numeracionTercetos);
                status("dividir a termino");
        }
        | factor {
                Tind = Find;                
                status("factor a termino");
        };

factor:
        CONST_INT {
                Find = crearTercetoInt($1, "_", "_", numeracionTercetos);
                numeracionTercetos = avanzarTerceto(numeracionTercetos);
                status("int a factor");
        }
        | CONST_FLOAT {
                Find = crearTercetoFloat($1, "_", "_", numeracionTercetos);
                numeracionTercetos = avanzarTerceto(numeracionTercetos);
                status("float a factor");
        }
        | ID {
                Find = crearTerceto($1, "_", "_", numeracionTercetos);
                ponerEnPila(&pilaFactor, Find);
                numeracionTercetos = avanzarTerceto(numeracionTercetos);
                status("id a factor");
        }
        | PARENTESIS_ABRE expresion PARENTESIS_CIERRA {
                Find = Eind;
                status("pa expresion pc a factor");
        }
        | PARENTESIS_ABRE expresion MOD expresion PARENTESIS_CIERRA {
                Find = crearTercetoOperacion("OP_MOD", Eind, Find, numeracionTercetos);
                numeracionTercetos = avanzarTerceto(numeracionTercetos);
                status("MOD a Factor");
        }
        | PARENTESIS_ABRE expresion DIV expresion PARENTESIS_CIERRA {
                Find = crearTercetoOperacion("OP_DIV", Eind, Find, numeracionTercetos);
                numeracionTercetos = avanzarTerceto(numeracionTercetos);
                status("DIV a Factor");
        };

%%

void status(char *str)
{
        crearStatus(str, Eind, Tind, Find, numeracionTercetos);
}