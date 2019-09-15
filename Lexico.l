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
CARACTERES_ESPECIALES	[\@\%\#\$\&\_\~\(\)\[\]\^]
%%
"VAR"                                   return VAR;
"ENDVAR"                                return ENDVAR;
"REPEAT"                                return REPEAT;
"UNTIL"                                 return UNTIL;
"IF"                                    return IF;
"THEN"                                  return THEN;
"ELSE"                                  return ELSE;
"ENDIF"                                 return ENDIF;
"MOD"                                   return MOD;
"DIV"                                   return DIV;
"AND"                                   return AND;
"OR"                                    return OR;
"NOT"                                   return NOT;
"PRINT"                                 return PRINT;
"READ"                                  return READ;
":="                                    return OP_ASIG;
"*"                                     return OP_MULTIPLICACION;
"+"                                     return OP_SUMA;
"/"                                     return OP_DIVISION;
"-"                                     return OP_RESTA;
"<"			                                return OP_MENOR;
"<="		                                return OP_MENOR_IGUAL;
">"			                                return OP_MAYOR;
">="		                                return OP_MAYOR_IGUAL;
"=="		                                return OP_IGUAL;
"!="		                                return OP_DISTINTO;
"("                                     return PARENTESIS_ABRE;
")"                                     return PARENTESIS_CIERRA;
"["                                     return CORCHETE_ABRE;
"]"                                     return CORCHETE_CIERRA;
","                                     return COMA;
":"                                     return DOS_PUNTOS;
"INTEGER"                               return TIPO_INTEGER;
"FLOAT"                                 return TIPO_FLOAT;
[0-9]+                                  { validType(yytext, TYPE_INT, saveTs); yylval.intValue = atoi(yytext); return CONST_INT; }
[0-9]+"."[0-9]+                         { validType(yytext, TYPE_FLOAT, saveTs); yylval.floatValue = atof(yytext); return CONST_FLOAT; }
[a-zA-Z][a-zA-Z0-9_]*                   { validType(yytext, TYPE_ID, saveTs); yylval.stringValue = yytext; return ID; }
\"(\\.|[^"\\])*\"                       { validType(yytext, TYPE_STRING, saveTs); yylval.stringValue = yytext; return CONST_STRING; }
\-\-\/[a-zA-Z0-9_ ]*\/\-\-              { printf("\t comentario \n\n"); };
\n                                      /* ignore end of line */;
[ \t]+                                  /* ignore whitespace */;
\n|.       		                          { printError("Caracter inesperado", yytext); exit(0); } // hanlde unmatched chars
%%
