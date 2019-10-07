#include "stdio.h"
#include "stdlib.h"

#define FILE_NAME_TERCETOS "intermedia.txt"
#define READ_FILE_TERCETOS "r"
#define APPEND_FILE_TERCETOS "a"

struct terceto {
	char *uno;
	char *dos;
	char *tres;
};

int crearTerceto(char *, char *, char *, int);
int crearTercetoInt(int, char *, char *, int);
int crearTercetoFloat(float, char *, char *, int);
int crearTercetoOperacion(char *, int, int, int);
int crearTercetoID(char *, char *, int, int);
int avanzarTerceto(int);

int crearTerceto(char *arg1, char *arg2, char *arg3, int numeracion)
{
    FILE *fp = fopen(FILE_NAME_TERCETOS, READ_FILE_TERCETOS);
    fp = fopen(FILE_NAME_TERCETOS, APPEND_FILE_TERCETOS);
    fprintf(fp, "[%d](%s, %s, %s)\n", numeracion, arg1, arg2, arg3);
    fclose(fp);
    return numeracion;
};

int avanzarTerceto(int numeracion)
{
    return numeracion + 1;
};

int crearTercetoInt(int int1, char *str1, char *str2, int numeracion)
{
    char aux[5];
    sprintf(aux, "%d", int1);
    return crearTerceto(aux, str1, str2, numeracion);
};

int crearTercetoFloat(float flo1, char *str1, char *str2, int numeracion)
{
    char aux[10];
    snprintf(aux, 10, "%f", flo1);
    return crearTerceto(aux, str1, str2, numeracion);
};

int crearTercetoOperacion(char *op, int ind1, int ind2, int numeracion)
{
    char aux1[5];
    sprintf(aux1, "[%d]", ind1);
    char aux2[5];
    sprintf(aux2, "[%d]", ind2);
    return crearTerceto(op, aux1, aux2, numeracion);
};

int crearTercetoID(char *op, char *str1, int ind1, int numeracion)
{
    char aux1[5];
    sprintf(aux1, "[%d]", ind1);

    return crearTerceto(op, str1, aux1, numeracion);
};

int crearTercetoSalto(char *op, int ind1, char *a, int numeracion)
{
    char aux1[5];
    sprintf(aux1, "[%d]", ind1);

    return crearTerceto(op, aux1, a, numeracion);
};
