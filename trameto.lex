%{
  #include "trameto.tab.h"
  #define AL 0
  #define EQ 1
  #define LT 2
  #define LE 3
  #define NE 4

  float yylval;
%}

blancs		[ \t]+
seperateur	,

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

offset		entier

<<EOF>>		FIN

%%

{blancs}	{ /* on ignore */ }
{seperateur}	return SEPARATOR;

{offset}	{
  yylval = atol(yytext);
  return OFFSET;
}

{reel}		{
  yylval = atof(yytext);
  return FLOAT;
}

{FIN}		return FIN;

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
  switch (yytext) {
  case "al" || "AL" || "Al" || "aL":
    yylval = AL;
    break;
  case "eq" || "EQ" || "Eq" || "eQ":
    yylval = EQ;
    break;
  case "lt" || "LT" || "Lt" || "lT":
    yylval = LT;
    break;
  case "le" || "LE" || "Le" || "lE":
    yylval = LE;
    break;
  case "ne" || "NE" || "Ne" || "nE":
    yylval = NE;
    break;
  }
  return SUF;
}

{reg}		{
  yylval = atoi(yytext+sizeof(char));
  return REG;
}
