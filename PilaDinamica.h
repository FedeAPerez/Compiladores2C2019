#include <stdio.h>
#include <stdlib.h>
#define TAM_PILA 100


typedef struct t_nodo{
    int info;
    struct t_nodo *sig;
}t_nodo;

typedef struct t_nodo *pila;

void crearPila( pila *p);
int pilaLLena( pila *p );
int pilaVacia( pila *p);
int ponerEnPila(pila *p, int dato);
int sacarDePila(pila *p);



void crearPila( pila *p){
    *p=NULL;
}

int pilaLLena( pila *p ){
    t_nodo *aux = (t_nodo*)malloc(sizeof(t_nodo));
	free(aux);
	return aux==NULL;
}

int pilaVacia( pila *p){
    return *p == NULL;
}

int ponerEnPila(pila *p, int dato){
    t_nodo *nue = (t_nodo*)malloc(sizeof(t_nodo));
	if(nue == NULL)
		return 0;
	nue->info = dato;
	nue->sig = *p;
	*p = nue;
    return 1;
}

int sacarDePila(pila *p){
    t_nodo *aux;
	int info;
	if(*p == NULL)
		return 0;
	aux = *p;
	info = aux->info;
	*p = aux ->sig;
	free(aux);
	return info;
}
