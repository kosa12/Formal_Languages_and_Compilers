#!/bin/bash

if [[ ! -f "lexer.l" || ! -f "parser.y" ]]; then
  echo "Error: Missing lexer.l, parser.y, or main.c."
  exit 1
fi


echo "Running Bison..."
bison -d -Wcounterexamples -o parser.tab.cpp parser.y

echo "Running Flex..."
flex -o lex.yy.cpp lexer.l


echo "Compiling..."
g++ -o parser parser.tab.cpp lex.yy.cpp -lfl

echo "Running the program..."
echo ""
echo ""
echo ""
./parser < bemenet.txt

echo ""
echo ""
echo ""
echo "Finished!"
