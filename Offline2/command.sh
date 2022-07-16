rm log.txt token.txt
flex -o lexicalAnalyzer.cpp lexicalAnalyzer.l
g++ lexicalAnalyzer.cpp -lfl -o lexicalAnalyzer.out
./lexicalAnalyzer.out lexicalAnalyzer.txt
rm lexicalAnalyzer.cpp lexicalAnalyzer.out 