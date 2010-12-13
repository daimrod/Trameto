all:
	bison -d trameto.y
	flex trameto.lex
	gcc -c trameto.tab.c
	gcc -c lex.yy.c
	gcc -o trameto *.o -lfl -lm

