mkdir build
C:\GnuWin32\bin\bison -dy Sintactico.y
pause
C:\GnuWin32\bin\flex Lexico.l
pause
C:\TDM-GCC-64\bin\gcc.exe terceto.c prints.c archivos.c ts.c y.tab.c lex.yy.c assembler.c -o .\build\Final.exe
pause
del ts.txt
del intermedia.txt
del status.txt
echo "PRUEBA - OK TERCETOS ASIG MULT"
type .\tests\prueba-completa.txt | .\build\Final.exe
pause
