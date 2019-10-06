mkdir build
C:\GnuWin32\bin\bison -dy Sintactico.y
pause
C:\GnuWin32\bin\flex Lexico.l
pause
C:\TDM-GCC-64\bin\gcc.exe lex.yy.c y.tab.c -o .\build\Primera.exe
pause
del ts.txt
del intermedia.txt
del status.txt
echo "PRUEBA - OK TERCETOS ASIG MULT"
type .\tests\prueba-tercetos-if.txt | .\build\Primera.exe
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
type .\tests\prueba-tercetos-if.txt | .\build\Primera.exe
del y.tab.c
del y.tab.h
del y.output
del Primera.exe