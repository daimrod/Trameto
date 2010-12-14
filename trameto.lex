%{

  #include "global.h"
  #include "trameto.tab.h"
%}

blancs		[ \t]+
seperateur	,
eof		<<EOF>>

add		(?i:add)
b		(?i:b)
cmp		(?i:cmp)
load		(?i:load)
move		(?i:move)
mul		(?i:mul)
pow		(?i:pow)
print		(?i:print)
read		(?i:read)
stop		(?i:stop)
sub		(?i:sub)

suffixe		(?i:al|lt|le|eq|ne)

reg		[rR](0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15)

chiffre		[0-9]
entier		{chiffre}+
exposant	[eE][+-]?{entier}
reel		{entier}("."{entier})?{exposant}?

%%

{blancs}	{ /* on ignore */ }
{seperateur}	return SEPARATOR;
\n		return RET;
eof		return FIN;

{entier}		{
  yylval = atoi(yytext);
  return OFFSET;
}

{reel}		{
  double tmp = atof(yytext);
  yylval = * (uint32_t*) &tmp;
  return FLOAT;
}

{add}		return ADD;
{b}		return B;
{cmp}		return CMP;
{load}		return LOAD;
{move}		return MOVE;
{mul}		return MUL;
{pow}		return POW;
{print}		return PRINT;
{read}		return READ;
{stop}		return STOP;
{sub}		return SUB;

{suffixe}	{
  if (strncmp(yytext, "al", sizeof(char) * 2)
      || strncmp(yytext, "AL", sizeof(char) * 2)
      || strncmp(yytext, "Al", sizeof(char) * 2)
      || strncmp(yytext, "aL", sizeof(char) * 2))
    yylval = AL;
  if (strncmp(yytext, "eq", sizeof(char) * 2)
      || strncmp(yytext, "EQ", sizeof(char) * 2)
      || strncmp(yytext, "Eq", sizeof(char) * 2)
      || strncmp(yytext, "eQ", sizeof(char) * 2))
    yylval = AL;
  if (strncmp(yytext, "lt", sizeof(char) * 2)
      || strncmp(yytext, "LT", sizeof(char) * 2)
      || strncmp(yytext, "Lt", sizeof(char) * 2)
      || strncmp(yytext, "lT", sizeof(char) * 2))
    yylval = AL;
  if (strncmp(yytext, "le", sizeof(char) * 2)
      || strncmp(yytext, "LE", sizeof(char) * 2)
      || strncmp(yytext, "Le", sizeof(char) * 2)
      || strncmp(yytext, "lE", sizeof(char) * 2))
    yylval = AL;
  if (strncmp(yytext, "ne", sizeof(char) * 2)
      || strncmp(yytext, "NE", sizeof(char) * 2)
      || strncmp(yytext, "Ne", sizeof(char) * 2)
      || strncmp(yytext, "nE", sizeof(char) * 2))
    yylval = AL;
  return SUF;
}

{reg}		{
  yylval = yytext[1] - '0';
  printf("%d\n", yylval);
  return REG;
}
