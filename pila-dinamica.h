#include <stdio.h>
#include <stdlib.h>

typedef struct t_nodo{
    int info;
    struct t_nodo *sig;
}t_nodo;

typedef struct t_nodo_s {
	char* info;
	struct t_nodo_s *sig;
} t_nodo_s;

typedef struct t_nodo *pila;
typedef struct t_nodo_s *pila_s;

void crearPila(pila *);
void crearPilaS(pila_s *);
int pilaLLena(pila *);
int pilaLLenaS(pila_s *);
int pilaVacia(pila *);
int pilaVaciaS(pila_s *);
int ponerEnPila(pila *, int);
int ponerEnPilaS(pila_s *, char *);
int sacarDePila(pila *);
char* sacarDePilaS(pila_s *);


void crearPila(pila *p){
    *p=NULL;
}

void crearPilaS(pila_s *p){
    *p=NULL;
}

int pilaLLena(pila *p){
    t_nodo *aux = (t_nodo*)malloc(sizeof(t_nodo));
	free(aux);
	return aux==NULL;
}

int pilaLLenaS(pila_s *p ){
    t_nodo_s *aux = (t_nodo_s*)malloc(sizeof(t_nodo_s));
	free(aux);
	return aux==NULL;
}

int pilaVacia(pila *p){
    return *p == NULL;
}

int pilaVaciaS(pila_s *p){
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

int ponerEnPilaS(pila_s *p, char * dato){
    t_nodo_s *nue = (t_nodo_s*)malloc(sizeof(t_nodo_s));
	if(nue == NULL)
		return 0;
	nue->info = strdup(dato);
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

char* sacarDePilaS(pila_s *p){
    t_nodo_s *aux;
	char* info;
	if(*p == NULL)
		return 0;
	aux = *p;
	info = strdup(aux->info);
	*p = aux ->sig;
	free(aux);
	return info;
}
