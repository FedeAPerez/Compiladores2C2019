sh clean.sh
bison -yd Sintactico.y
flex Lexico.l
gcc y.tab.c lex.yy.c -ll -o ./build/Ejecutable
echo "PRUEBA - OK"
cat tests/prueba.txt | ./build/Ejecutable
echo "PRUEBA PARENTESIS - OK"
cat tests/parentesis.txt | ./build/Ejecutable
echo "PRUEBA STRING RECHAZADA - ERROR"
cat tests/string.rejected.txt | ./build/Ejecutable
echo "PRUEBA ENTERO RECHAZADO - ERROR"
cat tests/int.rejected.txt | ./build/Ejecutable
echo "PRUEBA MOD/DIV - OK"
cat tests/mod-div.txt | ./build/Ejecutable