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

## Status 1er Entrega

### Analizador Sintático/Léxico

- [ ] REPEAT
- [ ] IF
- [ ] Asignación Simple
- [ ] Tipo de Dato: INTEGER (16 bits)
- [ ] Tipo de Dato: FLOAT (32 bits)
- [ ] Tipo de Dato: STRING (30 caracteres)
- [ ] Variables (Reciben valor númerico de expresión)
- [ ] Comentarios
- [ ] PRINT
- [ ] READ
- [ ] Condiciones
- [ ] Sección de Declaraciones

### Temas especiales

- [ ] Asignación Múltiple
- [ ] MOD/DIV
