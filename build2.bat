mkdir build
bison -dy Sintactico.y
pause
flex Lexico.l
pause
gcc.exe terceto.c prints.c archivos.c ts.c y.tab.c lex.yy.c assembler.c -o .\build\Final.exe
pause

echo "PRUEBA TERCETOS A-MULTI - OK"
type .\tests\prueba.txt | .\build\Final.exe

pause
del ts.txt
del intermedia.txt
del status.txt
echo "PRUEBA - OK TERCETOS ASIG MULT"
type .\tests\prueba.txt | .\build\Final.exe
pause
