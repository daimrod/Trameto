#ifndef _GLOBAL_H_
#define _GLOBAL_H_

#include <stdint.h>

#define AL 0
#define EQ 1
#define LT 2
#define LE 3
#define NE 4

#define YYSTYPE uint32_t
extern YYSTYPE yylval;

#define u64_SL(n, x) ((uint64_t) (((uint64_t) (n)) << ((uint64_t) (x))))

#endif
