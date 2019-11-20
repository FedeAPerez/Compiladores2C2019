
#include "assembler.h"

void generarAssembler(ArrayTercetos *a)
{
    pprints("Generando Assembler...");
    FILE *fpAss = fopen("Final.asm", "r");
    fpAss = fopen("Final.asm", "a");
    fprintf(fpAss, "include macros2.asm\n");
	fprintf(fpAss, "include number.asm\n");
	fprintf(fpAss, ".MODEL	LARGE \n");
	fprintf(fpAss, ".386\n");
	fprintf(fpAss, ".STACK 200h \n");
    
	generarData(fpAss);
	
    fprintf(fpAss, "\n.CODE \n");
	fprintf(fpAss, "MAIN:\n");
	fprintf(fpAss, "\n");

    fprintf(fpAss, "\n");
    fprintf(fpAss, "\t MOV AX,@DATA 	;inicializa el segmento de datos\n");
    fprintf(fpAss, "\t MOV DS,AX \n");
    fprintf(fpAss, "\t MOV ES,AX \n");
    fprintf(fpAss, "\t FNINIT \n");;
    fprintf(fpAss, "\n");
	
    generarCode(fpAss, a);
    fclose(fpAss);
    pprints("Assembler generado...");
};

void generarOperandoIzquierdo(FILE *fpAss, ArrayTercetos *a, int i)
{
    if(a->array[a->array[i].left].type == 'I') {
        fprintf(fpAss, "\nFLD _%d", a->array[a->array[i].left].intValue);
    } else if (a->array[a->array[i].left].type == 'S') {
        fprintf(fpAss, "\nFLD _%s", a->array[a->array[i].left].stringValue);
    } else if (a->array[a->array[i].left].type == 'F') {
        fprintf(fpAss, "\nFLD _%f", a->array[a->array[i].left].floatValue);
    }
}

void generarOperandoDerecho(FILE *fpAss, ArrayTercetos *a, int i)
{
    if(a->array[a->array[i].right].type == 'I') {
        fprintf(fpAss, "\nFLD _%d", a->array[a->array[i].right].intValue);
    } else if (a->array[a->array[i].right].type == 'S') {
        fprintf(fpAss, "\nFLD _%s", a->array[a->array[i].right].stringValue);
    } else if (a->array[a->array[i].right].type == 'F') {
        fprintf(fpAss, "\nFLD _%f", a->array[a->array[i].right].floatValue);
    }
}

void generarCode(FILE *fpAss, ArrayTercetos *a)
{

    fprintf(fpAss, "\nFINIT");
    
    FILE *fpTs = fopen("intermedia.txt", "r");
    char linea[200];
    ArrayTercetos arrayTercetos;
    crearTercetos(&arrayTercetos, 100);

        if((int)a->tamanioUsado > 0) {
        for(int i=0; i < (int)a->tamanioUsado; i++) {

            if(a->array[i].isOperand == 1) {
                if(a->array[i].type == 'S') {
                } else if (a->array[i].type == 'F') {
                } else if (a->array[i].type == 'I') {
                }
            }
            else if(a->array[i].isOperator == 1) {

                char operador = a->array[i].operator;
				if(operador == TOP_PRINT){
					if (a->array[a->array[i].right].type == 'S') {
						fprintf(fpAss, "\nFLD _%s", a->array[a->array[i].right].stringValue);
					}
				}
                else if(operador == TOP_SUM) {
                    if(a->array[a->array[i].left].isOperand == 1) {
                        generarOperandoIzquierdo(fpAss, a, i);
                    }

                    if(a->array[a->array[i].right].isOperand == 1) {
                        generarOperandoDerecho(fpAss, a, i);
                    }
                    fprintf(fpAss, "\nFADD");
                }
                else if(operador == TOP_MUL) {
                    if(a->array[a->array[i].left].isOperand == 1) {
                        generarOperandoIzquierdo(fpAss, a, i);
                    }
                    if(a->array[a->array[i].right].isOperand == 1) {
                        generarOperandoDerecho(fpAss, a, i);
                    }
                    fprintf(fpAss, "\nFMUL");
                }

                else if(operador == TOP_DIV) {
                    if(a->array[a->array[i].left].isOperand == 1) {
                        generarOperandoIzquierdo(fpAss, a, i);
                    }
                    if(a->array[a->array[i].right].isOperand == 1) {
                        generarOperandoDerecho(fpAss, a, i);
                    }
                    fprintf(fpAss, "\nFDIV");
                }

                else if (operador == TOP_RES) {
                    if(a->array[a->array[i].left].isOperand == 1) {
                        generarOperandoIzquierdo(fpAss, a, i);
                    }
                    if(a->array[a->array[i].right].isOperand == 1) {
                        generarOperandoDerecho(fpAss, a, i);
                    }
                    fprintf(fpAss, "\nFSUB");
                }

                else if (operador == TOP_ASIG) {
                    if(a->array[a->array[i].right].isOperand == 1) {
                        generarOperandoDerecho(fpAss, a, i);
                    }
                    fprintf(fpAss, "\nFSTP _%s", a->array[a->array[i].left].stringValue);
					fprintf(fpAss, "\nFFREE ST(0)");
                }
                else if (operador == TOP_MOD) {
                    if(a->array[a->array[i].left].isOperand == 1) {
                        generarOperandoIzquierdo(fpAss, a, i);
                    }
                    if(a->array[a->array[i].right].isOperand == 1) {
                        generarOperandoDerecho(fpAss, a, i);
                    }
                    fprintf(fpAss, "\nFPREM");
                }
                else if (operador == TOP_DIV) {
                    if(a->array[a->array[i].left].isOperand == 1) {
                        generarOperandoIzquierdo(fpAss, a, i);
                    }
                    if(a->array[a->array[i].right].isOperand == 1) {
                        generarOperandoDerecho(fpAss, a, i);
                    }
                    fprintf(fpAss, "\nFDIV");
                }
                else if (operador == TOP_CMP) {
                    if(a->array[a->array[i].left].isOperand == 1) {
                        generarOperandoIzquierdo(fpAss, a, i);
                    }

                    if(a->array[a->array[i].right].isOperand == 1) {
                        generarOperandoDerecho(fpAss, a, i);
                    }
                    fprintf(fpAss, "\n FCOMP");
					fprintf(fpAss, "\n FFREE ST(0)");
					fprintf(fpAss, "\n FSTSW AX ");
					fprintf(fpAss, "\n SAHF ");
                }
                else if (operador == TOP_JUMP) {
                    fprintf(fpAss, "\n%s #%d", a->array[i].operatorStringValue, a->array[i].left);
                }
                else if(operador == TOP_ETIQUETA) {
                    fprintf(fpAss, "\n#%d", a->array[i].left);
                }

            } else {
            }
        }
        
    }
};

char *getAsmType(char *tsType)
{
    if(strcmp(tsType, "FLOAT") == 0)
    {
        return "dd";
    }
    else if (strcmp(tsType, "INTEGER") == 0) {
        return "dd";
    }
    else if (strcmp(tsType, "CONST_STRING") == 0 ) {
        return "db";
    }
    else 
    {
        return "erase_consts";
    }
}

void generarData(FILE *fpAss)
{
    char linea[124];
    char lineaValue[36];
    int esLineaEncabezado = 0;
    FILE *fpTs = fopen("ts.txt", "r");

    fprintf(fpAss, "\n.DATA");
    
    while(fgets(linea, sizeof(linea), fpTs))
    {
        char lineaName[36];
        char lineaType[21];
        if(esLineaEncabezado == 0) {
            esLineaEncabezado = 1;
        } else {
            strncpy(lineaName, &linea[0], 35);
            strncpy(lineaType, &linea[36], 19);
            lineaName[35] = '\0';
            lineaType[20] = '\0';
            if(strcmp(trim(lineaName, NULL), "") != 0) {
                // Change if var is initialized
                fprintf(fpAss, "\n_%s %s ?", lineaName, getAsmType(trim(lineaType, NULL)));
            }
        }
    }
};