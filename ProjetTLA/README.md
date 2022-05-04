# ProjetTLA 
Notre *analyseur syntaxique* recevra les tokens qu'enverra *l'analyseur lexical*. Les **tokens** sont en fait les *entités lexicales* lues par *Flex*. Ils correspondraient aux *terminaux* du langage. Au fur et à mesure que notre futur *analyseur syntaxique* recevra les **tokens**, il regardera si leur ordre est correct ou non. Un fichier *Bison *génère un fichier en C (tout comme fait *Flex* aussi quand il génère son *analyseur lexical*) où il va construire la fonction **yyparse()**. Cette fonction **parse** du contenu textuel et fait une *analyse syntaxique*. Elle appelle automatiquement la fonction **yylex()** de notre *analyseur lexical* pour récupérer les **tokens**.
 
## Compilation
On compile : 
```
flex -o lexique_simple.c lexique_simple.lex
bison -d syntaxe_simple.y
gcc -o simple lexique_simple.c syntaxe_simple.tab.c
```
