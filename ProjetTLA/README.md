# ProjetTLA 
Notre *analyseur syntaxique* recevra les tokens qu'enverra *l'analyseur lexical*. Les **tokens** sont en fait les *entités lexicales* lues par *Flex*. Ils correspondraient aux *terminaux* du langage. Au fur et à mesure que notre futur *analyseur syntaxique* recevra les **tokens**, il regardera si leur ordre est correct ou non. Un fichier *Bison *génère un fichier en C (tout comme fait *Flex* aussi quand il génère son *analyseur lexical*) où il va construire la fonction **yyparse()**. Cette fonction **parse** du contenu textuel et fait une *analyse syntaxique*. Elle appelle automatiquement la fonction **yylex()** de notre *analyseur lexical* pour récupérer les **tokens**.
 
## Compilation
On compile : 
```
flex -o analyse.c analyse.flex
bison -d analyse.y
gcc -o analyse analyse.tab.c
```
## Execution 
On excute le script : 
```
./analyse < prog.txt
```
## Preview
![image](https://user-images.githubusercontent.com/84160502/167260787-da95cde8-09c2-46df-bd3b-31ab8f1cfcb1.png)

