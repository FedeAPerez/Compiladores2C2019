#include "stdio.h"

#define FILE_NAME "ts.txt"
#define READ_FILE "r"
#define APPEND_FILE "a"

void initTs(FILE *);
void saveTs(char *, char *, char *, char *);

void initTs(FILE *fp)
{
    fprintf(fp, "%-35s %-20s %-45s %-20s", "NAME", "TYPE", "VALUE", "LENGTH");
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