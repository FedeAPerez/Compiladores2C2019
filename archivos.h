#include "stdio.h"
#include "stdlib.h"
#include <string.h>
#define FILE_NAME_TERCETOS "intermedia.txt"
#define FILE_NAME_ASS "Final.asm"
#define FILE_NAME_TS "ts.txt"
#define FILE_NAME_TEMP_TS "temp_ts.txt"
#define FILE_SIZE_TS 124
#define FILE_NAME_TERCETOS_COPIA "intermedia_copia.txt"

#define READ_FILE_TERCETOS_PLUS "r+"
#define WRITE_FILE_TERCETOS "w+"

#define FILE_MODE_READ "r"
#define FILE_MODE_APPEND "a"
void clean(void);
int ActualizarArchivo(int posicion, int dato);
char *replace_str(char *str, char *orig, char *rep);
char *ltrim(char *, const char *);
char *rtrim(char *, const char *);
char *trim(char *, const char *);