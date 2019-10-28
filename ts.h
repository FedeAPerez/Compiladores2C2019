#include "stdio.h"

#define FILE_NAME "ts.txt"
#define READ_FILE "r"
#define APPEND_FILE "a"

void initTs(FILE *);
int searchTs(char *);
void saveTs(char *, char *, char *, char *);
void insertInTs(char *text, char *type, char *value, char *length);

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
    FILE *fp = fopen(FILE_NAME, READ_FILE);
    if (!fp)
    {
        fp = fopen(FILE_NAME, APPEND_FILE);
        initTs(fp);
        fprintf(fp, "\n%-35s %-20s %-45s %-20s", text, type, value, length);
        fclose(fp);
    }
    else
    {
        fp = fopen(FILE_NAME, APPEND_FILE);
        fprintf(fp, "\n%-35s %-20s %-45s %-20s", text, type, value, length);
        fclose(fp);
    }
}

int searchTs(char *text){
	
	char linea[1000],word[100];
	
	FILE *fp = fopen(FILE_NAME, READ_FILE);
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