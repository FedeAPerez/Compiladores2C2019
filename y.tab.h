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
     INTEGER = 260,
     FLOAT = 261,
     IF = 262,
     REPEAT = 263,
     ID = 264,
     OP_ASIG = 265,
     CONST_STRING = 266,
     CONST_INT = 267,
     OP_MULTIPLICACION = 268,
     OP_SUMA = 269,
     OP_RESTA = 270,
     OP_DIVISION = 271,
     PA = 272,
     PC = 273,
     CA = 274,
     CC = 275,
     COMA = 276,
     DOS_PUNTOS = 277
   };
#endif
/* Tokens.  */
#define VAR 258
#define ENDVAR 259
#define INTEGER 260
#define FLOAT 261
#define IF 262
#define REPEAT 263
#define ID 264
#define OP_ASIG 265
#define CONST_STRING 266
#define CONST_INT 267
#define OP_MULTIPLICACION 268
#define OP_SUMA 269
#define OP_RESTA 270
#define OP_DIVISION 271
#define PA 272
#define PC 273
#define CA 274
#define CC 275
#define COMA 276
#define DOS_PUNTOS 277




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 27 "Sintactico.y"
{
        int intValue;
        char *stringValue;
}
/* Line 1529 of yacc.c.  */
#line 98 "y.tab.h"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

