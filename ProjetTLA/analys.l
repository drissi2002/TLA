%{
#include "analys.tab.h"
%}

%option noyywrap
%option yylineno
entier ("+"|"-")?[0-9]+
var [a-zA-Z]*
msg [a-zA-Z]*[=]*[%]*[a-z]*["]
%%
"main" return MAIN;
"printf" return AFFICHER ;
"int" return TYPE;
{msg} return MSG;
{var} return VAR;
"(" return PRO;
")" return PRF;
"{" return ACO;
"}" return ACF;
";" return DPV;
"," return VIRG;
"=" return EGAL;
{entier} return ENTIER;
" "|"\t"|"\n" {} /* ignorer les espaces et les retours à la ligne */
. {
    printf("\n -- Erreur lexicale à la ligne [ %d ] -- \n",yylineno);
}
%%
