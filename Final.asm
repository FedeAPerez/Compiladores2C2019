include macros2.asm
include number.asm
.MODEL SMALL 
.386
.STACK 200h 

.DATA
result dd ?
R dd ?
pepe1 dd 0
pepe2 dd 0
pepe3 dd 0
pepe4 dd 0
pepe5 dd 0
_10 dd 10
_2 dd 2
_100 dd 100
_6 dd 6
_1 dd 1
_3 dd 3
_4 dd 4
_70 dd 70
_5 dd 5
auxMod0 dd 0
auxMod1 dd 0
aux dd 0
_9 dd 9
.CODE 
	 MOV AX,@DATA 	;inicializa el segmento de datos
	 MOV DS,AX 
	 FINIT 


FILD _10
FIMUL _2
FISTP pepe1
FFREE ST(0)
FILD _100
FISTP pepe2
FFREE ST(0)
FILD _6
FISTP pepe3
FFREE ST(0)
FILD _1
FIADD _2
FISTP pepe4
FFREE ST(0)
FILD _3
FILD pepe1
 FCOMP
 FSTSW AX 
 SAHF 
JNE ET_24
FILD _3
FILD pepe2
 FCOMP
 FSTSW AX 
 SAHF 
JNE ET_40
 ET_24:
FILD _4
FISTP pepe2
FFREE ST(0)
FILD _2
FILD pepe1
 FCOMP
 FSTSW AX 
 SAHF 
JNE ET_38
FILD pepe4
FIMUL pepe3
FISTP pepe1
FFREE ST(0)
JMP ET_38
 ET_38:
JMP ET_44
 ET_40:
FILD _10
FISTP pepe4
FFREE ST(0)
 ET_44:
 ET_45:
FILD pepe2
FISUB _1
FISTP pepe2
FFREE ST(0)
FILD pepe4
FIMUL _10
FISTP pepe1
FFREE ST(0)
FILD _3
FILD pepe2
 FCOMP
 FSTSW AX 
 SAHF 
JE ET_64
FILD _100
FILD pepe1
 FCOMP
 FSTSW AX 
 SAHF 
JBE ET_45
 ET_64:
FILD _4
FILD pepe3
 FCOMP
 FSTSW AX 
 SAHF 
JB ET_79
FILD _3
FILD pepe2
 FCOMP
 FSTSW AX 
 SAHF 
JA ET_79
FILD pepe1
FIDIV pepe4
FISTP pepe2
FFREE ST(0)
JMP ET_83
 ET_79:
FILD _10
FISTP pepe4
FFREE ST(0)
 ET_83:
 ET_84:
FILD pepe3
FISUB _1
FISTP pepe3
FFREE ST(0)
FILD pepe1
FIADD _70
FISTP pepe1
FFREE ST(0)
FILD _5
FILD pepe3
 FCOMP
 FSTSW AX 
 SAHF 
JNE ET_84
FILD _100
FILD pepe1
 FCOMP
 FSTSW AX 
 SAHF 
JNE ET_84
 ET_103:
FILD _4
FILD pepe3
 FCOMP
 FSTSW AX 
 SAHF 
JE ET_123
FILD _100
FISTP auxMod0
FFREE ST(0)
FILD _3
FISTP auxMod1
FFREE ST(0)
FILD auxMod0
FIDIV auxMod1
FISTP aux
FFREE ST(0)
FILD auxMod1
FIMUL aux
FISTP aux
FFREE ST(0)
FILD auxMod0
FISUB aux
FISTP pepe5
FFREE ST(0)
JMP ET_129
 ET_123:
FILD _9
FIDIV _3
FISTP pepe4
FFREE ST(0)
 ET_129:
DisplayInteger pepe1,2
newLine 1
DisplayInteger pepe2,2
newLine 1
DisplayInteger pepe3,2
newLine 1
DisplayInteger pepe4,2
newLine 1
DisplayInteger pepe5,2
newLine 1
 mov ah, 1 ; pausa, espera que oprima una tecla 
int 21h ; AH=1 es el servicio de lectura 
  MOV AX, 4C00h ; Sale del Dos 
INT 21h ; Enviamos la interripcion 21h 
  END ; final del archivo. 
