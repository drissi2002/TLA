%{

#include "simple.h"
#include <string.h>
#include <glib.h>
bool error_syntaxical=false;
bool error_semantical=false;
extern unsigned int lineno;
extern bool error_lexical;
/* Notre table de hachage */
GHashTable* table_variable;

/* Notre structure Variable qui a comme membre le type et un pointeur generique vers la valeur */
typedef struct Variable Variable;

struct Variable{
	char* type;
	void* value;
};

%}

/* L'union dans Bison est utilisee pour typer nos tokens ainsi que nos non terminaux. Ici nous avons declare une union avec deux types : nombre de type int et texte de type pointeur de char (char*) */

%union {
	long nombre;
	char* texte;
}

/* Nous avons ici les operateurs, ils sont definis par leur ordre de priorite. Si je definis par exemple la multiplication en premier et l'addition apres, le + l'emportera alors sur le * dans le langage. Les parenthese sont prioritaires avec %right */

%left			TOK_PLUS	TOK_MOINS	/* +- */
%left			TOK_MUL	TOK_DIV	/* /* */
%left			TOK_ET		TOK_OU	       TOK_NON		/* et ou non */
%right			TOK_PARG	TOK_PARD	/* () */

/* Nous avons la liste de nos expressions (les non terminaux). Nous les typons tous en texte (pointeur vers une zone de char). */

%type<texte>		code
%type<texte>		instruction
%type<texte>		variable_arithmetique
%type<texte>		variable_booleenne
%type<texte>		affectation
%type<texte>		affichage
//%type<texte>           bibliotheque
//%type<texte>           prog_principale
%type<texte>		expression_arithmetique
%type<texte>		expression_booleenne
%type<texte>		addition
%type<texte>		soustraction
%type<texte>		multiplication
%type<texte>		division

/* Nous avons la liste de nos tokens (les terminaux de notre grammaire) */

%token<nombre>		TOK_NOMBRE
%token			TOK_VRAI	/* true */
%token			TOK_FAUX	/* false */
%token			TOK_AFFECT	/* = */
%token			TOK_FINSTR	/* ; */
%token			TOK_AFFICHER	/* afficher */
%token                 TOK_BIBLIO      /* bibliotheque */
%token                 TOK_IMPO_BIBLIO /* include */
%token                 TOK_PP          /* Programme principale */
%token                 TOK_REF         /* refrence (passage par adresse) */
%token                 TOK_INF         /* < */
%token                 TOK_SUP         /* > */
%token                 TOK_PARD        /* ) */
%token                 TOK_PARG        /* ( */
%token                 TOK_ACCG        /* { */
%token                 TOK_ACCD        /* } */
%token                 TOK_MSG         /* msg */
%token                 TOK_CARAC_SPEC  /* # */
%token<texte> 		TOK_VARB	 /* variable booleenne */
%token<texte> 		TOK_VARE	 /* variable arithmetique */

%%

/* Nous definissons toutes les regles grammaticales de chaque non terminal de notre langage. Par defaut on commence a definir l'axiome, c'est a dire ici le non terminal code. Si nous le definissons pas en premier nous devons le specifier en option dans Bison avec %start */

code: 		%empty{}
		|
 		code instruction{
			printf("Resultat : C'est une instruction valide !\n\n");
		}
		|
		code error{
			fprintf(stderr,"\tERREUR : Erreur de syntaxe a la ligne %d.\n",lineno);
 			error_syntaxical=true;
		};

instruction:	affectation{
			printf("\tInstruction type Affectation\n");
 		}
		|
 		affichage{
			 printf("\tInstruction type Affichage\n");
		};
		//bibliotheque {
		 //       printf("\tImportation du bibliotheque");
		//};
		// |
		// prog_principale{
		//         printf("\tProgarmme principale");
		// };

variable_arithmetique:	TOK_VARE{
				printf("\t\t\tVariable entiere %s\n",$1);
				$$=strdup($1);
			};

variable_booleenne:	TOK_VARB{
				printf("\t\t\tVariable booleenne %s\n",$1);
				$$=strdup($1);
			};

affectation:	variable_arithmetique TOK_AFFECT expression_arithmetique TOK_FINSTR{
			/* $1 est la valeur du premier non terminal. Ici c'est la valeur du non terminal variable. $3 est la valeur du 2nd non terminal. */
			printf("\t\tAffectation sur la variable %s\n",$1);
			/* On cree une Variable et on lui affecte le type que nous connaissons et la valeur */
			Variable* var=malloc(sizeof(Variable));
			if(var!=NULL){
				var->type=strdup("entier");
				var->value=strdup($3);
				/* On l'insere dans la table de hachage (cle: <nom_variable> / valeur: <(type,valeur)>) */
				if(!g_hash_table_insert(table_variable,strdup($1),var)){
					fprintf(stderr,"ERREUR - PROBLEME CREATION VARIABLE !\n");
					exit(-1);
				}
			}else{
				fprintf(stderr,"ERREUR - PROBLEME ALLOCATION MEMOIRE VARIABLE !\n");
				exit(-1);
			}
		}
		|
		variable_booleenne TOK_AFFECT expression_booleenne TOK_FINSTR{
			printf("\t\tAffectation sur la variable %s\n",$1);
			Variable* var=malloc(sizeof(Variable));
			if(var!=NULL){
				var->type=strdup("booleen");
				var->value=strdup($3);
				if(!g_hash_table_insert(table_variable,strdup($1),var)){
					fprintf(stderr,"ERREUR - PROBLEME CREATION VARIABLE !\n");
					exit(-1);
				}
			}else{
				fprintf(stderr,"ERREUR - PROBLEME ALLOCATION MEMOIRE VARIABLE !\n");
				exit(-1);
			}
		};

affichage:	TOK_AFFICHER expression_arithmetique TOK_FINSTR{
			printf("\t\tAffichage de la valeur de l'expression arithmetique %s\n",$2);
		}
		|
		TOK_AFFICHER expression_booleenne TOK_FINSTR{
			printf("\t\tAffichage de la valeur de l'expression booleenne %s\n",$2);
		}
		|
		TOK_AFFICHER TOK_PARG TOK_MSG variable_arithmetique TOK_PARD TOK_FINSTR{
		printf("\t\tAffichage de la valeur du variable %s\n",$4);
		
		};
		//|
		//bibliotheque{
		 //  printf("\t\tAffichage de  la bibliotheque importé");
		//};
		
//bibliotheque:  TOK_CARAC_SPEC TOK_IMPO_BIBLIO TOK_INF TOK_BIBLIO TOK_SUP{
//               printf("\t\tAffichage de la biblotheque %s\n",//$4);               
//               };


expression_arithmetique:	TOK_NOMBRE{
					printf("\t\t\tNombre : %ld\n",$1);
					/* Comme le token TOK_NOMBRE est de type entier et que on a type expression_arithmetique comme du texte, il nous faut convertir la valeur en texte. */
					int length=snprintf(NULL,0,"%ld",$1);
					char* str=malloc(length+1);
					snprintf(str,length+1,"%ld",$1);
					$$=strdup(str);
					free(str);
				}
				|
				variable_arithmetique{
					/* On recupere un pointeur vers la structure Variable */
					Variable* var=g_hash_table_lookup(table_variable,$1);
					/* Si on a trouve un pointeur valable */
					if(var!=NULL){
						/* On verifie que le type est bien un entier - Inutile car impose a l'analyse syntaxique */
						if(strcmp(var->type,"entier")==0){
							$$=strdup($1);
						}else{
							fprintf(stderr,"\tERREUR");
							error_semantical=true;
						}
					/* Sinon on conclue que la variable n'a jamais ete declaree car absente de la table */
					}else{
						fprintf(stderr,"\tERREUR : Ea la ligne %d. Variable %s jamais declaree !\n",lineno,$1);
						error_semantical=true;
					}
				}
				|
				addition{
				}
				|
				soustraction{
				}
				|
				multiplication{
				}
				|
				division{
				}
				|
				TOK_PARG expression_arithmetique TOK_PARD{
					printf("\t\t\tC'est une expression artihmetique entre parentheses\n");
					$$=strcat(strcat(strdup("("),strdup($2)),strdup(")"));
				};

expression_booleenne:		TOK_VRAI{
					printf("\t\t\tBooleen Vrai\n");
					$$=strdup("vrai");
				}
				|
				TOK_FAUX{
					printf("\t\t\tBooleen Faux\n");
					$$=strdup("faux");
				}
				|
				variable_booleenne{
					/* On recupere un pointeur vers la structure Variable */
					Variable* var=g_hash_table_lookup(table_variable,$1);
					/* Si on a trouve un pointeur valable */
					if(var!=NULL){
						/* On verifie que le type est bien un entier - Inutile car impose a l'analyse syntaxique */
						if(strcmp(var->type,"booleen")==0){
							$$=strdup($1);
						}else{
							fprintf(stderr,"\tERREUR");
							error_semantical=true;
						}
					/* Sinon on conclue que la variable n'a jamais ete declaree car absente de la table */
					}else{
						fprintf(stderr,"\tERREUR : Erreur de semantique a la ligne %d. Variable %s jamais declaree !\n",lineno,$1);
						error_semantical=true;
					}
				}
				|
				TOK_NON expression_booleenne{
					printf("\t\t\tOperation booleenne Non\n");
					$$=strcat(strdup("non "), strndup($2,sizeof(char)*strlen($2)));
				}
				|
				expression_booleenne TOK_ET expression_booleenne{
					printf("\t\t\tOperation booleenne Et\n");
					$$=strcat(strcat(strdup($1),strdup(" et ")),strdup($3));
				}
				|
				expression_booleenne TOK_OU expression_booleenne{
					printf("\t\t\tOperation booleenne Ou\n");
					$$=strcat(strcat(strdup($1),strdup(" ou ")),strdup($3));
				}
				|
				TOK_PARG expression_booleenne TOK_PARD{
					printf("\t\t\tC'est une expression booleenne entre parentheses\n");
					$$=strcat(strcat(strdup("("),strdup($2)),strdup(")"));
				};

addition:	expression_arithmetique TOK_PLUS expression_arithmetique{printf("\t\t\tAddition\n");$$=strcat(strcat(strdup($1),strdup("+")),strdup($3));};
soustraction:	expression_arithmetique TOK_MOINS expression_arithmetique{printf("\t\t\tSoustraction\n");$$=strcat(strcat(strdup($1),strdup("-")),strdup($3));};
multiplication:	expression_arithmetique TOK_MUL expression_arithmetique{printf("\t\t\tMultiplication\n");$$=strcat(strcat(strdup($1),strdup("*")),strdup($3));};
division:	expression_arithmetique TOK_DIV expression_arithmetique{printf("\t\t\tDivision\n");$$=strcat(strcat(strdup($1),strdup("/")),strdup($3));};

%%

/* Dans la fonction main on appelle bien la routine yyparse() qui sera genere par Bison. Cette routine appellera yylex() de notre analyseur lexical. */

int main(void){
	/* Creation de la table de hachage */
	table_variable=g_hash_table_new_full(g_str_hash,g_str_equal,free,free);
	printf("Debut de l'analyse syntaxique :\n");
	yyparse();
	printf("Fin de l'analyse !\n");	
	printf("Resultat :\n");
        if(error_lexical){
                printf("\t-- Echec : Certains lexemes ne font pas partie du lexique du langage ! --\n");
		printf("\t-- Echec a l'analyse lexicale --\n");
        }
        else{
                printf("\t-- Succes a l'analyse lexicale ! --\n");
        }
	if(error_syntaxical){
                printf("\t-- Echec : Certaines phrases sont syntaxiquement incorrectes ! --\n");
		printf("\t-- Echec a l'analyse syntaxique --\n");
        }
        else{
                printf("\t-- Succes a l'analyse syntaxique ! --\n");
		if(error_semantical){
		        printf("\t-- Echec : Certaines phrases sont semantiquement incorrectes ! --\n");
			printf("\t-- Echec a l'analyse semantique --\n");
		}
		else{
		        printf("\t-- Succes a l'analyse semantique ! --\n");
		}
        }
	/* Liberation memoire : suppression de la table */
	g_hash_table_destroy(table_variable);
	return EXIT_SUCCESS;
}
void yyerror(char *s) {
        fprintf(stderr, "Erreur de syntaxe a la ligne %d: %s\n", lineno, s);
}
