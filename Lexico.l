%{
#include <stdio.h>
#include "valid.type.h"

%}
%%
     
[a-zA-Z][a-zA-Z0-9_]*                   return ID;
[0-9]*                                  return INTEGER_CONST;
\"[a-zA-Z0-9_ ]*\"                      return STRING_CONST;
[0-9]*"."[0-9]*                         return REAL_CONST;                          
\n                                      /* ignore end of line */;
[ \t]+                                  /* ignore whitespace */;
%%