#ProjetTLA 
On compile 
```
flex -o lexique_simple.c lexique_simple.lex
bison -d syntaxe_simple.y
gcc -o simple lexique_simple.c syntaxe_simple.tab.c
```
