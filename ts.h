#include "stdio.h"

#define READ_FILE "r"
#define APPEND_FILE "a"

void initTs(FILE *);
int searchTs(char *);
void saveTs(char *, char *, char *, char *);
void insertInTs(char *text, char *type, char *value, char *length);
int modifyTypeTs(char *, char *);