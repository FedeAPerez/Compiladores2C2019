#include "stdio.h"

#define FILE_NAME "ts.txt"
#define READ "r"
#define APPEND "a"

void initTs(FILE *);
void saveTs(char *, char *, char *, char *);

void initTs(FILE *fp)
{
    fprintf(fp, "%-35s %-20s %-45s %-20s", "NAME", "TYPE", "VALUE", "LENGTH");
}

void saveTs(char *text, char *type, char *value, char *length)
{
    FILE *fp = fopen(FILE_NAME, READ);
    if (!fp)
    {
        fp = fopen(FILE_NAME, APPEND);
        initTs(fp);
        fprintf(fp, "\n%-35s %-20s %-45s %-20s", text, type, value, length);
        fclose(fp);
    }
    else
    {
        fp = fopen(FILE_NAME, APPEND);
        fprintf(fp, "\n%-35s %-20s %-45s %-20s", text, type, value, length);
        fclose(fp);
    }
}