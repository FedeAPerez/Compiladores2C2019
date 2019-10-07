mkdir build
bison -dy Sintactico.y
pause
flex Lexico.l
pause
gcc.exe lex.yy.c y.tab.c -o .\build\Primera.exe
pause


echo "PRUEBA TERCETOS A-MULTI - OK"
type .\tests\prueba-tercetos.txt | .\build\Primera.exe
del y.tab.c
del y.tab.h
del y.output
del Primera.exe