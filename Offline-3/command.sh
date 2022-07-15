yacc -d -y parser.y
g++ -w -c -o y.o y.tab.c
flex scanner.l
g++ -w -c -o l.o lex.yy.c
g++ y.o l.o -lfl -o 185039
./1805039
