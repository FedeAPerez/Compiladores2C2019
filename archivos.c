#include "archivos.h"




char *ltrim(char *str, const char *seps)
{
    size_t totrim;
    if (seps == NULL) {
        seps = "\t\n\v\f\r ";
    }
    totrim = strspn(str, seps);
    if (totrim > 0) {
        size_t len = strlen(str);
        if (totrim == len) {
            str[0] = '\0';
        }
        else {
            memmove(str, str + totrim, len + 1 - totrim);
        }
    }
    return str;
}

char *rtrim(char *str, const char *seps)
{
    int i;
    if (seps == NULL) {
        seps = "\t\n\v\f\r ";
    }
    i = strlen(str) - 1;
    while (i >= 0 && strchr(seps, str[i]) != NULL) {
        str[i] = '\0';
        i--;
    }
    return str;
}

char *trim(char *str, const char *seps)
{
    return ltrim(rtrim(str, seps), seps);
}

void clean(void)
{
	remove(FILE_NAME_TERCETOS);
	remove(FILE_NAME_ASS);
	remove(FILE_NAME_TS);
}

int ActualizarArchivo(int posicion, int dato)
{
	char aux[5];
	char linea[500];
	char cadena[500];
	int cont = 0;
	int i;

	FILE *fp = fopen(FILE_NAME_TERCETOS, READ_FILE_TERCETOS_PLUS);
	if (!fp)
	{
		printf("Error al querer abrir el archivo!!\n");
		return 0;
	}

	FILE *fp1 = fopen(FILE_NAME_TERCETOS_COPIA, WRITE_FILE_TERCETOS);
	if (!fp1)
	{
		printf("Error al querer abrir el archivo 1!!\n");
		return 0;
	}

	while (fgets(linea, sizeof(linea), fp))
	{
		// esto es medio peligroso, quizás deberíamos hacerlo por el [] que se marca
		// al inicio del terceto
		if (cont == posicion)
		{

			sprintf(aux, "[%d]", dato);
			strcpy(cadena, replace_str(linea, "#", aux));
			fprintf(fp1, "%s", cadena);
		}
		else
		{
			fprintf(fp1, "%s", linea);
		}
		cont++;
	}

	fclose(fp);
	fclose(fp1);

	//Sobreescribir archivo
	fp = fopen(FILE_NAME_TERCETOS, "w+");
	if (!fp)
	{
		printf("Error al querer abrir el archivo!!\n");
		return 0;
	}

	fp1 = fopen(FILE_NAME_TERCETOS_COPIA, READ_FILE_TERCETOS_PLUS);
	if (!fp1)
	{
		printf("Error al querer abrir el archivo 1!!\n");
		return 0;
	}

	while (fgets(linea, sizeof(linea), fp1))
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

	if (!(p = strstr(str, orig)))
		return str;

	buffer = (char *)malloc(strlen(str) + strlen(rep) - strlen(orig) + 1);

	strncpy(buffer, str, p - str);

	sprintf(buffer + (p - str), "%s%s", rep, p + strlen(orig));

	return replace_str(buffer, orig, rep);
}
