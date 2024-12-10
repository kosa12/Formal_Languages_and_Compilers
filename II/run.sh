#!/bin/bash

if [[ ! -f "lexer.l" || ! -f "parser.y" ]]; then
  echo "Error: Missing lexer.l, parser.y, or main.c."
  exit 1
fi

echo "Running Flex..."
flex lexer.l

echo "Running Bison..."
bison -d parser.y


echo "Compiling..."
gcc -o parser parser.tab.c lex.yy.c -lfl

echo "Running the program..."
echo ""
echo ""
echo ""
./parser < bemenet.txt

echo "Finished!"
