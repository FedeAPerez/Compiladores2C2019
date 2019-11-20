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
#define TOP_JUMP 8
#define TOP_ETIQUETA 9
#define TOP_READ 10
#define TOP_PRINT 11

typedef struct Terceto {
    int tercetoID;
    // Helpers for Assembler
    // Operator
    int isOperator; // Siempre setear con 1 o 0
    int operator; // + / - * MOD DIV CMP
    char * operatorStringValue; // JAE, JI, JE -> Sirve para las comparaciones
    int left;
    int right;
    // Operand
    int isOperand; // Siempre setear con 1 o 0
    char type; // S, F, I
    // Operand -> Store for values
    char *stringValue;
    int intValue;
    float floatValue;
    int isConst; // sin utilizar todavía, podría servir para optimizar? 
} Terceto;

typedef struct ArrayTercetos 
{
    size_t tamanioUsado;
    size_t tamanioTotal;
    struct Terceto *array;
} ArrayTercetos;

void crearTercetos(ArrayTercetos *, size_t);
void insertarTercetos(ArrayTercetos *, Terceto);
char * getStringFromOperator(int);
void guardarEnTerceto(int posicion, int indice);