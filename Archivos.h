#include "stdio.h"
#include "stdlib.h"
#include <string.h>
#define FILE_NAME_TERCETOS "intermedia.txt"
#define FILE_NAME_TERCETOS_COPIA "intermedia_copia.txt"
#define READ_FILE_TERCETOS "r+"
#define WRITE_FILE_TERCETOS "w+"


char *replace_str(char *str, char *orig, char *rep);
int ActualizarArchivo(int posicion, int dato);


int ActualizarArchivo(int posicion, int dato)
{
	char aux[5];
	char linea[500];
	char cadena[500];
	int cont =0;
	int i ;
	
	FILE *fp = fopen(FILE_NAME_TERCETOS, READ_FILE_TERCETOS);
	 if (!fp) {
                printf("Error al querer abrir el archivo!!\n");
                return 0;
        }

	
	FILE *fp1 = fopen(FILE_NAME_TERCETOS_COPIA, WRITE_FILE_TERCETOS);
	 if (!fp1) {
                printf("Error al querer abrir el archivo 1!!\n");
                return 0;
        }
		
    while(fgets(linea,sizeof(linea),fp))
    {
		if(cont == posicion){
			
			sprintf(aux, "[%d]", dato);		
			strcpy(cadena, replace_str(linea,"#",aux));
			fprintf(fp1, "%s", cadena);
			
		}else{
			 fprintf(fp1, "%s", linea);
		}
		cont++;
		
	}

    fclose(fp);
	fclose(fp1);
	
	//Sobreescribir archivo
	fp = fopen(FILE_NAME_TERCETOS, "w+");
	 if (!fp) {
                printf("Error al querer abrir el archivo!!\n");
                return 0;
        }

	
	fp1 = fopen(FILE_NAME_TERCETOS_COPIA, READ_FILE_TERCETOS);
	 if (!fp1) {
                printf("Error al querer abrir el archivo 1!!\n");
                return 0;
        }
		
    while(fgets(linea,sizeof(linea),fp1))
    {
		fprintf(fp, "%s", linea);

		
	}

    fclose(fp);
	fclose(fp1);
	
	remove(FILE_NAME_TERCETOS_COPIA);
    return 1;
}



char *replace_str(char *str, char *orig, char *rep)
{
  char *buffer;
  char *p;

  if(!(p = strstr(str, orig)))  
    return str;

  buffer = (char*)malloc(strlen(str)+strlen(rep)-strlen(orig)+1);

  strncpy(buffer, str, p-str); 

  sprintf(buffer+(p-str), "%s%s", rep, p+strlen(orig));

  return replace_str(buffer, orig, rep);
}
