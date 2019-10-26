#include "stdio.h"
#include "stdlib.h"

#define FILE_NAME_ASS "Final.asm"
#define FILE_MODE_READ "r"
#define FILE_MODE_APPEND "a"

void generarAssembler(void);

void generarAssembler(void)
{
    FILE *fp = fopen(FILE_NAME_ASS, FILE_MODE_READ);
    fp = fopen(FILE_NAME_ASS, FILE_MODE_APPEND);
    fprintf(fp, ".MODEL SMALL");
    fclose(fp);
};