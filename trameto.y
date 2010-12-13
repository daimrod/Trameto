%{

#include "global.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

%}

%token  ADD B CMP LOAD MOVE MUL POW PRINT READ STOP SUB
%token  SUF FLOAT OFFSET REG
%token  FIN SEPARATOR

%start Input
%%

Input:
    /* Vide */
  | Input Ligne
  ;

Ligne:
FIN { printf("fin\n"); }
| Expression FIN    { printf("fin 2\n"); }
  ;

Expression:
ADD SUF REG SEPARATOR REG SEPARATOR REG {
  $$ = ($1 << 21) + ($2 << 14) + ($3 << 7) + $4;
}
| B SUF OFFSET {
  $$ = (1 << 24) + ($1 << 21) + ($2 << 32);
}
| CMP SUF REG SEPARATOR REG {
  $$ = (2 << 24) + ($1 << 21) + ($2 << 14) + ($3 << 14);
}
| LOAD SUF REG SEPARATOR FLOAG {
  $$ = (3 << 24) + ($1 << 21) + ($2 << 32);
}
| MOVE SUF REG SEPARATOR REG {
  $$ = (4 << 24) + ($1 << 21) + ($2 << 14) + ($3 << 7);
}
| MUL SUF REG SEPARATOR REG SEPARATOR REG {
  $$ = (5 << 24) + ($1 << 21) + ($2 << 14) + ($3 << 7) + $4;
}
| POW SUF REG SEPARATOR REG SEPARATOR FLOAT {
  $$ = (6 << 24) + ($1 << 21) + ($2 << 14) + ($3 << 7) + ($4 << 32);
}
| PRINT SUF REG {
  $$ = (7 << 24) + ($1 << 21) + ($2 << 14);
}
| STOP SUF {
  $$ = 8 << 24;
}
| SUB SUF REG SEPARATOR REG SEPARATOR REG {
  $$ = (9 << 24) + ($1 << 21) + ($2 << 14) + ($3 << 7) + $4;
}
;

%%

int yyerror(char *s) {
  printf("%s\n",s);
}

int main(void) {
  yyparse();
}
