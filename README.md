# Compiladores2C2019

GCI:
Método Especial 1:
Método Especial 2:

## Instalación

Secuencia de comandos para ejecutar

```shell
bison -yd Sintactico.y
flex Lexico.l
gcc y.tab.c lex.yy.c -ll -o Ejecutable
```

## Implementación

## Status

### Léxico

- [ ] Validación de Longitud de Strings
- [ ] Validación de Cotas INT
- [ ] Validación de Cotas FLOAT
- [ ] Error léxico: carácter inválido
- [ ] Comentarios
- [ ] Comentarios anidados

### Tabla de Símbolos

- [ ] Guardar ids en tabla de símbolos
- [ ] Guardar ctes en tabla de símbolos
- [ ] Tipo de variables/ctes en tabla de Símbolos
- [ ] Longitud de ctes en TS
- [ ] Se omiten duplicados en TS

### Analizador Sintático

- [ ] Condiciones simples
- [ ] Condiciones compuestas
- [ ] DISPLAY
- [ ] GET
- [ ] Condición con OR
- [ ] Condición con AND
- [ ] Condición con NOT
- [ ] Declaración de variables
- [ ] Declaración del mismo tipo de variable en más de una línea
- [ ] IF
- [ ] IF sin ELSE
- [ ] IF Anidado
- [ ] While
- [ ] While Anidado

### Temas especiales

- [ ] For
- [ ] Take
