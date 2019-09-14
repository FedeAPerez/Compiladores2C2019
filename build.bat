C:\GnuWin32\bin\flex Lexico.l
pause
C:\GnuWin32\bin\bison -dyv Sintactico.y
pause
C:\TDM-GCC-64\bin\gcc.exe lex.yy.c y.tab.c -o Primera.exe
pause