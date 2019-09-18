sh clean.sh
bison --verbose -yd Sintactico.y
flex Lexico.l
gcc y.tab.c lex.yy.c -ll -o ./build/Ejecutable
echo "PRUEBA"
cat tests/prueba-tercetos.txt | ./build/Ejecutable