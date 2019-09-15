sh clean.sh
bison --graph -yd Sintactico.y
flex Lexico.l
gcc y.tab.c lex.yy.c -ll -o ./build/Ejecutable