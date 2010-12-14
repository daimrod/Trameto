%{

#include "global.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

%}

%token  ADD B CMP LOAD MOVE MUL POW PRINT READ STOP SUB
%token  SUF FLOAT OFFSET REG
%token  RET SEPARATOR FIN

%start Input
%%

Input:
/* Vide */
| Input Ligne
;

Ligne:
Expression RET { printf("%d\n", $1); }
| RET
| FIN
;

Expression:
ADD SUF REG SEPARATOR REG SEPARATOR REG {
  printf("%lld\n", ($1 << 21) + ($2 << 14) + ($3 << 7) + $4);
  $$ = 0;
}
| B SUF OFFSET {
  printf("%lld\n", (1 << 24) + ($1 << 21) + ($2 << 32));
  $$ = 0;
}
| CMP SUF REG SEPARATOR REG {
  printf("%lld\n", (2 << 24) + ($1 << 21) + ($2 << 14) + ($3 << 14));
  $$ = 0;
}
| LOAD SUF REG SEPARATOR FLOAT {
  printf("%lld\n", (3 << 24) + ($1 << 21) + ($2 << 32));
  $$ = 0;
}
| MOVE SUF REG SEPARATOR REG {
  printf("%lld\n", (4 << 24) + ($1 << 21) + ($2 << 14) + ($3 << 7));
  $$ = 0;
}
| MUL SUF REG SEPARATOR REG SEPARATOR REG {
  printf("%lld\n", (5 << 24) + ($1 << 21) + ($2 << 14) + ($3 << 7) + $4);
  $$ = 0;
}
| POW SUF REG SEPARATOR REG SEPARATOR FLOAT {
  printf("%lld\n", (6 << 24) + ($1 << 21) + ($2 << 14) + ($3 << 7) + ($4 << 32));
  $$ = 0;
}
| PRINT SUF REG {
  printf("%d\n", $1);
  printf("%d\n", $2);
  printf("%lld\n", (7 << 24) + ($1 << 21) + ($2 << 14));
  $$ = 0;
}
| STOP SUF {
  printf("%lld\n", 8 << 24);
  $$ = 0;
}
| SUB SUF REG SEPARATOR REG SEPARATOR REG {
  printf("%lld\n", (9 << 24) + ($1 << 21) + ($2 << 14) + ($3 << 7) + $4);
  $$ = 0;
}
;

%%

int yyerror(char *s) {
  printf("%s\n",s);
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
	fputs("erreur: impossible d'allouer de la memoire\n", stderr);
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
