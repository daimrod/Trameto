all:
	bison -d trameto.y
	flex trameto.lex
	gcc -c *.o -Wall -pedantic
	gcc -o trameto *.o -lfl -lm

