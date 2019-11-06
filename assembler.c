#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "assembler.h"
#include "archivos.h"
#include "prints.h"

void crearTercetos(ArrayTercetos * a, size_t n)
{
    a->tamanioTotal = n;
    a->tamanioUsado = 0;
    a->punteroTercetos = (Terceto *)malloc(n * sizeof(Terceto));

    // Initialize all values of the array to 0
    for(unsigned int i = 0; i<n; i++)
    {
        memset(&a->punteroTercetos[i],0,sizeof(Terceto));
    }
};

void insertarTercetos(ArrayTercetos *a, Terceto element) 
{
    if (a->tamanioUsado == a->tamanioTotal)
    {
        a->tamanioTotal *= 2;
        a->punteroTercetos = (Terceto *)realloc(a->punteroTercetos, a->tamanioTotal * sizeof(Terceto));
    }

    // Copiar Terceto

    a->punteroTercetos[a->tamanioUsado].tercetoID = element.tercetoID;
    a->punteroTercetos[a->tamanioUsado].type = element.type;
    a->punteroTercetos[a->tamanioUsado].isOperand = element.isOperand;
    a->punteroTercetos[a->tamanioUsado].isOperator = element.isOperator;

    if(element.isOperator) {
        a->punteroTercetos[a->tamanioUsado].operator = element.operator;
        a->punteroTercetos[a->tamanioUsado].left = element.left;
        a->punteroTercetos[a->tamanioUsado].right = element.right;
    }

    if(element.isOperand == 1) {
        if(element.type == 'S') {
            // Puede ser variable o Const string -> puede convenir un type V
            a->punteroTercetos[a->tamanioUsado].stringValue = (char*)malloc(strlen(element.stringValue) + 1);
            strcpy(a->punteroTercetos[a->tamanioUsado].stringValue, element.stringValue);
        }
        else if (element.type == 'F') {
            a->punteroTercetos[a->tamanioUsado].floatValue = element.floatValue;
        } 
        else if (element.type == 'I') {
            a->punteroTercetos[a->tamanioUsado].intValue = element.intValue;
        }
    }

    a->tamanioUsado++;
};

void generarAssembler(ArrayTercetos *a)
{
    pprints("Generando Assembler...");
    FILE *fpAss = fopen("Final.asm", "r");
    fpAss = fopen("Final.asm", "a");
    fprintf(fpAss, ".386");
    fprintf(fpAss, "\n.MODEL SMALL");
    generarData(fpAss);
    generarCode(fpAss);

    fprintf(fpAss, "\nFINIT");

    if((int)a->tamanioUsado > 0) {
        for(int i=0; i < (int)a->tamanioUsado; i++) {
            if(a->punteroTercetos[i].isOperand == 1) {
                if(a->punteroTercetos[i].type == 'S') {
                    printf("\n[%d] -%c- es operando, de valor '%s'", a->punteroTercetos[i].tercetoID, a->punteroTercetos[i].type, a->punteroTercetos[i].stringValue);
                } else if (a->punteroTercetos[i].type == 'F') {
                    printf("\n[%d] -%c- es operando, de valor '%f'", a->punteroTercetos[i].tercetoID, a->punteroTercetos[i].type, a->punteroTercetos[i].floatValue);
                } else if (a->punteroTercetos[i].type == 'I') {
                    printf("\n[%d] -%c- es operando, de valor '%d'", a->punteroTercetos[i].tercetoID, a->punteroTercetos[i].type, a->punteroTercetos[i].intValue);
                }
            }
            if(a->punteroTercetos[i].isOperator == 1) {
                // acá, cada left o right puede volver a ser otro operador, así que tiene que ir resolviendose
                // desde arriba hacia abajo
                // los siguientes prints son ilustrativos de como debería quedar el "SWITCH" para insertar codigo
                // para cada operacion
                if(a->punteroTercetos[i].operator == '+') {
                    if(a->punteroTercetos[a->punteroTercetos[i].left].isOperand) {
                        // si lo que está a izquerda es un operando (constnates o variables), 
                        // ya puedo hacer FMOV -> Esta lógica se repite para TODAS las instrucciones binarias
                        fprintf(fpAss, "\nFMOV %d", a->punteroTercetos[a->punteroTercetos[i].left].intValue);
                    }

                    if(a->punteroTercetos[a->punteroTercetos[i].right].isOperand) {
                        // si lo que está a derecha o derecha es un operando (constnates o variables), 
                        // ya puedo hacer FMOV -> Esta lógica se repite para TODAS las instrucciones binarias
                        fprintf(fpAss, "\nFMOV %d", a->punteroTercetos[a->punteroTercetos[i].right].intValue);
                    }

                    fprintf(fpAss, "\nFADD");
                }
                if(a->punteroTercetos[i].operator == '*') {
                    if(a->punteroTercetos[a->punteroTercetos[i].left].isOperand) {
                        // si lo que está a izquerda es un operando (constnates o variables), 
                        // ya puedo hacer FMOV -> Esta lógica se repite para TODAS las instrucciones binarias
                        fprintf(fpAss, "\nFMOV %d", a->punteroTercetos[a->punteroTercetos[i].left].intValue);
                    }

                    if(a->punteroTercetos[a->punteroTercetos[i].right].isOperand) {
                        // si lo que está a derecha o derecha es un operando (constnates o variables), 
                        // ya puedo hacer FMOV -> Esta lógica se repite para TODAS las instrucciones binarias
                        fprintf(fpAss, "\nFMOV %d", a->punteroTercetos[a->punteroTercetos[i].right].intValue);
                    }

                    fprintf(fpAss, "\nFMUL");
                }

                if(a->punteroTercetos[i].operator == '/') {
                    if(a->punteroTercetos[a->punteroTercetos[i].left].isOperand) {
                        // si lo que está a izquerda es un operando (constnates o variables), 
                        // ya puedo hacer FMOV -> Esta lógica se repite para TODAS las instrucciones binarias
                        fprintf(fpAss, "\nFMOV %d", a->punteroTercetos[a->punteroTercetos[i].left].intValue);
                    }

                    if(a->punteroTercetos[a->punteroTercetos[i].right].isOperand) {
                        // si lo que está a derecha o derecha es un operando (constnates o variables), 
                        // ya puedo hacer FMOV -> Esta lógica se repite para TODAS las instrucciones binarias
                        fprintf(fpAss, "\nFMOV %d", a->punteroTercetos[a->punteroTercetos[i].right].intValue);
                    }

                    fprintf(fpAss, "\nFDIV");
                }

                if(a->punteroTercetos[i].operator == '-') {
                    if(a->punteroTercetos[a->punteroTercetos[i].left].isOperand) {
                        // si lo que está a izquerda es un operando (constnates o variables), 
                        // ya puedo hacer FMOV -> Esta lógica se repite para TODAS las instrucciones binarias
                        fprintf(fpAss, "\nFMOV %d", a->punteroTercetos[a->punteroTercetos[i].left].intValue);
                    }

                    if(a->punteroTercetos[a->punteroTercetos[i].right].isOperand) {
                        // si lo que está a derecha o derecha es un operando (constnates o variables), 
                        // ya puedo hacer FMOV -> Esta lógica se repite para TODAS las instrucciones binarias
                        fprintf(fpAss, "\nFMOV %d", a->punteroTercetos[a->punteroTercetos[i].right].intValue);
                    }

                    fprintf(fpAss, "\nFSUB");
                }
                if(a->punteroTercetos[i].operator == '=') {
                    // lo que tengo a izquierda siempre lo puedo asignar
                    // si lo tengo en ST0 ya puede ser resuelto con la siguiente linea
                    fprintf(fpAss, "\nFSTP %s", a->punteroTercetos[a->punteroTercetos[i].left].stringValue);
                }
                printf("\n[%d] es operador ('%c', [%d], [%d])", a->punteroTercetos[i].tercetoID, a->punteroTercetos[i].operator, a->punteroTercetos[i].left, a->punteroTercetos[i].right);
            }
        }
        
    }
    

    fclose(fpAss);
    pprints("Assembler generado...");
};

void generarCode(FILE *fpAss)
{
    fprintf(fpAss, "\n.CODE");
    FILE *fpTs = fopen("intermedia.txt", "r");
    char linea[200];
    ArrayTercetos arrayTercetos;
    crearTercetos(&arrayTercetos, 100);

    while(fgets(linea, sizeof(linea), fpTs))
    {
        printf("\ntenemos la linea \'%s\'", trim(linea, NULL));
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