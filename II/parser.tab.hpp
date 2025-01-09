/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

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

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_PARSER_TAB_HPP_INCLUDED
# define YY_YY_PARSER_TAB_HPP_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    INT_CONST = 258,               /* INT_CONST  */
    INT = 259,                     /* INT  */
    FLOAT_CONST = 260,             /* FLOAT_CONST  */
    FLOAT = 261,                   /* FLOAT  */
    STRING_CONST = 262,            /* STRING_CONST  */
    IDENTIFIER = 263,              /* IDENTIFIER  */
    CHAR = 264,                    /* CHAR  */
    CHAR_CONST = 265,              /* CHAR_CONST  */
    STRING = 266,                  /* STRING  */
    PLUS = 267,                    /* PLUS  */
    MINUS = 268,                   /* MINUS  */
    MUL = 269,                     /* MUL  */
    DIVISION = 270,                /* DIVISION  */
    LEFT_ROUND_BRACKET = 271,      /* LEFT_ROUND_BRACKET  */
    RIGHT_ROUND_BRACKET = 272,     /* RIGHT_ROUND_BRACKET  */
    LEFT_CURLY_BRACKET = 273,      /* LEFT_CURLY_BRACKET  */
    RIGHT_CURLY_BRACKET = 274,     /* RIGHT_CURLY_BRACKET  */
    SEMICOLON = 275,               /* SEMICOLON  */
    IF = 276,                      /* IF  */
    ELSE = 277,                    /* ELSE  */
    READ = 278,                    /* READ  */
    PRINT = 279,                   /* PRINT  */
    ASSIGN = 280,                  /* ASSIGN  */
    WHILE = 281,                   /* WHILE  */
    ERROR = 282,                   /* ERROR  */
    GREATER_THAN = 283,            /* GREATER_THAN  */
    LESS_THAN = 284,               /* LESS_THAN  */
    IF_THEN = 285                  /* IF_THEN  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 113 "parser.y"

    int intval;
    float floatval;
    std::string* strval;
    char charval;
    bool boolval;

#line 102 "parser.tab.hpp"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_PARSER_TAB_HPP_INCLUDED  */
