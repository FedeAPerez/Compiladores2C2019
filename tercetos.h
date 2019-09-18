#include "stdio.h"
#include "stdlib.h"

#define FILE_NAME_TERCETOS "tercetos.txt"
#define READ_FILE_TERCETOS "r"
#define APPEND_FILE_TERCETOS "a"

void initTercetos(FILE *);
int crearTerceto(char *, char *, char *, int);
int crearTercetoInt(int, char *, char *, int);

int crearTerceto(char *arg1, char *arg2, char *arg3, int nuevaNumeracion)
{
    FILE *fp = fopen(FILE_NAME_TERCETOS, READ_FILE_TERCETOS);
    fp = fopen(FILE_NAME_TERCETOS, APPEND_FILE_TERCETOS);
    fprintf(fp, "[%d](%s, %s, %s)\n", nuevaNumeracion, arg1, arg2, arg3);
    fclose(fp);
    return nuevaNumeracion + 1;
};

int crearTercetoInt(int int1, char *str1, char *str2, int nuevaNumeracion)
{
    char aux[5];
    sprintf(aux, "%d", int1);
    return crearTerceto(aux, str1, str2, nuevaNumeracion);
};

int crearTercetoFloat(float flo1, char *str1, char *str2, int nuevaNumeracion)
{
    char aux[50];
    snprintf(aux, 50, "%f", flo1);
    return crearTerceto(aux, str1, str2, nuevaNumeracion);
};