%{
#include <stdio.h>
#include "y.tab.h"

%}
%%
VAR                                     return VAR;
ENDVAR                                  return ENDVAR;
REPEAT                                  return REPEAT;
IF                                      return IF;
":="                                    return OP_ASIG;
"*"                                     return OP_MULTIPLICACION;
[0-9]*                                  { yylval.intValue = atoi(yytext); return CONST_INT; }
[a-zA-Z][a-zA-Z0-9_]*                   { yylval.stringValue = yytext; return ID; }
\"[(a-zA-Z0-9_ )]*\"                    { yylval.stringValue = yytext; return CONST_STRING; }
\-\-\/[a-zA-Z0-9_ ]*\/\-\-               { printf("\t comentario \n\n"); };
\n                                      /* ignore end of line */;
[ \t]+                                  /* ignore whitespace */;
%%