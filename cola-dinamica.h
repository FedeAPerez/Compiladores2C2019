#include <stdio.h>
#include <stdlib.h>

typedef struct s_nodo{
    char* info;
    struct s_nodo *sig;
}n_nodo;

typedef struct {
	n_nodo *pri,*ult;
} t_cola;

void crearCola( t_cola *p);
int colaLLena( const t_cola *p );
int colaVacia( t_cola *p);
int ponerEncola(t_cola *p,char* dato);
char* sacarDecola(t_cola *p);



void crearCola( t_cola *p){
    p->pri=NULL;
	p->ult=NULL;
}

int colaLLena(const t_cola *p ){
    n_nodo *aux = (n_nodo*)malloc(sizeof(n_nodo));
	free(aux);
	return aux==NULL;
}

int colaVacia( t_cola *p){
    return p->pri == NULL;
}

int ponerEncola(t_cola *p, char* dato){
    n_nodo *nue = (n_nodo*)malloc(sizeof(n_nodo));
	if(nue == NULL)
		return 0;
	nue->info = dato;
	nue->sig = NULL;
	if(p->pri == NULL)
	{
		p->pri=nue;
		p->ult=nue;
	}
	else
	{
		p->ult->sig=nue;
		p->ult=nue;
	}
    return 1;
}

char* sacarDecola(t_cola *p){
    n_nodo *aux;
	char* info;
	if(p->pri == NULL)
		return 0;
	aux =p->pri;
	info = aux->info;
	if(p->pri == p->ult)
	{
		p->pri=NULL;
		p->ult=NULL;
	}
	else{
		p->pri=aux->sig;
	}
	free(aux);
	return info;
}