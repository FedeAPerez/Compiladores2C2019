%{
#include <stdio.h>
#include "y.tab.h"
#include "valid.type.h"
#include "ts.h"
%}
%%
"VAR"                                   return VAR;
"ENDVAR"                                return ENDVAR;
"REPEAT"                                return REPEAT;
"IF"                                    return IF;
":="                                    return OP_ASIG;
"*"                                     return OP_MULTIPLICACION;
"+"                                     return OP_SUMA;
"/"                                     return OP_DIVISION;
"-"                                     return OP_RESTA;
"("                                     return PARENTESIS_ABRE;
")"                                     return PARENTESIS_CIERRA;
"["                                     return CORCHETE_ABRE;
"]"                                     return CORCHETE_CIERRA;
","                                     return COMA;
":"                                     return DOS_PUNTOS;
"INTEGER"                               return TIPO_INTEGER;
"FLOAT"                                 return TIPO_FLOAT;
[0-9]+                                  { yylval.intValue = atoi(yytext); return CONST_INT; }
[0-9]+"."[0-9]+                         { yylval.floatValue = atof(yytext); return CONST_FLOAT; }
[a-zA-Z][a-zA-Z0-9_]*                   { yylval.stringValue = yytext; return ID; }
\"[(a-zA-Z0-9_ )]*\"                    { validType(yytext, TYPE_STRING, saveTs); yylval.stringValue = yytext; return CONST_STRING; }
\-\-\/[a-zA-Z0-9_ ]*\/\-\-              { printf("\t comentario \n\n"); };
\n                                      /* ignore end of line */;
[ \t]+                                  /* ignore whitespace */;
%%