%{
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <unordered_map>
#include "parser.tab.hpp"

extern "C" {
    int yylex();
}

int currentLine = 1;
extern std::unordered_map<std::string, int> symbolTable;
%}

%option noyywrap

IDENTIFIER        [a-zA-Z][a-zA-Z0-9_]*
INT_CONST         [0-9]+
FLOAT_CONST       [0-9]+\.[0-9]+
STRING_CONST      \"[a-zA-Z0-9_]*\"
CHAR_CONST        \'[a-zA-Z0-9_]\'

%%

"int"       { /*printf("Reserved word: %s\n", yytext);*/ return INT; }
"float"     { /*printf("Reserved word: %s\n", yytext);*/ return FLOAT; }
"char"      { return CHAR; } 
"string"    { return STRING; }
"if"        { /*printf("Reserved word: %s\n", yytext);*/ return IF; }
"else"      { /*printf("Reserved word: %s\n", yytext);*/ return ELSE; }
"read"      { /*printf("Reserved word: %s\n", yytext);*/ return READ; }
"while"     { /*printf("Reserved word: %s\n", yytext);*/ return WHILE; }
"print"     { /*printf("Reserved word: %s\n", yytext);*/ return PRINT; }

"+"         { /*printf("Operator: %s\n", yytext);*/ return PLUS; }
"-"         { /*printf("Operator: %s\n", yytext);*/ return MINUS; }
"*"         { /*printf("Operator: %s\n", yytext);*/ return MUL; }
"/"         { /*printf("Operator: %s\n", yytext);*/ return DIVISION; }

"("         { /*printf("Separator: %s\n", yytext);*/ return LEFT_ROUND_BRACKET; }
")"         { /*printf("Separator: %s\n", yytext);*/ return RIGHT_ROUND_BRACKET; }
";"         { /*printf("Separator: %s\n", yytext);*/ return SEMICOLON; }
"{"         { /*printf("Separator: %s\n", yytext);*/ return LEFT_CURLY_BRACKET; }
"}"         { /*printf("Separator: %s\n", yytext);*/ return RIGHT_CURLY_BRACKET; }

"="         { return ASSIGN; }
">"         { return GREATER_THAN; }
"<"         { return LESS_THAN; }

{IDENTIFIER} {
    yylval.strval = new std::string(yytext);
    return IDENTIFIER;
}
{INT_CONST} {
    yylval.intval = atoi(yytext);

    return INT_CONST;
}

{FLOAT_CONST} {
    yylval.floatval = atof(yytext);
    return FLOAT_CONST;
}
{STRING_CONST} {
    yylval.strval = new std::string(yytext);
    return STRING_CONST;
}
{CHAR_CONST} {
    yylval.strval = new std::string(yytext);
    return CHAR_CONST;
}

[ \t]+      {}
[\n]+       { currentLine++; }

%%