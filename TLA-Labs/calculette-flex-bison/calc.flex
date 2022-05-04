%{
#include "calc.tab.h"
extern YYSTYPE yylval;
%}
blanc [ \t]+
chiffre [0-9]
entier {chiffre}+
exposant [eE][+-]?{entier}
reel {entier}("."{entier})?{exposant}?
%%
{blanc}	{}
{entier}|{reel}	{yylval.f=atof(yytext);return (NOMBRE);}
"+"	return (PLUS);
"-" 	return (MOINS);
"*"	return (FOIS);
"/"	return (DIVISE);
"^"	return (PUISSANCE);
"("	return (PG);
")"	return (PD);
"\n"	return (FIN);
%%
