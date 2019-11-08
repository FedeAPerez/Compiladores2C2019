#include "terceto.h"

char * getStringFromOperator(int operator) {
    if (operator == TOP_ASIG) {
        return ":=";
    } else if (operator == TOP_SUM) {
        return "+";
    } else if (operator == TOP_MUL) {
        return "*";
    } else if (operator == TOP_RES) {
        return "-";
    } else if (operator == TOP_DIV) {
        return "/";
    } else if (operator == TOP_MOD) {
        return "MOD";
    } else if (operator == TOP_DIV_ENTERA) {
        return "DIV";
    } else if (operator == TOP_CMP) {
        return "CMP";
    } else {
        return "AGREGAR STRING DE OPERATOR";
    }
} 

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

    if(element.isOperator == 1) {
        a->punteroTercetos[a->tamanioUsado].isOperand = 0;
        a->punteroTercetos[a->tamanioUsado].isOperator = 1;
        a->punteroTercetos[a->tamanioUsado].operator = element.operator;
        a->punteroTercetos[a->tamanioUsado].left = element.left;
        a->punteroTercetos[a->tamanioUsado].right = element.right;
    }

    if(element.isOperand == 1) {
        a->punteroTercetos[a->tamanioUsado].isOperator = 0;
        a->punteroTercetos[a->tamanioUsado].isOperand = 1;
        a->punteroTercetos[a->tamanioUsado].type = element.type;
        
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

    a->tamanioUsado = a->tamanioUsado + 1;
};
