%{

/* include area */
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "y.tab.h"
#include "valid.type.h"
#include "ts.h"

void cota_error(char* mensaje);

%}

%option noyywrap
%option yylineno

DIGITO					[0-9]
LETRA					[a-zA-Z]
ID						[({LETRA}|{DIGITO}|_)*]

CONSTANTE_REAL			{DIGITO}+"."{DIGITO}*|{DIGITO}*"."{DIGITO}+
CONSTANTE_ENTERA		{DIGITO}+

CARACTERES_ESPECIALES	[\@\%\#\$\&\_\~\(\)\[\]\^]
OPERADORES				[\/\*\-\+\=]
PUNTUACION				[\.\;\,\:]
SIGNOS					[?\¿\!\¡]
ESPACIO					[" "]
NUEVA_SENTENCIA			[\r\n]
TABULACION 				[\t]

INICIO_FIN_STRING		[\"]
CADENA					[({DIGITO}|{LETRA}|{CARACTERES_ESPECIALES}|{OPERADORES}|{PUNTUACION}|{SIGNOS}|{NUEVA_SENTENCIA}|{TABULACION})*]
CONST_STRING			[{INICIO_FIN_STRING}{CADENA}{INICIO_FIN_STRING}]

INICIO_COMENTARIO		["--/"]
FIN_COMENTARIO			["/--"]
COMENTARIO				[{INICIO_COMENTARIO}{CADENA}*{FIN_COMENTARIO}]

%%

"REPEAT"	{return REPEAT; }
"UNTIL"		{return UNTIL; }
"IF"		{return IF; }
"ELSE"		{return ELSE; }
"THEN"		{return THEN; }
"ENDIF"		{return ENDIF; }
":="		{return OP_ASIG; }
"PRINT"		{return PRINT; }
"READ"		{return READ; }
"<"			{return OP_MENOR; }
"<="		{return OP_MENOR_IGUAL; }
">"			{return OP_MAYOR; }
">="		{return OP_MAYOR_IGUAL; }
"=="		{return OP_IGUAL; }
"!="		{return OP_DISTINTO; }
"-"			{return OP_RESTA; }
"/"			{return OP_DIVISION; }
"*"			{return OP_MULTIPLICACION; }
"+" 		{return OP_SUMA; }
";"			{return PYC; }
","         { return COMA; }
"AND"		{return AND; }
"OR"		{return OR; }
"NOT"		{return NOT; }
"VAR"		{return VAR; }
"ENDVAR"	{return ENDVAR; }
"["			{return CORCHETE_ABRE; }
"]"			{return CORCHETE_CIERRA; }
"("			{return PARENTESIS_ABRE; }
")"			{return PARENTESIS_CIERRA; }
":"			{return DOS_PUNTOS; }
"INTEGER"                     { 
                            yylval.valor_int = atoi( yytext );
                            return TIPO_INTEGER;
                          }

"FLOAT"                   { 
                            yylval.valor_float = atof( yytext );
                            return TIPO_FLOAT;
                          }

"STRING"                  { 
                            yylval.valor_string = strdup( yytext );
                            return TIPO_STRING;
                          }

{ID}          			  {
			                if(strlen(yytext) <= 30){
			                  yylval.valor_string = strdup(yytext);
			                  return ID;
			                }
							cota_error("El nombre de variable excede el limite permitido.");
			              }               
{CONSTANTE_REAL}  		  {
		                    if(atof(yytext)>=-3.40282347e+38F && atof(yytext)<=3.40282347e+38F){
		                    	yylval.valor_float = atof(yytext);
		                    	return CONST_FLOAT;
		                    }
							cota_error("El valor de un flotante excede el limite permitido.");
		                  } 
{CONSTANTE_ENTERA}        {
		                      if(atoll(yytext)>=-32768 && atoll(yytext)<=32767){
		                      	yylval.valor_int = atoi(yytext);
		                      	return CONST_INT;
		                      }
							  cota_error("El valor de un entero excede el limite permitido.");
		                  } 

{CONST_STRING}		  {	
							if(strlen(yytext)<=30){
							strcpy(yylval.valor_string,yytext);
							return CONST_STRING;
							}
							cota_error("El contenido de una cadena excede el limite permitido.");
						  }
{COMENTARIO}              { printf("\t comentario \n\n"); };
\n                                      /* ignore end of line */;
[ \t]+                                  /* ignore whitespace */;

%%

void cota_error(char* mensaje)
{
	printf("Error lexico: %s\n", mensaje);
	system ("Pause");
	exit (1);
}