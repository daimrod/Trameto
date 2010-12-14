%{

#include "global.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

char* uint64_to_str(uint64_t n);
uint64_t shift_left(uint64_t n, size_t i);
%}

%token  ADD B CMP LOAD MOVE MUL POW PRINT READ STOP SUB
%token  SUF FLOAT OFFSET REG
%token  EOL SEPARATOR FIN

%start input
%%

input: /* empty */
| input line
;

line:
EXP EOL
;

EXP: ADD SUF REG SEPARATOR REG SEPARATOR REG {
  printf("%s\n", uint64_to_str(shift_left($2, 21)
			       + shift_left($3,  14)
			       + shift_left($5,  7)
			       + $7));
  $$ = 0; }
EXP:  B SUF OFFSET {
  printf("%s\n", uint64_to_str(shift_left(1, 24)
			       + shift_left($2, 21)
			       + shift_left($3, 32)));
  $$ = 0; }
EXP:  CMP SUF REG SEPARATOR REG {
  printf("%s\n", uint64_to_str(shift_left(2,  24)
			       + shift_left($2,  21)
			       + shift_left($3,  14)
			       + shift_left($5,  14)));
  $$ = 0; }
EXP:  LOAD SUF REG SEPARATOR FLOAT {
  printf("%s\n", uint64_to_str(shift_left(3,  24)
			       + shift_left($2,  21)
			       + shift_left($3,  14)
			       + shift_left($5,  32)));
  $$ = 0; }
EXP:  MOVE SUF REG SEPARATOR REG {
  printf("%s\n", uint64_to_str(shift_left(4,  24)
			       + shift_left($2,  21)
			       + shift_left($3,  14)
			       + shift_left($5,  7)));
  $$ = 0; }
EXP:  MUL SUF REG SEPARATOR REG SEPARATOR REG {
  printf("%s\n", uint64_to_str(shift_left(5,  24)
			       + shift_left($2,  21)
			       + shift_left($3,  14)
			       + shift_left($5,  7)
			       + $7));
  $$ = 0; }
EXP:  POW SUF REG SEPARATOR REG SEPARATOR FLOAT {
  printf("%s\n", uint64_to_str(shift_left(6,  24)
			       + shift_left($2,  21)
			       + shift_left($3,  14)
			       + shift_left($5,  7)
			       + shift_left($7,  32)));
  $$ = 0; }
EXP:  PRINT SUF REG {
  printf("%s\n", uint64_to_str(shift_left(7,  24)
			       + shift_left($2,  21)
			       + shift_left($3,  14)));
  $$ = 0; }
EXP:  STOP SUF {
  printf("%s\n", uint64_to_str(shift_left(8,  24)
			       + shift_left($2,  21)));
  $$ = 0; }
EXP:  SUB SUF REG SEPARATOR REG SEPARATOR REG {
  printf("%s\n", uint64_to_str(shift_left(9,  24)
			       + shift_left($2,  21)
			       + shift_left($3,  14)
			       + shift_left($5,  7)
			       + $7));
  $$ = 0; }
;

%%

int yyerror(char *s) {
  fprintf(stderr, "%s\n",s);
}

int yywrap() {
        return 1;
} 

int main(void) {
  yyparse();
}

char* strrev(char *str)
{
  char  *e, *s;
  char   a;

  s = str;
  e = str;

  while (*e)
    e++;
  e--;

  while (s < e) {
    a = *s;
    *s = *e;
    *e = a;
    s++;
    e--;
  }
  return str;
}

char* uint64_to_str(uint64_t n) {
  char *ret;
  char c;
  size_t i, size, j;
  int tmp;

  size = 10;
  if ((ret = (char*) malloc(sizeof(char) * size)) == NULL) {
    fputs("erreur: impossible d'allouer de la memoire\n", stderr);
    exit(-1);
  }
  
  for (i = 0; n > 0; i++) {
    tmp = n % 10;
    n /= 10;
    ret[i] = tmp + '0';

    if (i >= size) {
      size *= 2;
      if ((ret = (char*) realloc(ret, sizeof(char) * size)) == NULL) {

	exit(-1);
      }
    }
  }
  if ((ret = (char*) realloc(ret, sizeof(char) * (i+1))) == NULL) {
    fputs("erreur: impossible d'allouer de la memoire\n", stderr);
    exit(-1);
  }
  ret[i] = '\0';

  ret = strrev(ret);

  return ret;
}

uint64_t shift_left(uint64_t n, size_t i) {
  while(i--)
    n = n << 1;
  return n;
}
