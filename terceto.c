#include "terceto.h"

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

    if(element.tercetoID == 7)
    {
        printf("\n Aca el problem: Operator: %d Operando: %d", element.isOperator, element.isOperand);
    }

    a->tamanioUsado = a->tamanioUsado + 1;
};
