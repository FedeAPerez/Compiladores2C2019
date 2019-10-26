del y.tab.c
del y.tab.h
del y.output
del Segunda.exe
mkdir build
bison -dy Sintactico.y
pause
flex Lexico.l
pause
c:\MinGW\bin\gcc.exe lex.yy.c y.tab.c -o .\build\Segunda.exe
pause
del ts.txt
del intermedia.txt
del status.txt
echo "PRUEBA - OK TERCETOS ASIG MULT"
type .\tests\prueba-tercetos-if.txt | .\build\Segunda.exe
pause
echo "PRUEBA - OK"
type .\tests\prueba.txt | .\build\Segunda.exe
pause
echo "PRUEBA PARENTESIS - OK"
type .\tests\parentesis.txt | .\build\Segunda.exe
pause
echo "PRUEBA STRING RECHAZADA - ERROR"
type .\tests\string.rejected.txt | .\build\Segunda.exe
pause
echo "PRUEBA ENTERO RECHAZADO - ERROR"
type .\tests\int.rejected.txt | .\build\Segunda.exe
pause
echo "PRUEBA MOD/DIV - OK"
type .\tests\mod-div.txt | .\build\Segunda.exe
pause
echo "PRUEBA REPEAT - OK"
type .\tests\repeat.txt | .\build\Segunda.exe
pause
