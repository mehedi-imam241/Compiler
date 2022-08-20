rm logout.txt error.txt asm.txt
bison -d parser.y 
flex scanner.l 
g++ lex.yy.c parser.tab.c 
./a.out input.c logout.txt error.txt asm.txt
rm lex.yy.c parser.tab.c parser.tab.h a.out 