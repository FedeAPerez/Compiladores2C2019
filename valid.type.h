/*
 * VALID.TYPE
 * 
 * Validación de tipos de dato
 * Mensaje unificado de errores léxicos
 */

#include "stdio.h"
#include "string.h"

#define ERR_STRING_LENGTH "Cadena de caracteres mayor a 30"

const int TYPE_ID = 1;
const int TYPE_FLOAT = 2;
const int TYPE_STRING = 3;
const int TYPE_INT = 4;

void printError(char *errorMessage, char *errorLex)
{

    printf("\033[0;31m");
    printf("[LEXICAL ERROR] - %s: %s\n", errorMessage, errorLex);
    printf("\033[0m");
}

int validType(char *text, int type, void (*next)(char *, char *, char *, char *))
{
    int length;
    char stringLength[20];
    switch (type)
    {
    case TYPE_ID:
        next(text, "", "", "");
        return 1;
        break;
    case TYPE_STRING:
        /* @TODO mejor forma de quitar comilla de inicio y fin? */
        length = strlen(text) - 2;
        if (length > 30)
        {
            printError(ERR_STRING_LENGTH, text);
            return 0;
        }
        else
        {
            sprintf(stringLength, "%d", length);
            next(text, "CONST_STRING", text, stringLength);
            return 1;
        }
        break;
    default:
        return 1;
        break;
    }
}