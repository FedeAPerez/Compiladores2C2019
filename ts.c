#include "ts.h"
#include <string.h>
#include "archivos.h"

void initTs(FILE *fp)
{
    fprintf(fp, "%-35s %-20s %-45s %-20s", "NAME", "TYPE", "VALUE", "LENGTH");
}

void insertInTs(char *text, char *type, char *value, char *length)
{
	if (searchTs(text) == 0)
	{
		saveTs(text,type,value,length);
	}
}

void saveTs(char *text, char *type, char *value, char *length)
{
    FILE *fp = fopen("ts.txt", READ_FILE);
    if (!fp)
    {
        fp = fopen("ts.txt", APPEND_FILE);
        initTs(fp);
        fprintf(fp, "\n%-35s %-20s %-45s %-20s", text, type, value, length);
        fclose(fp);
    }
    else
    {
        fp = fopen("ts.txt", APPEND_FILE);
        fprintf(fp, "\n%-35s %-20s %-45s %-20s", text, type, value, length);
        fclose(fp);
    }
}

int searchTs(char *text){
	
	char linea[1000],word[100];
	
	FILE *fp = fopen("ts.txt", READ_FILE);
    if(fp!= NULL) 
	{	
		while(fgets(linea,sizeof(linea),fp))
		{
			sscanf(linea, "%s", word);
			if(strcmp(word,text)==0){
				fclose(fp);
				return 1;
			}
		}
	}
	fclose(fp);
	return 0;
}

int getType(char *text){
	
	char linea[1000],word[100], type[100],value[100],length[100];
	
	FILE *fp = fopen("ts.txt", READ_FILE);
    if(fp!= NULL) 
	{	
		
		while(fgets(linea,sizeof(linea),fp))
		{
			strcpy(type,"");
			strcpy(word,"");
			sscanf(linea, "%s %s", word, type);
			
			if(strcmp(word,text)==0){
				
				if(strcmp(type,TYPE_INTEGER_TS)==0 || strcmp(type,TYPE_CONST_INT_TS)==0){ 

					return 1;
				}
				if(strcmp(type,TYPE_FLOAT_TS)==0 || strcmp(type,TYPE_CONST_FLOAT_TS)==0){ 

					return 2;
				}
				if(strcmp(type,TYPE_STRING_TS)==0 || strcmp(type,TYPE_CONST_STRING_TS)==0){ 

					return 3;
				}

			}
		}
	}
	fclose(fp);
	return 0;
}


int modifyTypeTs(char *name, char *type){
	
	char linea[124], lineaName[36];
	int esLineaEncabezado = 0;

	FILE *fp = fopen("ts.txt", READ_FILE);
	FILE *fpTemp = fopen("temp_ts.txt", APPEND_FILE);
    if(fp!= NULL) 
	{	
		while(fgets(linea,124,fp))
		{
			if(esLineaEncabezado == 0) {
				esLineaEncabezado = 1;
				fprintf(fpTemp, "%s", linea);
			} else {
				strncpy(lineaName, &linea[0], 35);
				lineaName[35] = '\0';
				if(strcmp(trim(lineaName, NULL), name) == 0) {
					fprintf(fpTemp, "%-35s %-20s %-45s %-20s", trim(lineaName, NULL), type, "", "");
				} else {
					fprintf(fpTemp, "%s", linea);
				}
			}

		}
	}


	fclose(fp);
	fclose(fpTemp);
	
	char lineaAux[125];
	
	FILE *fpDestino = fopen("ts.txt", "w+");
	FILE *fpOrigen = fopen("temp_ts.txt", "r+");

	while (fgets(lineaAux, sizeof(lineaAux), fpOrigen))
	{
		fprintf(fpDestino, "%s", lineaAux);
	}


	fclose(fpDestino);
	fclose(fpOrigen);
	remove("temp_ts.txt");

	return 1;
}