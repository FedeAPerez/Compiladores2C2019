del intermedia.txt
del ts.txt
mkdir build
C:\GnuWin32\bin\bison -dy Sintactico.y
pause
C:\GnuWin32\bin\flex Lexico.l
pause
C:\TDM-GCC-64\bin\gcc.exe lex.yy.c y.tab.c -o .\build\Segunda.exe
pause
del ts.txt
del intermedia.txt
del status.txt
echo "PRUEBA - OK TERCETOS ASIG MULT"
type .\tests\prueba-tercetos-if.txt | .\build\Segunda.exe
pause
