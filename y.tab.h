
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     VAR = 258,
     ENDVAR = 259,
     TIPO_INTEGER = 260,
     TIPO_FLOAT = 261,
     TIPO_STRING = 262,
     ID = 263,
     IF = 264,
     THEN = 265,
     ELSE = 266,
     ENDIF = 267,
     AND = 268,
     OR = 269,
     NOT = 270,
     REPEAT = 271,
     UNTIL = 272,
     OP_ASIG = 273,
     CONST_FLOAT = 274,
     CONST_INT = 275,
     CONST_STRING = 276,
     OP_MULTIPLICACION = 277,
     OP_SUMA = 278,
     OP_RESTA = 279,
     OP_DIVISION = 280,
     PARENTESIS_ABRE = 281,
     PARENTESIS_CIERRA = 282,
     CORCHETE_ABRE = 283,
     CORCHETE_CIERRA = 284,
     PRINT = 285,
     READ = 286,
     OP_MENOR = 287,
     OP_MENOR_IGUAL = 288,
     OP_MAYOR = 289,
     OP_MAYOR_IGUAL = 290,
     OP_IGUAL = 291,
     OP_DISTINTO = 292,
     PYC = 293,
     COMA = 294,
     DOS_PUNTOS = 295
   };
#endif
/* Tokens.  */
#define VAR 258
#define ENDVAR 259
#define TIPO_INTEGER 260
#define TIPO_FLOAT 261
#define TIPO_STRING 262
#define ID 263
#define IF 264
#define THEN 265
#define ELSE 266
#define ENDIF 267
#define AND 268
#define OR 269
#define NOT 270
#define REPEAT 271
#define UNTIL 272
#define OP_ASIG 273
#define CONST_FLOAT 274
#define CONST_INT 275
#define CONST_STRING 276
#define OP_MULTIPLICACION 277
#define OP_SUMA 278
#define OP_RESTA 279
#define OP_DIVISION 280
#define PARENTESIS_ABRE 281
#define PARENTESIS_CIERRA 282
#define CORCHETE_ABRE 283
#define CORCHETE_CIERRA 284
#define PRINT 285
#define READ 286
#define OP_MENOR 287
#define OP_MENOR_IGUAL 288
#define OP_MAYOR 289
#define OP_MAYOR_IGUAL 290
#define OP_IGUAL 291
#define OP_DISTINTO 292
#define PYC 293
#define COMA 294
#define DOS_PUNTOS 295




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 19 "Sintactico.y"

        int intValue;
        float floatValue;
        char *stringValue;



/* Line 1676 of yacc.c  */
#line 140 "y.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


