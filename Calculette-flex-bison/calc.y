%{

#include<math.h>
#include<stdio.h>
#include<stdlib.h>
#include<ctype.h>

%}
%union{float f; int i;}
%token <f>NOMBRE 

%token PLUS MOINS FOIS DIVISE PUISSANCE PG PD FIN
%type <f>Expression

%left PLUS MOINS
%left FOIS DIVISE
%left NEG
%left PUISSANCE
%start Input

%%
Input	:
	|Input Ligne
	;
Ligne	:FIN
	|Expression FIN	{printf("Resultat : %f",$1);}
	;
Expression	:NOMBRE {$$ = $1;}
		|Expression PLUS Expression {$$ = $1 + $3;}
		|Expression MOINS Expression {$$ = $1 - $3;}
		|Expression FOIS Expression {$$ = $1 * $3;}
		|Expression DIVISE Expression {$$ = $1 / $3;}
		|Expression PUISSANCE Expression {int i,interm =1; for(i=0;i<$3;i++) interm = interm*$1; $$=interm;}
		|MOINS Expression %prec NEG {$$ = -$2;}
		|PG Expression PD	{$$ = $2;}
		;
%%
int yyerror(char *s){printf("%s\n",s);}
int yywrap(){return 1;}
int main(void){yyparse();}
