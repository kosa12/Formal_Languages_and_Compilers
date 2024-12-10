%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parser.tab.h"
int currentLine = 1;
%}

%option noyywrap

IDENTIFIER        [a-zA-Z][a-zA-Z0-9_]*
NUMBER_CONST      [0-9]+(\.[0-9]+)?
STRING_CONST      \"[a-zA-Z0-9_]*\"
CHAR_CONST        \'[a-zA-Z0-9_]\'

%%

"int"       {printf("Reserved word: %s\n", yytext); return INT;}
"float"     {printf("Reserved word: %s\n", yytext); return FLOAT;}
"if"        {printf("Reserved word: %s\n", yytext); return IF;}
"else"      {printf("Reserved word: %s\n", yytext); return ELSE;}
"read"      {printf("Reserved word: %s\n", yytext); return READ;}
"print"     {printf("Reserved word: %s\n", yytext); return PRINT;}

"+"         {printf("Operator: %s\n", yytext); return PLUS;}
"-"         {printf("Operator: %s\n", yytext); return MINUS;}
"*"         {printf("Operator: %s\n", yytext); return MUL;}
"/"         {printf("Operator: %s\n", yytext); return DIVISION;}

"("         {printf("Separator: %s\n", yytext); return LEFT_ROUND_BRACKET;}
")"         {printf("Separator: %s\n", yytext); return RIGHT_ROUND_BRACKET;}
";"         {printf("Separator: %s\n", yytext); return SEMICOLON;}
"{"         {printf("Separator: %s\n", yytext); return LEFT_CURLY_BRACKET;}
"}"         {printf("Separator: %s\n", yytext); return RIGHT_CURLY_BRACKET;}

"="                   { return ASSIGN; }
">"                   { return GREATER_THAN; }
"<"                   { return LESS_THAN; }

{IDENTIFIER} {printf("Identifier: %s\n", yytext); return IDENTIFIER;}
{NUMBER_CONST} {printf("Number: %s\n", yytext); return NUMBER_CONST;}
{STRING_CONST} {printf("String: %s\n", yytext); return STRING_CONST;}
{CHAR_CONST} {printf("Character: %s\n", yytext); return CHAR_CONST;}

[ \t]+      {}
[\n]+       { currentLine++; }

[0-9_][a-zA-Z0-9_]*  {printf("Illegal identifier at line %d\n", currentLine); return -1;}
[+-]0             {printf("Illegal numeric constant at line %d\n", currentLine); return -1;}
[+-]?[0][0-9]*([.][0-9]*)? {printf("Illegal numeric constant at line %d\n", currentLine); return -1;}
['][a-zA-Z0-9_]{2,}[']   {printf("Illegal character constant at line %d\n", currentLine); return -1;}
"[a-zA-Z0-9_]+|[a-zA-Z0-9_]+" {printf("Illegal string constant at line %d\n", currentLine); return -1;}

%%
