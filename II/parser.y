%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parser.tab.h"

extern int yylex();
extern int currentLine;
void yyerror(const char *s);
%}

%union {
    int intval;
    float floatval;
    char* strval;
}

%token <intval> NUMBER_CONST
%token <strval> STRING_CONST IDENTIFIER
%token <intval> INT FLOAT
%token <strval> CHAR_CONST
%token PLUS MINUS MUL DIVISION
%token LEFT_ROUND_BRACKET RIGHT_ROUND_BRACKET LEFT_CURLY_BRACKET RIGHT_CURLY_BRACKET SEMICOLON
%token IF READ PRINT ASSIGN
%token ERROR
%token DECLARATION_ERROR
%token GREATER_THAN LESS_THAN

%type <intval> expression term factor

%left PLUS MINUS
%left MUL DIVISION
%left GREATER_THAN LESS_THAN
%right ASSIGN

%define parse.error verbose

%%

program:
    statements
    ;

statements:
    statement
    | statements statement
    ;

statement:
    declaration
    | assignment
    | print_stmt
    | read_stmt
    | if_stmt
    ;

declaration:
    type IDENTIFIER SEMICOLON
    | type IDENTIFIER ASSIGN expression SEMICOLON
    ;

type:
    INT
    | FLOAT
    ;

assignment:
    IDENTIFIER ASSIGN expression SEMICOLON
    ;

print_stmt:
    PRINT expression SEMICOLON
    ;

read_stmt:
    READ IDENTIFIER SEMICOLON
    ;

if_stmt:
    IF LEFT_ROUND_BRACKET expression RIGHT_ROUND_BRACKET LEFT_CURLY_BRACKET statements RIGHT_CURLY_BRACKET
    ;

expression:
    expression PLUS term { $$ = $1 + $3; }
    | expression MINUS term { $$ = $1 - $3; }
    | expression GREATER_THAN term { $$ = $1 > $3; }
    | expression LESS_THAN term { $$ = $1 < $3; }
    | term
    ;

term:
    term MUL factor { $$ = $1 * $3; }
    | term DIVISION factor { $$ = $1 / $3; }
    | factor
    ;

factor:
    NUMBER_CONST { $$ = $1; }
    | IDENTIFIER { $$ = 0; }
    | STRING_CONST { printf("String: %s\n", $1); $$ = 0; }
    | CHAR_CONST { printf("Character: %s\n", $1); $$ = 0; }
    | LEFT_ROUND_BRACKET expression RIGHT_ROUND_BRACKET { $$ = $2; }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "%s at line %d\n", s, currentLine);
}

int main(void) {
    return yyparse();
}
