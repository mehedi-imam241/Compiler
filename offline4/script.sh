rm log.txt error.txt AssemblyCode.asm OptimizedAssemblyCode.asm
bison -d 1805039.y
flex 1805039.l
g++ lex.yy.c 1805039.tab.c 
./a.out $1 log.txt error.txt AssemblyCode.asm OptimizedAssemblyCode.asm
rm 1805039.tab.c 1805039.tab.h lex.yy.c

