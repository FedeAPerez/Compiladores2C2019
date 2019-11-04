#include "stdio.h"
#include "stdlib.h"

#define FILE_NAME_STATUS "status.txt"
#define READ_FILE_STATUS "r"
#define APPEND_FILE_STATUS "a"

void crearStatus(char *str, int eind, int tind, int find, int num)
{
    FILE *fp = fopen(FILE_NAME_STATUS, READ_FILE_STATUS);
    fp = fopen(FILE_NAME_STATUS, APPEND_FILE_STATUS);
    fprintf(fp, "Operación: %s (Eind: %d, Tind: %d, Find: %d, Num: %d)\n", str, eind, tind, find, num);
    fclose(fp);
};