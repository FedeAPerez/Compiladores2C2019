#include "stdio.h"
#include "stdlib.h"

void generarAssembler(void);
void generarCode(FILE *);
void generarData(FILE *);

void generarAssembler(void)
{
    printf("\nGenerando Assembler...\n");
    FILE *fpAss = fopen(FILE_NAME_ASS, FILE_MODE_READ);
    fpAss = fopen(FILE_NAME_ASS, FILE_MODE_APPEND);
    fprintf(fpAss, ".MODEL SMALL");
    generarData(fpAss);
    generarCode(fpAss);
    fclose(fpAss);
    printf("\nAssembler generado...\n");
};

void generarCode(FILE *fpAss)
{
    fprintf(fpAss, "\n.CODE");
};

void generarData(FILE *fpAss)
{
    char linea[FILE_SIZE_TS];
    char lineaValue[35];
    int esLineaEncabezado = 0;
    FILE *fpTs = fopen(FILE_NAME_TS, FILE_MODE_READ);


    fprintf(fpAss, "\n.DATA");
    
    while(fgets(linea, FILE_SIZE_TS, fpTs))
    {
        if(esLineaEncabezado == 0) {
            esLineaEncabezado = 1;
        } else {
            strncpy(lineaValue, &linea[36], 19);
            lineaValue[34] = '\0';
            fprintf(fpAss, "\n%s", lineaValue);
        }
    }
};