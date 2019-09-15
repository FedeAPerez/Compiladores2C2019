bison -dy Sintactico.y
pause
flex Lexico.l
pause
c:\MinGW\bin\gcc.exe lex.yy.c y.tab.c -o .\Primera.exe
pause
type .\tests\mod-div.txt | .\Primera.exe
pause
del y.tab.c
del y.tab.h
del y.output
del ts.txt
del Primera.exe