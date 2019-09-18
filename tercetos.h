#include "stdio.h"

#define FILE_NAME_TERCETOS "tercetos.txt"
#define READ_FILE_TERCETOS "r"
#define APPEND_FILE_TERCETOS "a"

void initTercetos(FILE *);
int crearTerceto(char *, char *, char *);
int crearTercetoInt(int, char *, char *);

int crearTerceto(char *arg1, char *arg2, char *arg3)
{
    FILE *fp = fopen(FILE_NAME_TERCETOS, READ_FILE_TERCETOS);
    int tercetoNumerado = 1;
    fp = fopen(FILE_NAME_TERCETOS, APPEND_FILE_TERCETOS);
    fprintf(fp, "[%d](%s, %s, %s)\n", tercetoNumerado, arg1, arg2, arg3);
    fclose(fp);
    return tercetoNumerado;
};

int crearTercetoInt(int int1, char *str1, char *str2)
{
    char *aux;
    snprintf(aux, 10, "%d", int1);
    return crearTerceto(aux, str1, str2);
};
