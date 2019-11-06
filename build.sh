sh clean.sh
bison -yd Sintactico.y
flex Lexico.l
gcc  terceto.c prints.c archivos.c ts.c y.tab.c lex.yy.c assembler.c -ll -o ./build/Ejecutable
echo "PRUEBA - OK"
cat tests/prueba.txt | ./build/Ejecutable
echo "PRUEBA PARENTESIS - OK"
cat tests/parentesis.txt | ./build/Ejecutable
echo "PRUEBA STRING RECHAZADA - ERROR"
cat tests/rechaza-string.txt | ./build/Ejecutable
echo "PRUEBA ENTERO RECHAZADO - ERROR"
cat tests/int.rejected.txt | ./build/Ejecutable
echo "PRUEBA CARACTER NO SOPORTADO - ERROR"
cat tests/badchar.txt | ./build/Ejecutable
echo "PRUEBA REPEAT - OK"
cat tests/repeat.txt | ./build/Ejecutable
echo "PRUEBA MATHPROGRAM - OK"
cat tests/mathprogram.txt | ./build/Ejecutable