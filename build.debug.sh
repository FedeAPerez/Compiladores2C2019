sh clean.sh
bison --verbose -ygd Sintactico.y
flex Lexico.l
gcc  terceto.c prints.c archivos.c ts.c y.tab.c lex.yy.c assembler.c -ll -o ./build/Ejecutable
echo "PRUEBA"
cat tests/prueba-completa.txt | ./build/Ejecutable