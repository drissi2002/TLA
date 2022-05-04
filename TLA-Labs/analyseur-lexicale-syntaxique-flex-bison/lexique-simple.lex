%{

#include "simple.h"
unsigned int lineno=1;
bool error_lexical=false;

%}

%option noyywrap

nombre 0|[1-9][[:digit:]]*
variable_booleenne b(_|[[:alnum:]])*
variable_arithmetique e(_|[[:alnum:]])*
msg ["][0-9]*|[a-zA-Z]*|[/§¡!*]*|[%][a-zA-Z]|[\/~°:]*["][,]*
bibliotheque [a-zA-Z]+[.][h]
carac_spec [#~@°&]

%%

{nombre} {
	sscanf(yytext, "%ld", &yylval.nombre);
	return TOK_NOMBRE;
}

"afficher"	{return TOK_AFFICHER;}

"include"      {return TOK_IMPO_BIBLIO;}

"main"         {return TOK_PP;}

"="		{return TOK_AFFECT;}

"+"		{return TOK_PLUS;}

"-"		{return TOK_MOINS;}

"*"		{return TOK_MUL;}

"/"		{return TOK_DIV;}

"("		{return TOK_PARG;}

")"		{return TOK_PARD;}

">"             {return TOK_SUP;}

"<"             {return TOK_INF;}

"{"             {return TOK_ACCG;}

"}"             {return TOK_ACCD;}

"et"		{return TOK_ET;}

"ou"		{return TOK_OU;}

"non"		{return TOK_NON;}

";"		{return TOK_FINSTR;}

"vrai"		{return TOK_VRAI;}

"faux"		{return TOK_FAUX;}

"\n"		{lineno++;}

{msg} {
        return TOK_MSG;
}

{bibliotheque} {
        return TOK_BIBLIO;
}

{carac_spec} {
        return TOK_CARAC_SPEC;
}


{variable_booleenne} {
	yylval.texte = yytext;
	return TOK_VARB;
}


{variable_arithmetique} {
	yylval.texte = yytext;
	return TOK_VARE;
}


" "|"\t" {}

. {
        fprintf(stderr,"\tERREUR : Lexeme inconnu a la ligne [ %d ]. Il s'agit de [ %s ]  et comporte [ %d ] lettre(s)\n",lineno,yytext,yyleng);
        error_lexical=true;
	return yytext[0];
}

%%
