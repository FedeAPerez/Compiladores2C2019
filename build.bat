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
echo "PRUEBA - OK"
type .\tests\prueba-tercetos-if.txt | .\build\Primera.exe
pause
del y.tab.c
del y.tab.h
del y.output
del Primera.exe