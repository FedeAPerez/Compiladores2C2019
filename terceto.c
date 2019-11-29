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
    } else if (operator == TOP_JUMP) {
        return "JUMP";
    } else if (operator == TOP_ETIQUETA) {
        return "ETIQ";
    } else {
        return "AGREGAR STRING DE OPERATOR";
    }
} 

void crearTercetos(ArrayTercetos * a, size_t n)
{
    a->tamanioTotal = n;
    a->tamanioUsado = 0;
    a->array = (Terceto *)malloc(n * sizeof(Terceto));

    // Initialize all values of the array to 0
    for(unsigned int i = 0; i<n; i++)
    {
        memset(&a->array[i],0,sizeof(Terceto));
    }
};

void insertarTercetos(ArrayTercetos *a, Terceto element) 
{
    if (a->tamanioUsado == a->tamanioTotal)
    {
        a->tamanioTotal *= 2;
        a->array = (Terceto *)realloc(a->array, a->tamanioTotal * sizeof(Terceto));
    }

    // Copiar Terceto

    a->array[a->tamanioUsado].tercetoID = element.tercetoID;
	
    if(element.isOperator == 1) {
		if(element.operator == TOP_PRINT || element.operator == TOP_READ)
		{
			a->array[a->tamanioUsado].isOperand = 0;
			a->array[a->tamanioUsado].isOperator = 1;
			a->array[a->tamanioUsado].operator = element.operator;
			a->array[a->tamanioUsado].type = element.type;
			a->array[a->tamanioUsado].stringValue = malloc(strlen(element.stringValue) + 1);
            strcpy(a->array[a->tamanioUsado].stringValue, element.stringValue);
		}else{
		
			a->array[a->tamanioUsado].isOperand = 0;
			a->array[a->tamanioUsado].isOperator = 1;
			a->array[a->tamanioUsado].operator = element.operator;
			a->array[a->tamanioUsado].left = element.left;
			a->array[a->tamanioUsado].right = element.right;

			if(element.operator == TOP_JUMP) {
				a->array[a->tamanioUsado].operatorStringValue = malloc(strlen(element.operatorStringValue) + 1);
				strcpy(a->array[a->tamanioUsado].operatorStringValue, element.operatorStringValue);
			}
		}
    }

    if(element.isOperand == 1) {
        a->array[a->tamanioUsado].isOperator = 0;
        a->array[a->tamanioUsado].isOperand = 1;
        a->array[a->tamanioUsado].type = element.type;
        
        if(element.type == 'S') {
            // Puede ser variable o Const string -> puede convenir un type V
            a->array[a->tamanioUsado].stringValue = malloc(strlen(element.stringValue) + 1);
            strcpy(a->array[a->tamanioUsado].stringValue, element.stringValue);
        }
        else if (element.type == 'F') {
            a->array[a->tamanioUsado].floatValue = element.floatValue;
        } 
        else if (element.type == 'I') {
            a->array[a->tamanioUsado].intValue = element.intValue;
        }
    }

    a->tamanioUsado = a->tamanioUsado + 1;
};


