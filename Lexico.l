%{
#include <stdio.h>
#include "y.tab.h"

%}
%%
VAR                                     return VAR;
ENDVAR                                  return ENDVAR;                        
\n                                      /* ignore end of line */;
[ \t]+                                  /* ignore whitespace */;
%%