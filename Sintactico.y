%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <conio.h>
	#include <string.h>
	#include "y.tab.h"

	
	//Declaracion de funciones
	void yyerror(const char *str);
	int yywrap();
	void pprintf(const char *str);
	
	int yystopparser=0;
	FILE  *yyin;
%}

%union
{
        int intValue;
		float floatValue;
        char *stringValue;
}

// Sector declaraciones
%token VAR ENDVAR

//Tipos de datos
%token TIPO_INTEGER TIPO_FLOAT TIPO_STRING
%token ID

// Condiciones
%token IF THEN ELSE ENDIF AND OR NOT

// Ciclos
%token REPEAT UNTIL

// Asignacion
%token OP_ASIG

// Constantes
%token CONST_FLOAT CONST_INT CONST_STRING

// Operadores
%token OP_MULTIPLICACION OP_SUMA OP_RESTA OP_DIVISION

// Parentesis, corchetes
%token PARENTESIS_ABRE PARENTESIS_CIERRA CORCHETE_ABRE CORCHETE_CIERRA

//Entrada y salida
%token PRINT READ

//Operadores comparativos
%token OP_MENOR OP_MENOR_IGUAL OP_MAYOR OP_MAYOR_IGUAL
%token OP_IGUAL OP_DISTINTO

//Operadores de puntuacion
%token PYC COMA DOS_PUNTOS

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
        CORCHETE_ABRE lista_tipo_datos CORCHETE_CIERRA DOS_PUNTOS CORCHETE_ABRE lista_variables CORCHETE_CIERRA {
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
        TIPO_INTEGER {
                pprintf("\t\tINTEGER -> tipo_dato");
        };
        | TIPO_FLOAT{
                pprintf("\t\tFLOAT -> tipo_dato");
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
		| expresion_aritmetica;

condicional:
        IF expresion_logica THEN cuerpo ENDIF 	{ pprintf("condicional -> IF expresion_logica THEN cuerpo ENDIF"); };
		
condicional: 
		IF expresion_logica THEN cuerpo ELSE cuerpo ENDIF 	{ pprintf("IF expresion_logica THEN cuerpo ELSE cuerpo ENDIF"); };

ciclo_repeat:
        REPEAT cuerpo UNTIL expresion_logica 	{  pprintf("ciclo_repeat -> REPEAT cuerpo UNTIL expresion_logica\n");} 

asignacion:
        ID OP_ASIG expresion_aritmetica { pprintf("asignacion -> ID OP_ASIG expresion_aritmetica\n"); };

asignacion_multiple:
        asignacion_multiple_declare OP_ASIG asignacion_multiple_asign {
                pprintf("asignacion_multiple_declare OP_ASIG asignacion_multiple_asign --> asignacion_multiple\n");
        };

asignacion_multiple_declare:
        CORCHETE_ABRE lista_variables CORCHETE_CIERRA {
                pprintf("\t\tCA lista_variables CC --> asignacion_multiple_declare\n");
        };

asignacion_multiple_asign: 
        CORCHETE_ABRE lista_datos CORCHETE_CIERRA {
                pprintf("\t\tCA lista_datos CC --> asignacion_multiple_asign\n");
        };

lista_datos:
        lista_datos COMA expresion_aritmetica  {
                pprintf("\tlista_datos COMA termino -> lista_datos");
        }
        | expresion_aritmetica {
                pprintf("\t\ttermino -> lista_datos");
        };
		


//Expresiones
expresion_logica:
		termino_logico AND termino_logico			{pprintf("expresion_logica -> termino_logico AND termino_logico");}
		| termino_logico OR termino_logico			{pprintf("expresion_logica -> termino_logico OR termino_logico");}
		| NOT termino_logico						{pprintf("expresion_logica -> NOT termino_logico");}
		| termino_logico							{pprintf("expresion_logica -> termino_logico");}

termino_logico:
		expresion_aritmetica comparacion expresion_aritmetica 			{pprintf("termino_logico -> expresion_aritmetica comparacion expresion_aritmetica");}

comparacion:
		OP_MENOR 					{pprintf("comparacion -> OP_MENOR");}
		| OP_MENOR_IGUAL 			{pprintf("comparacion -> OP_MENOR_IGUAL");}
		| OP_MAYOR 					{pprintf("comparacion -> OP_MAYOR");}
		| OP_MAYOR_IGUAL			{pprintf("comparacion -> OP_MAYOR_IGUAL");}
		| OP_IGUAL 					{pprintf("comparacion -> OP_IGUAL");}
		| OP_DISTINTO				{pprintf("comparacion -> OP_DISTINTO");}

expresion_aritmetica:
        expresion_aritmetica operacion factor {
                pprintf("\t\ttermino operacion factor -> expresion_aritmetica");
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
		| CONST_FLOAT {
                pprintf("\t\t\tCTE FLOAT -> factor");
        }
        | ID{
                pprintf("\t\t\tID -> factor");
        }
        | PARENTESIS_ABRE expresion_aritmetica PARENTESIS_CIERRA {
                pprintf("\t\t\tParentesisA operacion parentesisC -> factor");
        };


%%


  
int main(int argc,char *argv[])
{
	if ((yyin = fopen(argv[1], "rt")) == NULL)
	{
		printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
	}
	else
	{
		yyparse();
		fclose(yyin);
	}
	return 0;
}

void pprintf(const char *str) {
        printf("\t %s \n", str);
}

void yyerror(const char *str)
{
        fprintf(stderr,"error: %s\n",str);
		exit(1);
}
 
int yywrap()
{
        return 1;
} 
