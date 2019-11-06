
#include "assembler.h"

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
                    if(a->punteroTercetos[a->punteroTercetos[i].left].isOperand == 1) {
                        // si lo que está a izquerda es un operando (constnates o variables), 
                        // ya puedo hacer FMOV -> Esta lógica se repite para TODAS las instrucciones binarias
                        fprintf(fpAss, "\nFMOV %d", a->punteroTercetos[a->punteroTercetos[i].left].intValue);
                    }

                    if(a->punteroTercetos[a->punteroTercetos[i].right].isOperand == 1) {
                        // si lo que está a derecha o derecha es un operando (constnates o variables), 
                        // ya puedo hacer FMOV -> Esta lógica se repite para TODAS las instrucciones binarias
                        fprintf(fpAss, "\nFMOV %d", a->punteroTercetos[a->punteroTercetos[i].right].intValue);
                    }

                    fprintf(fpAss, "\nFADD");
                }
                if(a->punteroTercetos[i].operator == '*') {
                    if(a->punteroTercetos[a->punteroTercetos[i].left].isOperand == 1) {
                        // si lo que está a izquerda es un operando (constnates o variables), 
                        // ya puedo hacer FMOV -> Esta lógica se repite para TODAS las instrucciones binarias
                        fprintf(fpAss, "\nFMOV %d", a->punteroTercetos[a->punteroTercetos[i].left].intValue);
                    }

                    if(a->punteroTercetos[a->punteroTercetos[i].right].isOperand == 1) {
                        // si lo que está a derecha o derecha es un operando (constnates o variables), 
                        // ya puedo hacer FMOV -> Esta lógica se repite para TODAS las instrucciones binarias
                        fprintf(fpAss, "\nFMOV %d", a->punteroTercetos[a->punteroTercetos[i].right].intValue);
                    }

                    fprintf(fpAss, "\nFMUL");
                }

                if(a->punteroTercetos[i].operator == '/') {
                    if(a->punteroTercetos[a->punteroTercetos[i].left].isOperand == 1) {
                        // si lo que está a izquerda es un operando (constnates o variables), 
                        // ya puedo hacer FMOV -> Esta lógica se repite para TODAS las instrucciones binarias
                        fprintf(fpAss, "\nFMOV %d", a->punteroTercetos[a->punteroTercetos[i].left].intValue);
                    }

                    if(a->punteroTercetos[a->punteroTercetos[i].right].isOperand == 1) {
                        // si lo que está a derecha o derecha es un operando (constnates o variables), 
                        // ya puedo hacer FMOV -> Esta lógica se repite para TODAS las instrucciones binarias
                        fprintf(fpAss, "\nFMOV %d", a->punteroTercetos[a->punteroTercetos[i].right].intValue);
                    }

                    fprintf(fpAss, "\nFDIV");
                }

                if(a->punteroTercetos[i].operator == '-') {
                    if(a->punteroTercetos[a->punteroTercetos[i].left].isOperand == 1) {
                        // si lo que está a izquerda es un operando (constnates o variables), 
                        // ya puedo hacer FMOV -> Esta lógica se repite para TODAS las instrucciones binarias
                        fprintf(fpAss, "\nFMOV %d", a->punteroTercetos[a->punteroTercetos[i].left].intValue);
                    }

                    if(a->punteroTercetos[a->punteroTercetos[i].right].isOperand == 1) {
                        // si lo que está a derecha o derecha es un operando (constnates o variables), 
                        // ya puedo hacer FMOV -> Esta lógica se repite para TODAS las instrucciones binarias
                        fprintf(fpAss, "\nFMOV %d", a->punteroTercetos[a->punteroTercetos[i].right].intValue);
                    }

                    fprintf(fpAss, "\nFSUB");
                }

                if(a->punteroTercetos[i].operator == '=') {
                    // lo que tengo a izquierda siempre lo puedo asignar
                    // si lo tengo en ST0 ya puede ser resuelto con la siguiente linea
                    // PERO -> si el lado derecho es otra variable primero tengo que moverla a ST0
                    if(a->punteroTercetos[a->punteroTercetos[i].right].isOperand == 1) {
                        // acá podría chequear tipos para cargar siempre flotante
                        fprintf(fpAss, "\nFLD %d", a->punteroTercetos[a->punteroTercetos[i].right].intValue);
                    }

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