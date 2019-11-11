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
#include "cola-dinamica.h"
 
int yylex();
int yyparse();
void yyerror(const char *str);
void status();
void controlar_if_anidados(int cant);
char* getCodOp(char* salto);
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
ArrayTercetos aTercetos;

t_cola colaId;

struct ifs {
	int posicion;
	int nro_if;
};
struct ifs expr_if[1000];
int expr_if_index = 0;

struct repeat {
	int posicion;
};
struct repeat expr_repeat[1000];
int expr_repeat_index = 0;

int main()
{
        clean();
        crearTercetos(&aTercetos, 100);
        crearPila(&pilaRepeat);
        crearPila(&pilaFactor);
        crearPila(&pilaID);
        crearPila(&pilaExpresion);
        crearPila(&pilaTermino);
	crearCola(&colaId);
        yyparse();
        generarAssembler(&aTercetos);
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

        // Asignacion simple
        int Aind = -1;
        int AIind = -1;

        int LVind = -1;
        int LDind = -1;
        int Tind1 = -1;
        int Tind2 = -1;
        int ELind = -1;
        int Cind = -1;
        char* valor_comparacion;
        int TLind = -1;
        int TLSalto = -1;
	int Find1 = -1;
	int cant_if=0;
	int i=0;
	int repeat=0;
	
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
        | { cant_if++; controlar_if_anidados(cant_if); } condicional
        | io_lectura
        | io_salida;

io_lectura:
        READ ID {
                crearTerceto("READ", $2, "_", numeracionTercetos);
                numeracionTercetos = avanzarTerceto(numeracionTercetos);
        };

io_salida:
        PRINT CONST_STRING {
                crearTerceto("PRINT", $2, "_", numeracionTercetos);
                numeracionTercetos = avanzarTerceto(numeracionTercetos);
        } | PRINT ID {
                crearTerceto("PRINT", $2, "_", numeracionTercetos);
                numeracionTercetos = avanzarTerceto(numeracionTercetos);
        };

condicional:
	IF expresion_logica THEN cuerpo {
				
                Cind = crearTerceto("JI","#", "_", numeracionTercetos);
				
				Terceto tTerminoJump;
                tTerminoJump.isOperator = 1;
                tTerminoJump.isOperand = 0;
                tTerminoJump.operator = TOP_JUMP;
                tTerminoJump.left = 0; // es un operador unario
                tTerminoJump.right = 0; // es un operator unario
                tTerminoJump.operatorStringValue = malloc(strlen("JI") + 1);
                strcpy(tTerminoJump.operatorStringValue, "JI");
                tTerminoJump.tercetoID = Cind;
                insertarTercetos(&aTercetos, tTerminoJump);
                free(tTerminoJump.operatorStringValue);
				
                if(cant_if > 1){
                        for(i=0;i<expr_if_index;i++)
                        {
                                if(expr_if[i].nro_if == 2){
                                        printf("\nC [%d] por #%d\n", expr_if[i].posicion, Cind + 1);
                                        ActualizarArchivo(expr_if[i].posicion, Cind + 1);
                                        aTercetos.array[expr_if[i].posicion].left = Cind + 1;
                                }
                        }
                }
                else{
                        for(i=0;i<expr_if_index;i++)
                        {
                                if(expr_if[i].nro_if == 1){
                                        printf("\nD [%d] por #%d\n", expr_if[i].posicion, Cind + 1);
                                        ActualizarArchivo(expr_if[i].posicion, Cind + 1);
                                        aTercetos.array[expr_if[i].posicion].left = Cind + 1;
                                }
                        }
                }
                ponerEnPila(&pilaExpresion,Cind);
                numeracionTercetos = avanzarTerceto(numeracionTercetos);
        } ELSE {
                Terceto tEtiquetaElse;
                tEtiquetaElse.isOperator = 1;
                tEtiquetaElse.isOperand = 0;
                tEtiquetaElse.operator = TOP_ETIQUETA;
                tEtiquetaElse.left = numeracionTercetos;
                tEtiquetaElse.right = 0;
                tEtiquetaElse.tercetoID = numeracionTercetos;

                crearTerceto("ETIQUETA", "_", "_", numeracionTercetos);

                insertarTercetos(&aTercetos, tEtiquetaElse);
                numeracionTercetos = avanzarTerceto(numeracionTercetos);

        } cuerpo ENDIF {	
				cant_if--;
				if(cant_if == 0)
					expr_if_index = 0;
					
                int sPEelseEndIf = sacarDePila(&pilaExpresion);

                printf("\nE [%d] por #%d\n", sPEelseEndIf, numeracionTercetos);
                ActualizarArchivo(sPEelseEndIf, numeracionTercetos);
                aTercetos.array[sPEelseEndIf].left = numeracionTercetos;
        }
        | IF expresion_logica THEN cuerpo {
                // Posiblemente no haga falta este salto,
                // al menos habría que validarlo, si es un IF THEN ENDIF no es necesario
                Cind = crearTerceto("JI","#", "_", numeracionTercetos);
				Terceto tTerminoJump;
                tTerminoJump.isOperator = 1;
                tTerminoJump.isOperand = 0;
                tTerminoJump.operator = TOP_JUMP;
                tTerminoJump.left = 0; // es un operador unario
                tTerminoJump.right = 0; // es un operator unario
                tTerminoJump.operatorStringValue = malloc(strlen("JI") + 1);
                strcpy(tTerminoJump.operatorStringValue, "JI");
                tTerminoJump.tercetoID = Cind;
                insertarTercetos(&aTercetos, tTerminoJump);
                free(tTerminoJump.operatorStringValue);
				
                if(cant_if > 1){
                        for(i=0;i<expr_if_index;i++)
                        {
                                if(expr_if[i].nro_if == 2){
                                        printf("\nF [%d] por #%d\n", expr_if[i].posicion, Cind + 1);
                                        ActualizarArchivo(expr_if[i].posicion, Cind + 1);
                                        aTercetos.array[expr_if[i].posicion].left = (Cind + 1);
                                }
                        }
                }
                else{
                        for(i=0;i<expr_if_index;i++)
                        {
                                if(expr_if[i].nro_if == 1){
                                        printf("\nG [%d] por #%d\n", expr_if[i].posicion, Cind + 1);
                                        ActualizarArchivo(expr_if[i].posicion, Cind + 1);
                                        aTercetos.array[expr_if[i].posicion].left = Cind + 1;
                                }
                        }
                }
                ponerEnPila(&pilaExpresion,Cind);
                numeracionTercetos = avanzarTerceto(numeracionTercetos);
        } ENDIF {
				cant_if--;
				if(cant_if == 0)
					expr_if_index = 0;
                int sPEEndIf = sacarDePila(&pilaExpresion);

                Terceto tEtiquetaIfThenEndif;
                tEtiquetaIfThenEndif.isOperator = 1;
                tEtiquetaIfThenEndif.isOperand = 0;
                tEtiquetaIfThenEndif.operator = TOP_ETIQUETA;
                tEtiquetaIfThenEndif.left = numeracionTercetos;
                tEtiquetaIfThenEndif.right = 0;
                tEtiquetaIfThenEndif.tercetoID = numeracionTercetos;

                crearTerceto("ETIQUETA", "_", "_", numeracionTercetos);

                printf("\nH [%d] por #%d\n", sPEEndIf, Cind + 1);
                ActualizarArchivo(sPEEndIf, numeracionTercetos);
                aTercetos.array[sPEEndIf].left = numeracionTercetos;

                insertarTercetos(&aTercetos, tEtiquetaIfThenEndif);
                numeracionTercetos = avanzarTerceto(numeracionTercetos);
        };

ciclo_repeat:
        REPEAT {
                ponerEnPila(&pilaRepeat, numeracionTercetos );

                Terceto tEtiqueta;
                tEtiqueta.isOperator = 1;
                tEtiqueta.isOperand = 0;
                tEtiqueta.operator = TOP_ETIQUETA;
                tEtiqueta.left = numeracionTercetos;
                tEtiqueta.right = 0;
                tEtiqueta.tercetoID = numeracionTercetos;

                crearTerceto("ETIQUETA", "_", "_", numeracionTercetos);

                insertarTercetos(&aTercetos, tEtiqueta);
                numeracionTercetos = avanzarTerceto(numeracionTercetos);
				repeat++;
        } 
        cuerpo UNTIL expresion_logica {
	        Cind = sacarDePila(&pilaRepeat);
			for(i=0;i<expr_repeat_index;i++)
			{
				printf("\n A [%d] por #%d\n", expr_repeat[i].posicion, Cind  );
				ActualizarArchivo(expr_repeat[i].posicion, Cind );
                aTercetos.array[expr_repeat[i].posicion].left = Cind ;
			}
			
		/*while(!pilaVacia(&pilaExpresion)){
                        int sacaPilaExpresion = sacarDePila(&pilaExpresion);
                        printf("\n A [%d] por #%d\n", sacaPilaExpresion, Cind);
                        ActualizarArchivo(sacaPilaExpresion, Cind);
                        aTercetos.array[sacaPilaExpresion].left = Cind;
                }*/
			Terceto tEtiqueta;
                tEtiqueta.isOperator = 1;
                tEtiqueta.isOperand = 0;
                tEtiqueta.operator = TOP_ETIQUETA;
                tEtiqueta.left = numeracionTercetos;
                tEtiqueta.right = 0;
                tEtiqueta.tercetoID = numeracionTercetos;
			crearTerceto("ETIQUETA", "_", "_", numeracionTercetos);
			insertarTercetos(&aTercetos, tEtiqueta);
            numeracionTercetos = avanzarTerceto(numeracionTercetos);
			repeat = 0;
			expr_repeat_index=0;
        };

asignacion:
        ID {
                Terceto tIdAsignacion;
                tIdAsignacion.isOperand = 1;
                tIdAsignacion.isOperator = 0;
                tIdAsignacion.type = 'S';
                tIdAsignacion.stringValue = malloc(strlen($1)+1);
                strcpy(tIdAsignacion.stringValue, $1);

                AIind = crearTerceto($1, "_", "_", numeracionTercetos);
                tIdAsignacion.tercetoID = AIind;

                insertarTercetos(&aTercetos, tIdAsignacion);

                numeracionTercetos = avanzarTerceto(numeracionTercetos);
        } OP_ASIG expresion_algebraica {
                Terceto tOpAsignacion;
                tOpAsignacion.isOperator = 1;
                tOpAsignacion.isOperand = 0;
                tOpAsignacion.operator = TOP_ASIG;
                tOpAsignacion.left = AIind;
                tOpAsignacion.right = Eind;

                Aind = crearTercetoOperacion(":=", AIind, Eind, numeracionTercetos);
                tOpAsignacion.tercetoID = Aind;

                insertarTercetos(&aTercetos, tOpAsignacion);
                numeracionTercetos = avanzarTerceto(numeracionTercetos);
        };

asignacion_multiple:
        asignacion_multiple_declare OP_ASIG asignacion_multiple_asign;

asignacion_multiple_declare:
        CORCHETE_ABRE lista_variables CORCHETE_CIERRA;
		
lista_variables:
        lista_variables COMA ID {
                ponerEncola(&colaId,$3);
        }
        | ID { 
                ponerEncola(&colaId,$1);
        };
		
asignacion_multiple_asign: 
        CORCHETE_ABRE lista_datos CORCHETE_CIERRA;

lista_datos:
        lista_datos COMA {
                char * tokenId = sacarDecola(&colaId);

                // Creo terceto    
                Terceto tListaVariables;
                tListaVariables.isOperand = 1;
                tListaVariables.type = 'S';
                tListaVariables.stringValue = malloc(strlen(tokenId)+1);
                strcpy(tListaVariables.stringValue, tokenId);

                LVind = crearTerceto(tokenId, "_", "_", numeracionTercetos);
                tListaVariables.tercetoID = LVind;

                // Inserto en la lista de structs
                insertarTercetos(&aTercetos, tListaVariables);
                free(tListaVariables.stringValue);

                status("saca en cola");
                ponerEnPila(&pilaID, LVind); 

                // Pido la nueva numeracion
                numeracionTercetos = avanzarTerceto(numeracionTercetos);
        } expresion_algebraica  {
                LDind = Eind;

                int id = sacarDePila(&pilaID);
                
                // Creo terceto    
                Terceto tAsig;
                tAsig.isOperator = 1;
                tAsig.isOperand = 0;
                tAsig.operator = TOP_ASIG;
                tAsig.left = id;
                tAsig.right = LDind;


                // Asigno numeracion del esquema anterior
		Aind = crearTercetoOperacion(":=", id,LDind, numeracionTercetos);
                tAsig.tercetoID = Aind;

                // Inserto en la lista de structs
                insertarTercetos(&aTercetos, tAsig);

                // Pido la numeracion
                numeracionTercetos = avanzarTerceto(numeracionTercetos);
        }
        | {
                char * tokenId = sacarDecola(&colaId);

                // Creo terceto    
                Terceto tIdLista;
                tIdLista.isOperand = 1;
                tIdLista.type = 'S';
                tIdLista.stringValue = malloc(strlen(tokenId)+1);
                strcpy(tIdLista.stringValue, tokenId);

                LVind = crearTerceto(tokenId, "_", "_", numeracionTercetos);
                tIdLista.tercetoID = LVind;

                // Inserto en la lista de structs
                insertarTercetos(&aTercetos, tIdLista);
                free(tIdLista.stringValue);

                status("saca en cola");
                ponerEnPila(&pilaID, LVind);

                // Pido la nueva numeracion 
                numeracionTercetos = avanzarTerceto(numeracionTercetos);
        } expresion_algebraica {
                LDind = Eind;

                int id = sacarDePila(&pilaID);

                // Creo terceto    
                Terceto tAsigU;
                tAsigU.isOperator = 1;
                tAsigU.operator = TOP_ASIG;
                tAsigU.left = id;
                tAsigU.right = LDind;

                // Asigno numeracion del esquema anterior
	        Aind = crearTercetoOperacion(":=", id, LDind, numeracionTercetos);
                tAsigU.tercetoID = Aind;

                // Inserto en la lista de structs
                insertarTercetos(&aTercetos, tAsigU);

                // Pido la nueva numeracion
                numeracionTercetos = avanzarTerceto(numeracionTercetos);
        };
		
expresion_logica:
        termino_logico {
                Terceto tTerminoLogicoAnd;
                tTerminoLogicoAnd.isOperator = 1;
                tTerminoLogicoAnd.isOperand = 0;
                tTerminoLogicoAnd.operator = TOP_JUMP;
                tTerminoLogicoAnd.left = 0; // es un operador unario
                tTerminoLogicoAnd.right = 0; // es un operator unario
                tTerminoLogicoAnd.operatorStringValue = malloc(strlen(valor_comparacion) + 1);
                strcpy(tTerminoLogicoAnd.operatorStringValue, valor_comparacion);

                ELind = crearTerceto(valor_comparacion,"#", "_", numeracionTercetos);
                tTerminoLogicoAnd.tercetoID = ELind;


                insertarTercetos(&aTercetos, tTerminoLogicoAnd);
                free(tTerminoLogicoAnd.operatorStringValue);

				if(cant_if > 0)
				{
					expr_if[expr_if_index].posicion = ELind;
					expr_if[expr_if_index].nro_if = cant_if;
					expr_if_index++;
				}
				if(repeat > 0)
				{
					expr_repeat[expr_repeat_index].posicion = ELind;
					expr_repeat_index++;
				}
                ponerEnPila(&pilaExpresion,ELind);

                free(valor_comparacion);
                numeracionTercetos = avanzarTerceto(numeracionTercetos);
	} AND termino_logico {
                Terceto tAndTerminoLogico;
                tAndTerminoLogico.isOperator = 1;
                tAndTerminoLogico.isOperand = 0;
                tAndTerminoLogico.operator = TOP_JUMP;
                tAndTerminoLogico.left = 0; // es un operador unario
                tAndTerminoLogico.right = 0; // es un operator unario
                tAndTerminoLogico.operatorStringValue = malloc(strlen(valor_comparacion) + 1);
                strcpy(tAndTerminoLogico.operatorStringValue, valor_comparacion);

                ELind = crearTerceto(valor_comparacion,"#", "_", numeracionTercetos);
                tAndTerminoLogico.tercetoID = ELind;

                insertarTercetos(&aTercetos, tAndTerminoLogico);
                free(tAndTerminoLogico.operatorStringValue);

				if(cant_if > 0)
				{
					expr_if[expr_if_index].posicion = ELind;
					expr_if[expr_if_index].nro_if = cant_if;
					expr_if_index++;
				}
				if(repeat > 0)
				{
					expr_repeat[expr_repeat_index].posicion = ELind;
					expr_repeat_index++;
				}
				
                ponerEnPila(&pilaExpresion,ELind);

                free(valor_comparacion);
                numeracionTercetos = avanzarTerceto(numeracionTercetos);
        }
        | termino_logico {                
                Terceto tTerminoLogicoOr;
                tTerminoLogicoOr.isOperator = 1;
                tTerminoLogicoOr.isOperand = 0;
                tTerminoLogicoOr.operator = TOP_JUMP;
                tTerminoLogicoOr.left = 0; // es un operador unario
                tTerminoLogicoOr.right = 0; // es un operator unario
                tTerminoLogicoOr.operatorStringValue = malloc(strlen(getCodOp(valor_comparacion)) + 1);
                strcpy(tTerminoLogicoOr.operatorStringValue, getCodOp(valor_comparacion));
				
				ELind = crearTerceto(getCodOp(valor_comparacion),"#", "_", numeracionTercetos);
                tTerminoLogicoOr.tercetoID = ELind;
                insertarTercetos(&aTercetos, tTerminoLogicoOr);
                free(tTerminoLogicoOr.operatorStringValue);
				
                //expr_if[expr_if_index].posicion = ELind;
				//expr_if[expr_if_index].nro_if = cant_if;
				//expr_if_index++;
				ponerEnPila(&pilaExpresion, ELind);

                free(valor_comparacion);
                numeracionTercetos = avanzarTerceto(numeracionTercetos);
				
        } OR termino_logico {
                Terceto tOrTerminoLogico;
                tOrTerminoLogico.isOperator = 1;
                tOrTerminoLogico.isOperand = 0;
                tOrTerminoLogico.operator = TOP_JUMP;
                tOrTerminoLogico.left = 0; // es un operador unario
                tOrTerminoLogico.right = 0; // es un operator unario
                tOrTerminoLogico.operatorStringValue = malloc(strlen(valor_comparacion) + 1);
                strcpy(tOrTerminoLogico.operatorStringValue, valor_comparacion);

                ELind = crearTerceto(valor_comparacion,"#", "_", numeracionTercetos);
                tOrTerminoLogico.tercetoID = ELind;

				int sPEtOrTerminoLogico = sacarDePila(&pilaExpresion);
                printf("\nB [%d] por #%d\n", sPEtOrTerminoLogico, ELind + 1);
				ActualizarArchivo(sPEtOrTerminoLogico, ELind + 1 );
                aTercetos.array[sPEtOrTerminoLogico].left = (ELind + 1);
				
                insertarTercetos(&aTercetos, tOrTerminoLogico);
                free(tOrTerminoLogico.operatorStringValue );
				if(cant_if > 0)
				{
					expr_if[expr_if_index].posicion = ELind;
					expr_if[expr_if_index].nro_if = cant_if;
					expr_if_index++;
				}
				if(repeat > 0)
				{
					expr_repeat[expr_repeat_index].posicion = ELind;
					expr_repeat_index++;
				}
                
				
				//ponerEnPila(&pilaExpresion, ELind);

                free(valor_comparacion);
                numeracionTercetos = avanzarTerceto(numeracionTercetos);
        }
        | NOT termino_logico_not {
                Terceto tNotTerminoLogico;
                tNotTerminoLogico.isOperator = 1;
                tNotTerminoLogico.isOperand = 0;
                tNotTerminoLogico.operator = TOP_JUMP;
                tNotTerminoLogico.left = 0; // es un operador unario
                tNotTerminoLogico.right = 0; // es un operator unario
                tNotTerminoLogico.operatorStringValue = malloc(strlen(valor_comparacion) + 1);
                strcpy(tNotTerminoLogico.operatorStringValue, valor_comparacion);

                ELind = crearTerceto(valor_comparacion,"#", "_", numeracionTercetos);
                tNotTerminoLogico.tercetoID = ELind;

                insertarTercetos(&aTercetos, tNotTerminoLogico);
                free(tNotTerminoLogico.operatorStringValue);

				if(cant_if > 0)
				{
					expr_if[expr_if_index].posicion = ELind;
					expr_if[expr_if_index].nro_if = cant_if;
					expr_if_index++;
				}
				
				if(repeat > 0)
				{
					expr_repeat[expr_repeat_index].posicion = ELind;
					expr_repeat_index++;
				}
                ponerEnPila(&pilaExpresion,ELind);

                free(valor_comparacion);
                numeracionTercetos = avanzarTerceto(numeracionTercetos);
        }
        | termino_logico {
                Terceto tTerminoLogico;
                tTerminoLogico.isOperator = 1;
                tTerminoLogico.isOperand = 0;
                tTerminoLogico.operator = TOP_JUMP;
                tTerminoLogico.left = 0; // es un operador unario
                tTerminoLogico.right = 0; // es un operator unario
                tTerminoLogico.operatorStringValue = malloc(strlen(valor_comparacion) + 1);
                strcpy(tTerminoLogico.operatorStringValue, valor_comparacion);


                ELind = crearTerceto(valor_comparacion,"#", "_", numeracionTercetos);
                tTerminoLogico.tercetoID = ELind;

                insertarTercetos(&aTercetos, tTerminoLogico);
                free(tTerminoLogico.operatorStringValue);

				if(cant_if > 0)
				{
					expr_if[expr_if_index].posicion = ELind;
					expr_if[expr_if_index].nro_if = cant_if;
					expr_if_index++;
				}
				if(repeat > 0)
				{
					expr_repeat[expr_repeat_index].posicion = ELind;
					expr_repeat_index++;
				}
                ponerEnPila(&pilaExpresion,ELind);
				
                // libero el valor comparacion y avanzo en los tercetos
                free(valor_comparacion);
                numeracionTercetos = avanzarTerceto(numeracionTercetos);
        };
		
termino_logico_not: 
        expresion_algebraica {Tind1 = Eind;} comparacion_jump expresion_algebraica {Tind2 = Eind;} {
                Terceto tCmp;
                tCmp.isOperator = 1;
                tCmp.isOperand = 0;
                tCmp.operator = TOP_CMP;
                tCmp.left = Tind1;
                tCmp.right = Tind2;

                Tind = crearTercetoOperacion("CMP", Tind1, Tind2, numeracionTercetos);
                tCmp.tercetoID = Tind;

                insertarTercetos(&aTercetos, tCmp);

                numeracionTercetos = avanzarTerceto(numeracionTercetos);
        };
		
termino_logico: 
        expresion_algebraica { 
                Tind1 = Eind; 
        } 
        comparacion expresion_algebraica { 
                Tind2 = Eind;

                Terceto tCmp;
                tCmp.isOperator = 1;
                tCmp.isOperand = 0;
                tCmp.operator = TOP_CMP;
                tCmp.left = Tind1;
                tCmp.right = Tind2;

                Tind = crearTercetoOperacion("CMP", Tind1, Tind2, numeracionTercetos);
                tCmp.tercetoID = Tind;

                insertarTercetos(&aTercetos, tCmp);

                numeracionTercetos = avanzarTerceto(numeracionTercetos);
        };

comparacion:
        OP_MENOR {
                valor_comparacion = malloc(strlen("JAE") + 1);
	        strcpy(valor_comparacion, "JAE");
        }
        | OP_MENOR_IGUAL {
                valor_comparacion = malloc(strlen("JA") + 1);
	        strcpy(valor_comparacion, "JA");
        }
	| OP_MAYOR {
                valor_comparacion = malloc(strlen("JBE") + 1);
	        strcpy(valor_comparacion, "JBE");
        }
	| OP_MAYOR_IGUAL {
                valor_comparacion = malloc(strlen("JB") + 1);
	        strcpy(valor_comparacion, "JB");
        }
	| OP_IGUAL {
                valor_comparacion = malloc(strlen("JNE") + 1);
	        strcpy(valor_comparacion, "JNE");
        }
	| OP_DISTINTO {
                valor_comparacion = malloc(strlen("JE") + 1);
	        strcpy(valor_comparacion, "JE");
        };

comparacion_jump:
        OP_MENOR {
                valor_comparacion = malloc(strlen("JB") + 1);
	        strcpy(valor_comparacion, "JB");
        }
        | OP_MENOR_IGUAL {
                valor_comparacion = malloc(strlen("JBE") + 1);
	        strcpy(valor_comparacion, "JBE");
        }
	| OP_MAYOR {
                valor_comparacion = malloc(strlen("JA") + 1);
	        strcpy(valor_comparacion, "JA");
        }
	| OP_MAYOR_IGUAL {
                valor_comparacion = malloc(strlen("JAE") + 1);
	        strcpy(valor_comparacion, "JAE");
        }
	| OP_IGUAL {
                valor_comparacion = malloc(strlen("JE") + 1);
	        strcpy(valor_comparacion, "JE");
        }
	| OP_DISTINTO {
                valor_comparacion = malloc(strlen("JNE") + 1);
	        strcpy(valor_comparacion, "JNE");
        };

expresion_algebraica: expresion;

expresion:
        expresion OP_SUMA termino {
                // Creo terceto    
                Terceto tSuma;
                tSuma.isOperator = 1;
                tSuma.isOperand = 0;
                tSuma.operator = TOP_SUM;
                tSuma.left = Eind;
                tSuma.right = Tind;

                // Asigno numeracion del esquema anterior
                Eind = crearTercetoOperacion("+", Eind, Tind, numeracionTercetos);
                tSuma.tercetoID = Eind;

                // Inserto en la lista de structs
                insertarTercetos(&aTercetos, tSuma);

                // pido la nueva numeracion
                numeracionTercetos = avanzarTerceto(numeracionTercetos);
                status("expresion suma termino a expresion");
        }
        | expresion OP_RESTA termino {      
                // Creo terceto    
                Terceto tResta;
                tResta.isOperator = 1;
                tResta.isOperand = 0;
                tResta.operator = TOP_RES;
                tResta.left = Eind;
                tResta.right = Tind;

                // Asigno numeracion del esquema anterior
                Eind = crearTercetoOperacion("-", Eind, Tind, numeracionTercetos);
                tResta.tercetoID = Eind;

                // Inserto en la lista de structs
                insertarTercetos(&aTercetos, tResta);

                // pido la nueva numeracion
                numeracionTercetos = avanzarTerceto(numeracionTercetos);
                status("expresion resta termino a expresion");
        }
        | termino {
                Eind = Tind;
                status("termino a exp");
        };
		
termino:
        termino OP_MULTIPLICACION factor {
                // Creo terceto    
                Terceto tOperadorMulti;
                tOperadorMulti.isOperator = 1;
				tOperadorMulti.isOperand = 0;
                tOperadorMulti.operator = TOP_MUL;
                tOperadorMulti.left = Tind;
                tOperadorMulti.right = Find;
                // Asigno numeracion del esquema anterior
                Tind = crearTercetoOperacion("*", Tind, Find, numeracionTercetos);
                tOperadorMulti.tercetoID = Tind;

                // Inserto en la lista de structs
                insertarTercetos(&aTercetos, tOperadorMulti);

                // pido la nueva numeracion
                numeracionTercetos = avanzarTerceto(numeracionTercetos);
                status("multiplicar a termino");
        }
        | termino OP_DIVISION factor {
                // Creo terceto    
                Terceto tOperadorDiv;
                tOperadorDiv.isOperator = 1;
				tOperadorDiv.isOperand = 0;
                tOperadorDiv.operator = TOP_DIV;
                tOperadorDiv.left = Tind;
                tOperadorDiv.right = Find;

                // Asigno numeracion del esquema anterior
                Tind = crearTercetoOperacion("/", Tind, Find, numeracionTercetos);
                tOperadorDiv.tercetoID = Tind;

                // Inserto en la lista de structs
                insertarTercetos(&aTercetos, tOperadorDiv);

                // pido la nueva numeracion
                numeracionTercetos = avanzarTerceto(numeracionTercetos);
                status("dividir a termino");
        }
        | factor {
                Tind = Find;                
                status("factor a termino");
        };

factor:
        CONST_INT {
                Terceto tConstInt;
                tConstInt.intValue = $1;
                tConstInt.type = 'I';
                tConstInt.isOperand = 1;

                Find = crearTercetoInt($1, "_", "_", numeracionTercetos);
                tConstInt.tercetoID = Find;

                // Inserto en la lista
                insertarTercetos(&aTercetos, tConstInt);

                // Pido la nueva numeracion
                numeracionTercetos = avanzarTerceto(numeracionTercetos);
                status("int a factor");
        }
        | CONST_FLOAT {
                Terceto tConstFloat;
                tConstFloat.floatValue = $1;
                tConstFloat.type = 'F';
                tConstFloat.isOperand = 1;

                Find = crearTercetoFloat($1, "_", "_", numeracionTercetos);
                tConstFloat.tercetoID = Find;
                
                insertarTercetos(&aTercetos, tConstFloat);

                numeracionTercetos = avanzarTerceto(numeracionTercetos);
                status("float a factor");
        }
        | ID {
                // POC - Tercetos
                Terceto tId;
                tId.stringValue = malloc(strlen($1)+1);
                strcpy(tId.stringValue, $1);
                tId.type = 'S';
                tId.isOperand = 1;


                Find = crearTerceto($1, "_", "_", numeracionTercetos);
                ponerEnPila(&pilaFactor, Find);
                tId.tercetoID = Find;

                insertarTercetos(&aTercetos, tId);
                free(tId.stringValue);
                // fin POC

                numeracionTercetos = avanzarTerceto(numeracionTercetos);
                status("id a factor");
        }
        | PARENTESIS_ABRE expresion PARENTESIS_CIERRA {
                Find = Eind;
                status("pa expresion pc a factor");
        }
        | PARENTESIS_ABRE expresion {Find1=Eind;} MOD expresion PARENTESIS_CIERRA {
                Terceto tMod;
                tMod.isOperator = 1;
                tMod.isOperand = 0;
                tMod.operator = TOP_MOD;
                tMod.left = Find1;
                tMod.right = Find;

                Find = crearTercetoOperacion("OP_MOD", Find1, Find, numeracionTercetos);
                tMod.tercetoID = Find;

                // Insertar en array
                insertarTercetos(&aTercetos, tMod);

                // Avanzo la numeración
                numeracionTercetos = avanzarTerceto(numeracionTercetos);
                status("MOD a Factor");
        }
        | PARENTESIS_ABRE  expresion {Find1=Eind;} DIV expresion PARENTESIS_CIERRA {
                Terceto tDiv;
                tDiv.isOperator = 1;
                tDiv.isOperand = 0;
                tDiv.operator = TOP_DIV_ENTERA;
                tDiv.left = Find1;
                tDiv.right = Find;

                Find = crearTercetoOperacion("OP_DIV", Find1, Find, numeracionTercetos);
                tDiv.tercetoID = Find;

                // Insertar en array
                insertarTercetos(&aTercetos, tDiv);

                // Avanzo la numeración
                numeracionTercetos = avanzarTerceto(numeracionTercetos);
                status("DIV a Factor");
        };

%%

void status(char *str)
{
        crearStatus(str, Eind, Tind, Find, numeracionTercetos);
}

void controlar_if_anidados(int cant){
	status("Ingresa a controlar");
	if(cant >=3){
		clean();
		yyerror("No se puede tener mas de 2 ifs anidados\n");
		exit(2);
	}
}

char* getCodOp(char* salto)
{
	if(!strcmp(salto, "JAE"))
	{
		return "JB";
	}
	else if(!strcmp(salto, "JA"))
	{
		return "JBE";
	}
	else if(!strcmp(salto, "JBE"))
	{
		return "JA";
	}
	else if(!strcmp(salto, "JB"))
	{
		return "JAE";
	}
	else if(!strcmp(salto, "JNE"))
	{
		return "JE";
	}
	else if(!strcmp(salto, "JE"))
	{
		return "JNE";
	}
        printf("salto no encontrado");
        return "ERROR";
}

void mostrarTercetos(ArrayTercetos * a){
	int j;
	for(j=0;j<(int)a->tamanioUsado; j++){
		printf("*******************************%d\n",j);
		
		printf("ISOPERATOR: %d\n", a->array[j].isOperator);
		printf("VALOR: %d\n", a->array[j].left);
				

		
	}
}