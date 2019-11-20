#include "stdio.h"

#define READ_FILE "r"
#define APPEND_FILE "a"
#define TYPE_INTEGER_TS "INTEGER"
#define TYPE_CONST_INT_TS "CONST_INT"
#define TYPE_FLOAT_TS "FLOAT"
#define TYPE_CONST_FLOAT_TS "CONST_FLOAT"
#define TYPE_CONST_STRING_TS "CONST_STRING"
#define TYPE_STRING_TS "STRING"


void initTs(FILE *);
int searchTs(char *);
void saveTs(char *, char *, char *, char *);
void insertInTs(char *text, char *type, char *value, char *length);
int modifyTypeTs(char *, char *);
int getType(char *text);