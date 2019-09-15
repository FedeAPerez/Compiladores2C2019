/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

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
     IF = 262,
     THEN = 263,
     ELSE = 264,
     ENDIF = 265,
     OP_MENOR = 266,
     OP_MENOR_IGUAL = 267,
     OP_MAYOR = 268,
     OP_MAYOR_IGUAL = 269,
     OP_IGUAL = 270,
     OP_DISTINTO = 271,
     AND = 272,
     NOT = 273,
     OR = 274,
     REPEAT = 275,
     UNTIL = 276,
     PRINT = 277,
     READ = 278,
     MOD = 279,
     DIV = 280,
     ID = 281,
     OP_ASIG = 282,
     CONST_STRING = 283,
     CONST_INT = 284,
     CONST_FLOAT = 285,
     OP_MULTIPLICACION = 286,
     OP_SUMA = 287,
     OP_RESTA = 288,
     OP_DIVISION = 289,
     PARENTESIS_ABRE = 290,
     PARENTESIS_CIERRA = 291,
     CORCHETE_ABRE = 292,
     CORCHETE_CIERRA = 293,
     COMA = 294,
     DOS_PUNTOS = 295
   };
#endif
/* Tokens.  */
#define VAR 258
#define ENDVAR 259
#define TIPO_INTEGER 260
#define TIPO_FLOAT 261
#define IF 262
#define THEN 263
#define ELSE 264
#define ENDIF 265
#define OP_MENOR 266
#define OP_MENOR_IGUAL 267
#define OP_MAYOR 268
#define OP_MAYOR_IGUAL 269
#define OP_IGUAL 270
#define OP_DISTINTO 271
#define AND 272
#define NOT 273
#define OR 274
#define REPEAT 275
#define UNTIL 276
#define PRINT 277
#define READ 278
#define MOD 279
#define DIV 280
#define ID 281
#define OP_ASIG 282
#define CONST_STRING 283
#define CONST_INT 284
#define CONST_FLOAT 285
#define OP_MULTIPLICACION 286
#define OP_SUMA 287
#define OP_RESTA 288
#define OP_DIVISION 289
#define PARENTESIS_ABRE 290
#define PARENTESIS_CIERRA 291
#define CORCHETE_ABRE 292
#define CORCHETE_CIERRA 293
#define COMA 294
#define DOS_PUNTOS 295




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 40 "Sintactico.y"
{
        int intValue;
        float floatValue;
        char *stringValue;
}
/* Line 1529 of yacc.c.  */
#line 135 "y.tab.h"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

