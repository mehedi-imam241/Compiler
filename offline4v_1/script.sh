# bison -d -v -y 1705058.y
# echo 'Generated the parser C and Header Files'
# g++ -w -c -o y.o y.tab.c
# echo 'Generated the Parser Object File'
# flex 1705058.l
# echo 'Generated the Scanner C File'
# g++ -fpermissive -w -c -o l.o lex.yy.c
# echo 'Generated the Scanner Object File'
# g++ y.o l.o -lfl
# echo 'All Ready'
# ./a.out $1
# echo 'Assembly Generation Done'


rm log.txt error.txt AssemblyCode.asm OptimizedAssemblyCode.asm
bison -d 1805039.y
flex 1805039.l
g++ lex.yy.c 1805039.tab.c 
./a.out $1 log.txt error.txt AssemblyCode.asm OptimizedAssemblyCode.asm
rm 1805039.tab.c 1805039.tab.h lex.yy.c

