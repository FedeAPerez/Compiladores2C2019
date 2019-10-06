#include <stdio.h>
#include <stdlib.h>
#define TAM_PILA 100


typedef struct {
    int info[100];
    int tope;
}pila;

void crearPila( pila *p);
int pilaLLena( pila *p );
int pilaVacia( pila *p);
int ponerEnPila(pila *p, int dato);
int sacarDePila(pila *p);



void crearPila( pila *p){
    p->tope = 0;
}

int pilaLLena( pila *p ){
    return p->tope == TAM_PILA;
}

int pilaVacia( pila *p){
    return p->tope == TAM_PILA;
}

int ponerEnPila(pila *p, int dato){
    if( p->tope == 100){
        return 0;
    }
    p->info[p->tope] = dato;
    p->tope++;
    return 1;
}

int sacarDePila(pila *p){
    if( p->tope == 0){
        return 0;
    }
    p->tope--;
    return p->info[p->tope];
}
