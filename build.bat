bison -dy Sintactico.y
pause
flex Lexico.l
pause
c:\MinGW\bin\gcc.exe lex.yy.c y.tab.c -o .\build\Primera.exe
pause
echo "PRUEBA - OK"
type .\tests\prueba.txt | .\build\Primera.exe
pause
echo "PRUEBA PARENTESIS - OK"
type .\tests\parentesis.txt | .\build\Primera.exe
pause
echo "PRUEBA STRING RECHAZADA - ERROR"
type .\tests\string.rejected.txt | .\build\Primera.exe
pause
echo "PRUEBA ENTERO RECHAZADO - ERROR"
type .\tests\int.rejected.txt | .\build\Primera.exe
pause
echo "PRUEBA MOD/DIV - OK"
type .\tests\mod-div.txt | .\build\Primera.exe
pause
echo "PRUEBA REPEAT - OK"
type .\tests\repeat.txt | .\build\Primera.exe
pause
del y.tab.c
del y.tab.h
del y.output
del ts.txt
del Primera.exe