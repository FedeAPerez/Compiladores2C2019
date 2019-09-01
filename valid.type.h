/*
 * VALID.TYPE
 * 
 * Validación de tipos de dato
 * Mensaje unificado de errores léxicos
 */

#include "stdio.h"
#include "string.h"

const int TYPE_ID = 1;
const int TYPE_REAL = 2;
const int TYPE_STRING = 3;
const int TYPE_INT = 4;

void printError(char *errorMessage, char *errorLex)
{

    printf("\033[0;31m");
    printf("[LEXICAL ERROR] - %s: %s\n", errorMessage, errorLex);
    printf("\033[0m");
}