#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TOP_ASIG 0
#define TOP_SUM 1
#define TOP_MUL 2
#define TOP_RES 3
#define TOP_DIV 4
#define TOP_MOD 5
#define TOP_DIV_ENTERA 6
#define TOP_CMP 7

typedef struct Terceto {
    int tercetoID;
    // Helpers for Assembler
    // Operator
    int isOperator;
    int operator; // + / - * MOD DIV
    int left;
    int right;
    // Operand
    int isOperand;
    char type; // S, F, I
    // Operand -> Store for values
    char *stringValue;
    int intValue;
    float floatValue;
    int isConst;
} Terceto;

typedef struct ArrayTercetos 
{
    size_t tamanioUsado;
    size_t tamanioTotal;
    struct Terceto *punteroTercetos;
} ArrayTercetos;

void crearTercetos(ArrayTercetos *, size_t);
void insertarTercetos(ArrayTercetos *, Terceto);
char * getStringFromOperator(int);
