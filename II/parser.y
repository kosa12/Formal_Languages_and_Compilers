%{
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <unordered_map>
#include <stack>
#include "parser.tab.hpp"

extern "C" int yylex();
extern int currentLine;
void yyerror(const char *s);

int shouldExecute = true;
std::stack<bool> executionStack;

struct Symbol {
    std::string type;
    union {
        int intval;
        float floatval;
        char charval;
        std::string* strval;
    } value;
};

std::unordered_map<std::string, Symbol> symbolTable;

void declareVariable(const std::string& name, const std::string& type) {
    auto it = symbolTable.find(name);
    if (it != symbolTable.end()) {
        yyerror(("Redeclaration of variable: " + name).c_str());
    } else {
        Symbol sym;
        sym.type = type;
        if (type == "int") {
            sym.value.intval = 0;
        } else if (type == "float") {
            sym.value.floatval = 0.0f;
        } else if (type == "char") {
            sym.value.charval = '\0';
        } else if (type == "string") {
            sym.value.strval = new std::string();
        }
        symbolTable[name] = sym;
    }
}

void checkVariable(const std::string& name) {
    if (symbolTable.find(name) == symbolTable.end()) {
        yyerror(("Undeclared variable: " + name).c_str());
    }
}

std::string getVariableType(const std::string& name) {
    if (symbolTable.find(name) != symbolTable.end()) {
        return symbolTable[name].type;
    }
    return "";
}

bool checkTypeCompatibility(const std::string& type1, const std::string& type2, const std::string& operation) {
    if (type1 != type2) {
        if((type1 == "int" && type2 == "float" && operation == "comparison") || (type1 == "float" && type2 == "int" && operation == "comparison")) {
            return true;
        } else {
            return false;
        }
    }
    return true;
}

std::string getExpressionType(float value) {
    if (value == static_cast<int>(value)) {
        return "int";
    } else {
        return "float";
    }
}

std::string getExpressionType(const std::string& identifier) {
    auto it = symbolTable.find(identifier);
    if (it != symbolTable.end()) {
        return it->second.type;
    } else {
        yyerror(("Undeclared variable: " + identifier).c_str());
        return "";
    }
}

void pushExecutionState(bool newState) {
    executionStack.push(shouldExecute);
    shouldExecute = newState;
}

void popExecutionState() {
    if (!executionStack.empty()) {
        shouldExecute = executionStack.top();
        executionStack.pop();
    }
}

void cleanupSymbolTable() {
    for (auto& entry : symbolTable) {
        if (entry.second.type == "string" && entry.second.value.strval != nullptr) {
            delete entry.second.value.strval;
        }
    }
}


%}

%union {
    int intval;
    float floatval;
    std::string* strval;
    char charval;
    bool boolval;
}

%token <intval> INT_CONST INT
%token <floatval> FLOAT_CONST FLOAT
%token <strval> STRING_CONST IDENTIFIER
%token <charval> CHAR
%token <strval> CHAR_CONST STRING
%token PLUS MINUS MUL DIVISION
%token LEFT_ROUND_BRACKET RIGHT_ROUND_BRACKET LEFT_CURLY_BRACKET RIGHT_CURLY_BRACKET SEMICOLON
%token IF ELSE READ PRINT ASSIGN WHILE
%token ERROR
%token GREATER_THAN LESS_THAN

%type <strval> type
%type <intval> declaration
%type <floatval> expression term factor

%left PLUS MINUS
%left MUL DIVISION
%left GREATER_THAN LESS_THAN
%right ASSIGN
%nonassoc IF
%nonassoc IF_THEN
%nonassoc ELSE

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
    | while_stmt
    ;

declaration:
    type IDENTIFIER SEMICOLON {
        declareVariable(*$2, *$1);
        delete $1;
    }
    | type IDENTIFIER ASSIGN CHAR_CONST SEMICOLON {
        declareVariable(*$2, *$1);

        std::string varName = *$2;
        std::string varType = getVariableType(varName);

        if (varType != "char") {
            yyerror(("Type mismatch: expected 'char', got " + varType).c_str());
        } else {
            symbolTable[varName].value.charval = (*$4)[0];
        }

        delete $1;
        delete $2;
        delete $4;
    }
    | type IDENTIFIER ASSIGN STRING_CONST SEMICOLON {
        declareVariable(*$2, *$1);

        std::string varName = *$2;
        std::string varType = getVariableType(varName);

        if (varType != "string") {
            yyerror(("Type mismatch: expected 'string', got " + varType).c_str());
        } else {
            symbolTable[varName].value.strval = new std::string(*$4);
        }

        delete $1;
        delete $2;
        delete $4;
    }
    | type IDENTIFIER ASSIGN expression SEMICOLON {
        declareVariable(*$2, *$1);

        std::string varName = *$2;
        std::string varType = getVariableType(varName);
        std::string exprType = getExpressionType($4);

        if (!checkTypeCompatibility(varType, exprType, "declaration")) {
            yyerror(("Type mismatch in declaration: " + varType + " and " + exprType).c_str());
        } else {
            if (varType == "int") {
                symbolTable[varName].value.intval = $4;
            } else if (varType == "float") {
                symbolTable[varName].value.floatval = $4;
            } else if (varType == "char") {
                symbolTable[varName].value.charval = $4;
            } else if (varType == "string") {
                yyerror("String assignment not yet implemented.");
            } else {
                yyerror(("Unknown type for variable: " + varName).c_str());
            }
        }

        delete $1;
    }
    | type IDENTIFIER error { yyerror("Error recovered at declaration level"); }
    ;

type:
    INT { $$ = new std::string("int"); }
    | FLOAT { $$ = new std::string("float"); }
    | CHAR { $$ = new std::string("char"); }
    | STRING { $$ = new std::string("string"); }
    ;

assignment:
    IDENTIFIER ASSIGN expression SEMICOLON {
        if (shouldExecute) {
            checkVariable(*$1);
            std::string varName = *$1;
            std::string varType = getVariableType(varName);
            std::string exprType = getExpressionType($3);

            if (!checkTypeCompatibility(varType, exprType, "assignment")) {
                yyerror(("Type mismatch in assignment: " + varType + " and " + exprType).c_str());
            } else {
                if (varType == "int") {
                    symbolTable[varName].value.intval = $3;
                } else if (varType == "float") {
                    symbolTable[varName].value.floatval = $3;
                } else if (varType == "char") {
                    symbolTable[varName].value.charval = $3;
                } else if (varType == "string") {
                    yyerror("String assignment not yet implemented.");
                }
            }
        }
    }
    | IDENTIFIER ASSIGN CHAR_CONST SEMICOLON {
        if (shouldExecute){
            checkVariable(*$1);
            std::string varName = *$1;
            std::string varType = getVariableType(varName);

            if (varType != "char") {
                yyerror(("Type mismatch in assignment: expected 'char', got " + varType).c_str());
            } else {
                if ((*$3).length() != 1) {
                    yyerror("Invalid assignment: expected a single character.");
                } else {
                    symbolTable[varName].value.charval = (*$3)[0];
                }
            }
        }

        delete $1;
        delete $3;
    }
    | IDENTIFIER ASSIGN STRING_CONST SEMICOLON {
        if (shouldExecute) {
            checkVariable(*$1);
            std::string varName = *$1;
            std::string varType = getVariableType(varName);

            if (varType != "string") {
                yyerror(("Type mismatch in assignment: expected 'string', got " + varType).c_str());
            } else {
                if (symbolTable[varName].value.strval != nullptr) {
                    delete symbolTable[varName].value.strval;
                }
                symbolTable[varName].value.strval = new std::string(*$3);
            }
        }

        delete $1;
        delete $3;
    }
    ;

print_stmt:
    PRINT IDENTIFIER SEMICOLON {
        if (shouldExecute) {
            checkVariable(*$2);
            std::string varName = *$2;
            std::string varType = getVariableType(varName);

            if (varType == "int") {
                printf("%s = %d\n", varName.c_str(), symbolTable[varName].value.intval);
            } else if (varType == "float") {
                printf("%s = %f\n", varName.c_str(), symbolTable[varName].value.floatval);
            } else if (varType == "char") {
                printf("%s = %c\n", varName.c_str(), symbolTable[varName].value.charval);
            } else if (varType == "string") {
                printf("%s = %s\n", varName.c_str(), symbolTable[varName].value.strval->c_str());
            }
        }
    }
    ;

read_stmt:
    READ IDENTIFIER SEMICOLON {
        checkVariable(*$2);
    }
    ;

if_stmt:
    IF LEFT_ROUND_BRACKET expression RIGHT_ROUND_BRACKET %prec IF_THEN {
        pushExecutionState($3 != 0.0f);
    }
    if_body
    ;

if_body:
    LEFT_CURLY_BRACKET statements RIGHT_CURLY_BRACKET {
        popExecutionState();
    }
    | LEFT_CURLY_BRACKET statements RIGHT_CURLY_BRACKET ELSE {
        pushExecutionState(!shouldExecute);
    }
    LEFT_CURLY_BRACKET statements RIGHT_CURLY_BRACKET {
        popExecutionState();
    }
    ;

while_stmt:
    WHILE LEFT_ROUND_BRACKET expression RIGHT_ROUND_BRACKET LEFT_CURLY_BRACKET statements RIGHT_CURLY_BRACKET
    ;

expression:
    expression PLUS term {
        if (checkTypeCompatibility(getExpressionType($1), getExpressionType($3), "addition")) {
            $$ = $1 + $3;
        } else {
            yyerror(("Type mismatch in assignment: " + getExpressionType($1) + " and " + getExpressionType($3)).c_str());
            $$ = 0;
        }
    }
    | expression MINUS term {
        if (checkTypeCompatibility(getExpressionType($1), getExpressionType($3), "subtraction")) {
            $$ = $1 - $3;
        } else {
            yyerror(("Type mismatch in assignment: " + getExpressionType($1) + " and " + getExpressionType($3)).c_str());
            $$ = 0;
        }
    }
    | expression GREATER_THAN term {

        if (checkTypeCompatibility(getExpressionType($1), getExpressionType($3), "comparison")) {
            $$ = $1 > $3;
            fflush(stdout);
        } else {
            $$ = 0;
        }
    }
    | expression LESS_THAN term {
        if (checkTypeCompatibility(getExpressionType($1), getExpressionType($3), "comparison")) {
            $$ = $1 < $3;
            fflush(stdout);
        } else {
            $$ = 0;
        }
    }
    | term { $$ = $1; }
    ;

term:
    term MUL factor {
        if (checkTypeCompatibility(getExpressionType($1), getExpressionType($3), "multiplication")) {
            $$ = $1 * $3;
        } else {
            yyerror(("Type mismatch in assignment: " + getExpressionType($1) + " and " + getExpressionType($3)).c_str());
            $$ = 0;
        }
    }
    | term DIVISION factor {
        if (checkTypeCompatibility(getExpressionType($1), getExpressionType($3), "division")) {
            $$ = $1 / $3;
        } else {
            yyerror(("Type mismatch in assignment: " + getExpressionType($1) + " and " + getExpressionType($3)).c_str());
            $$ = 0;
        }
    }
    | factor { $$ = $1; }
    ;


factor:
    INT_CONST { $$ = $1; }
    | FLOAT_CONST { $$ = $1; }
    | IDENTIFIER {
        checkVariable(*$1);
        std::string varName = *$1;
        std::string varType = getVariableType(varName);

        if (varType == "int") {
            $$ = symbolTable[varName].value.intval;
        } else if (varType == "float") {
            $$ = symbolTable[varName].value.floatval;
        } else if (varType == "char") {
            yyerror("Char type not supported in expressions yet.");
        } else if (varType == "string") {
            yyerror("String type not supported in expressions yet.");
        } else {
            yyerror(("Unknown type for variable: " + varName).c_str());
        }
    }
    | LEFT_ROUND_BRACKET expression RIGHT_ROUND_BRACKET { $$ = $2; }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "%s at line %d\n", s, currentLine);
}

int main(void) {
    return yyparse();

    cleanupSymbolTable();
}