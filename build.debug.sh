sh clean.sh
bison --verbose -ygd Sintactico.y
flex Lexico.l
gcc y.tab.c lex.yy.c -ll -o ./build/Ejecutable
echo "PRUEBA"
cat tests/rechaza-float-32.txt | ./build/Ejecutable