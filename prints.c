#include "prints.h"

void pprints(char *text)
{
    printf("\033[0;32m");
    printf("\n[%s]\n", text);
    printf("\033[0m");
};