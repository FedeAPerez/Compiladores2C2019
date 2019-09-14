# Compiladores2C2019

## Instalación

Secuencia de comandos para ejecutar

```shell
bison -yd Sintactico.y
flex Lexico.l
gcc y.tab.c lex.yy.c -ll -o Ejecutable
```

Una vez instalado pueden ejecutar

```shell
sh build
```

Para ver el output completo de bison

```shell
sh build:debug
```

Ese comando ejecuta los casos de prueba dentro de la carpeta `tests`

## Implementación

## Status
