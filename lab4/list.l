%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int char_pos = 1;
%}

%%

"int"                   { printf("[row: %d, col: %d, len: %d] TYPE_INT\n", yylineno, char_pos, yyleng); char_pos += yyleng; }
"float"                 { printf("[row: %d, col: %d, len: %d] TYPE_FLOAT\n", yylineno, char_pos, yyleng); char_pos += yyleng; }
[0-9]+(\.[0-9]+)?       {
                          if (strchr(yytext, '.')) 
                              printf("[row: %d, col: %d, len: %d] FLOAT %s\n", yylineno, char_pos, yyleng, yytext); 
                          else
                              printf("[row: %d, col: %d, len: %d] INT %s\n", yylineno, char_pos, yyleng, yytext); 
                          char_pos += yyleng; 
                        }
[a-zA-Z_][a-zA-Z0-9_]*  { printf("[row: %d, col: %d, len: %d] IDENTIFIER %s\n", yylineno, char_pos, yyleng, yytext); char_pos += yyleng; }
[+\-*/=]                 { printf("[row: %d, col: %d, len: %d] OPERATOR %s\n", yylineno, char_pos, yyleng, yytext); char_pos += yyleng; }
[()]                     { printf("[row: %d, col: %d, len: %d] PARENTHESIS %s\n", yylineno, char_pos, yyleng, yytext); char_pos += yyleng; }
[ \t]+                   { char_pos += yyleng; }
\n                       { char_pos = 1; }
.                        { printf("[row: %d, col: %d, len: %d] UNKNOWN %s\n", yylineno, char_pos, yyleng, yytext); char_pos += yyleng; }

%%

int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <input_file>\n", argv[0]);
        return 1;
    }

    FILE *file = fopen(argv[1], "r");
    if (!file) {
        perror("Error: opening file failed");
        return 1;
    }

    yyin = file;
    yylex();
    fclose(file);
    return 0;
}

int yywrap() {
    return 1;
}
