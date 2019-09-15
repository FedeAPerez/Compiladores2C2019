rm lex.yy.c
rm y.tab.c
rm y.tab.h
rm Ejecutable
bison -yd Sintactico.y
flex Lexico.l
gcc y.tab.c lex.yy.c -ll -o ./build/Ejecutable
echo "PRUEBA"
cat tests/prueba.txt | ./build/Ejecutable
echo "PRUEBA PARENTESIS"
cat tests/parentesis.txt | ./build/Ejecutable
echo "PRUEBA STRING RECHAZADA"
cat tests/string.rejected.txt | ./build/Ejecutable
echo "PRUEBA ENTERO RECHAZADO"
cat tests/int.rejected.txt | ./build/Ejecutable