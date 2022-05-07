%{
#include "analyse.c"
void yyerror(char* s);
%}


%union {
    char* texte ;
    int integer ;
}
%token MAIN PRO PRF NUM INC STDIO ACO ACF ENTIER AFFICHER VAR MSG VIRG PV EGAL VOID	
%type<integer> NUM
%type<texte>affectation
%type<texte>affichage
%start S

%%
S:IMPO S | PP;
IMPO:INC STDIO {printf("\n Importation de la bibliotheque\n");};
PP :VOID MAIN PRO PRF ACO ListeOper ACF {printf("\n Le progarmme principale \n");};
ListeOper: affectation ListeOper | affichage ;
affectation:ENTIER VAR EGAL NUM PV {printf("\nAffecter un entier à une variable\n");};
affichage:AFFICHER PRO MSG VIRG VAR PRF PV {printf("\nafficher le contenu de la variable\n");};
%% 
void yyerror(char* s){
   
    printf("\n --erreur syntaxique à la ligne [ %d ] -- \n",yylineno);
}

void main(){
    
    if(!yyparse()){
        printf("\n-- Succées de l'analyse lexicale et syntaxique --\n");   
    }
    else {
        printf("\n-- Echec de l'analyse lexicale et syntaxique !! --\n");
    }

}

