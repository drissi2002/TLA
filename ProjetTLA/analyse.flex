%{
#include "analyse.tab.h"
extern YYSTYPE yylval;
%}

%option noyywrap
%option yylineno
numero [0-9]+
msg ["]"la valeur de x = %d"["]
var [a-zA-Z]*

%%
{msg} {return (MSG);}
"printf" return (AFFICHER);
"int" return (ENTIER);
"main" return (MAIN);
"#include" return (INC);
"<stdio.h>" return(STDIO);
"void" return(VOID);
"(" return (PRO);
")" return (PRF);
"{" return (ACO);
"}" return (ACF);
";" return (PV);
"=" return (EGAL);
"," return (VIRG);
" "|"\n"|"\t" {}
{var} return (VAR);
{numero} return(NUM);
. {printf("\n-- Erreur lexicale à la ligne [ %d ] --\n",yylineno);}
%%
