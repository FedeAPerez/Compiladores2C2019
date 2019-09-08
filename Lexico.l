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
\n                                      /* ignore end of line */;
[ \t]+                                  /* ignore whitespace */;
%%