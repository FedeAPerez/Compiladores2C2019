/*
 * VALID.TYPE
 * 
 * Validación de tipos de dato
 * Mensaje unificado de errores léxicos
 */

#include "stdio.h"
#include "string.h"
#include "stdlib.h"
#include "float.h"
#include "ts.h"

#define ERR_STRING_LENGTH "Cadena de caracteres mayor a 30"
#define ERR_INT_MAX "Entero fuera de rango de los 16 bits (sin signo)"
#define ERR_FLT_MAX "Float fuera de rango de los 32 bits"
#define TYPE_ID 1
#define TYPE_FLOAT 2
#define TYPE_STRING 3
#define TYPE_INT 4

void printError(char *errorMessage, char *errorLex)
{
    printf("\033[0;31m");
    printf("\t[LEXICAL ERROR] - %s: %s\n", errorMessage, errorLex);
    printf("\033[0m");
}

int validType(char *text, int type)
{
    int length;
    char stringLength[20];
    switch (type)
    {
    case TYPE_ID:
        insertInTs(text, "", "", "");
        return 1;
        break;
    case TYPE_STRING:
        /* @TODO mejor forma de quitar comilla de inicio y fin? */
        length = strlen(text) - 2;
        if (length > 30)
        {
            printError(ERR_STRING_LENGTH, text);
            exit(0);
        }
        else
        {
            // converts length into string
            sprintf(stringLength, "%d", length);
            insertInTs(text, "CONST_STRING", text, stringLength);
            return 1;
        }
        break;
    case TYPE_INT:
        if (atoi(text) > 65535)
        {
            printError(ERR_INT_MAX, text);
            exit(0);
        }
        else
        {
            insertInTs(text, "CONST_INT", text, "");
        }
        break;
    case TYPE_FLOAT:
        if (atof(text) > FLT_MAX)
        {
            printError(ERR_FLT_MAX, text);
            exit(0);
        }
        else
        {
            insertInTs(text, "CONST_FLOAT", text, "");
        }
        return 1;
        break;
    default:
        return 1;
        break;
    }
    return 1;
}