%{

  #include "global.h"
  #include "trameto.tab.h"
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

al		[aA][lL]
eq		[eE][qQ]
lt		[lL][tT]
le		[lL][eE]
ne		[nN][eE]

reg		[rR](0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15)

chiffre		[0-9]
entier		{chiffre}+
exposant	[eE][+-]?{entier}
reel		[+-]?{entier}("."{entier})?{exposant}?
commentaire	"//".*

%%

{blancs}	{ /* on ignore */ }
{seperateur}	return SEPARATOR;
\n		return EOL;
{commentaire}	{ /* on ignore */ }

[+-]?{entier}		{
  yylval = atoi(yytext);
  return OFFSET;
}

{reel}		{
  float tmp = atof(yytext);
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

{al}		{
  yylval = AL;
  return SUF;
}
{eq}		{
  yylval = EQ;
  return SUF;
}
{lt}		{
  yylval = LT;
  return SUF;
}
{le}		{
  yylval = LE;
  return SUF;
}
{ne}		{
  yylval = NE;
  return SUF;
}

{reg}		{
  yylval = yytext[1] - '0';
  return REG;
}
