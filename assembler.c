
#include "assembler.h"

void generarAssembler(ArrayTercetos *a)
{
    pprints("Generando Assembler...");
    FILE *fpAss = fopen("Final.asm", "r");
    fpAss = fopen("Final.asm", "a");
    fprintf(fpAss, ".386");
    fprintf(fpAss, "\n.MODEL SMALL");
    fprintf(fpAss, "\n");
    generarData(fpAss);
    fprintf(fpAss, "\n");
    generarCode(fpAss, a);
    fclose(fpAss);
    pprints("Assembler generado...");
};

void generarCode(FILE *fpAss, ArrayTercetos *a)
{
    fprintf(fpAss, "\n.CODE");

    fprintf(fpAss, "\nFINIT");
    
    FILE *fpTs = fopen("intermedia.txt", "r");
    char linea[200];
    ArrayTercetos arrayTercetos;
    crearTercetos(&arrayTercetos, 100);

    printf("\n------ Ini de CI ------\n");
    while(fgets(linea, sizeof(linea), fpTs))
    {
        printf("\n%s", trim(linea, NULL));
    }
    printf("\n------ Fin de CI ------\n");

        if((int)a->tamanioUsado > 0) {
        for(int i=0; i < (int)a->tamanioUsado; i++) {

            if(a->array[i].isOperand == 1) {
                if(a->array[i].type == 'S') {
                    printf("\n[%d] -%c- es operando, de valor '%s'", a->array[i].tercetoID, a->array[i].type, a->array[i].stringValue);
                } else if (a->array[i].type == 'F') {
                    printf("\n[%d] -%c- es operando, de valor '%f'", a->array[i].tercetoID, a->array[i].type, a->array[i].floatValue);
                } else if (a->array[i].type == 'I') {
                    printf("\n[%d] -%c- es operando, de valor '%d'", a->array[i].tercetoID, a->array[i].type, a->array[i].intValue);
                }
            }
            else if(a->array[i].isOperator == 1) {
                // acá, cada left o right puede volver a ser otro operador, así que tiene que ir resolviendose
                // desde arriba hacia abajo
                // los siguientes prints son ilustrativos de como debería quedar el "SWITCH" para insertar codigo
                // para cada operacion
                char operador = a->array[i].operator;
                if(operador == TOP_SUM) {
                    if(a->array[a->array[i].left].isOperand == 1) {
                        // si lo que está a izquerda es un operando (constnates o variables), 
                        // ya puedo hacer FMOV -> Esta lógica se repite para TODAS las instrucciones binarias
                        fprintf(fpAss, "\nFMOV %d", a->array[a->array[i].left].intValue);
                    }

                    if(a->array[a->array[i].right].isOperand == 1) {
                        // si lo que está a derecha o derecha es un operando (constnates o variables), 
                        // ya puedo hacer FMOV -> Esta lógica se repite para TODAS las instrucciones binarias
                        fprintf(fpAss, "\nFMOV %d", a->array[a->array[i].right].intValue);
                    }

                    fprintf(fpAss, "\nFADD");
                }
                else if(operador == TOP_MUL) {
                    if(a->array[a->array[i].left].isOperand == 1) {
                        // si lo que está a izquerda es un operando (constnates o variables), 
                        // ya puedo hacer FMOV -> Esta lógica se repite para TODAS las instrucciones binarias
                        fprintf(fpAss, "\nFMOV %d", a->array[a->array[i].left].intValue);
                    }

                    if(a->array[a->array[i].right].isOperand == 1) {
                        // si lo que está a derecha o derecha es un operando (constnates o variables), 
                        // ya puedo hacer FMOV -> Esta lógica se repite para TODAS las instrucciones binarias
                        fprintf(fpAss, "\nFMOV %d", a->array[a->array[i].right].intValue);
                    }

                    fprintf(fpAss, "\nFMUL");
                }

                else if(operador == TOP_DIV) {
                    if(a->array[a->array[i].left].isOperand == 1) {
                        // si lo que está a izquerda es un operando (constnates o variables), 
                        // ya puedo hacer FMOV -> Esta lógica se repite para TODAS las instrucciones binarias
                        fprintf(fpAss, "\nFMOV %d", a->array[a->array[i].left].intValue);
                    }

                    if(a->array[a->array[i].right].isOperand == 1) {
                        // si lo que está a derecha o derecha es un operando (constnates o variables), 
                        // ya puedo hacer FMOV -> Esta lógica se repite para TODAS las instrucciones binarias
                        fprintf(fpAss, "\nFMOV %d", a->array[a->array[i].right].intValue);
                    }

                    fprintf(fpAss, "\nFDIV");
                }

                else if (operador == TOP_RES) {
                    if(a->array[a->array[i].left].isOperand == 1) {
                        // si lo que está a izquerda es un operando (constnates o variables), 
                        // ya puedo hacer FMOV -> Esta lógica se repite para TODAS las instrucciones binarias
                        fprintf(fpAss, "\nFMOV %d", a->array[a->array[i].left].intValue);
                    }

                    if(a->array[a->array[i].right].isOperand == 1) {
                        // si lo que está a derecha o derecha es un operando (constnates o variables), 
                        // ya puedo hacer FMOV -> Esta lógica se repite para TODAS las instrucciones binarias
                        fprintf(fpAss, "\nFMOV %d", a->array[a->array[i].right].intValue);
                    }

                    fprintf(fpAss, "\nFSUB");
                }

                else if (operador == TOP_ASIG) {
                    // lo que tengo a izquierda siempre lo puedo asignar porque será un ID (si está en left)
                    // si lo tengo en ST0 ya puede ser resuelto con la siguiente linea
                    // PERO -> si el lado derecho es otra variable primero tengo que moverla a ST0
                    if(a->array[a->array[i].right].isOperand == 1) {
                        // acá podría chequear tipos para cargar siempre flotante
                        fprintf(fpAss, "\nFLD %d", a->array[a->array[i].right].intValue);
                    }

                    fprintf(fpAss, "\nFSTP %s", a->array[a->array[i].left].stringValue);
                }
                else if (operador == TOP_MOD) {
                    if(a->array[a->array[i].left].isOperand == 1) {
                        // si lo que está a izquerda es un operando (constnates o variables), 
                        // ya puedo hacer FMOV -> Esta lógica se repite para TODAS las instrucciones binarias
                        fprintf(fpAss, "\nFMOV %d", a->array[a->array[i].left].intValue);
                    }

                    if(a->array[a->array[i].right].isOperand == 1) {
                        // si lo que está a derecha o derecha es un operando (constnates o variables), 
                        // ya puedo hacer FMOV -> Esta lógica se repite para TODAS las instrucciones binarias
                        fprintf(fpAss, "\nFMOV %d", a->array[a->array[i].right].intValue);
                    }

                    fprintf(fpAss, "\nFMOD");
                }
                else if (operador == TOP_DIV) {
                    // No conozco la diferencia exacta entre esta división y la otra,
                    // posiblemente una conversión entre Float a Int
                    if(a->array[a->array[i].left].isOperand == 1) {
                        // si lo que está a izquerda es un operando (constnates o variables), 
                        // ya puedo hacer FMOV -> Esta lógica se repite para TODAS las instrucciones binarias
                        fprintf(fpAss, "\nFMOV %d", a->array[a->array[i].left].intValue);
                    }

                    if(a->array[a->array[i].right].isOperand == 1) {
                        // si lo que está a derecha o derecha es un operando (constnates o variables), 
                        // ya puedo hacer FMOV -> Esta lógica se repite para TODAS las instrucciones binarias
                        fprintf(fpAss, "\nFMOV %d", a->array[a->array[i].right].intValue);
                    }

                    fprintf(fpAss, "\nFDIV");
                }
                else if (operador == TOP_CMP) {
                    // No conozco la diferencia exacta entre esta división y la otra,
                    // posiblemente una conversión entre Float a Int
                    if(a->array[a->array[i].left].isOperand == 1) {
                        // si lo que está a izquerda es un operando (constnates o variables), 
                        // ya puedo hacer FLD -> Esta lógica se repite para TODAS las instrucciones binarias
                        if(a->array[a->array[i].left].type == 'I')
                            fprintf(fpAss, "\nFLD %d", a->array[a->array[i].left].intValue);
                        else if (a->array[a->array[i].left].type == 'S') {
                            fprintf(fpAss, "\nFLD %s", a->array[a->array[i].left].stringValue);
                        }
                    }

                    if(a->array[a->array[i].right].isOperand == 1) {
                        // si lo que está a izquerda es un operando (constnates o variables), 
                        // ya puedo hacer FLD -> Esta lógica se repite para TODAS las instrucciones binarias
                        if(a->array[a->array[i].right].type == 'I')
                            fprintf(fpAss, "\nFLD %d", a->array[a->array[i].right].intValue);
                        else if (a->array[a->array[i].right].type == 'S') {
                            fprintf(fpAss, "\nFLD %s", a->array[a->array[i].right].stringValue);
                        }
                    }

                    fprintf(fpAss, "\nCMP");
                }
                else if (operador == TOP_JUMP) {
                    fprintf(fpAss, "\n%s", a->array[i].operatorStringValue);
                }

                printf("\n[%d] es operador ('%s', [%d], [%d])", a->array[i].tercetoID, getStringFromOperator(a->array[i].operator), a->array[i].left, a->array[i].right);
            } else {
                printf("\n[%d] hay error ", a->array[i].tercetoID);
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