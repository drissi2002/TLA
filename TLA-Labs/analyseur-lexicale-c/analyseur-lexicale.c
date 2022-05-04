#include<stdio.h>
#include<stdlib.h>
#include<string.h> 
#include<ctype.h>

int isKeyword(char buffer[]){
  char keywords[32][10] ={"break","case","do","int","double","else","if",
  "long","sizeof","struct","float","return","void","switch","typedef",
  "short","unsogned","auto","while"};
  int flag = 0 ;  
  for(int i =0 ; i<32;i++){
    if(strcmp(keywords[i],buffer)==0){
      flag =1 ;
      break ;
    }
  }
return flag ;
}

int main(){
 char ch , buffer[15] , operators[]="+-*/%=" ;
 int j=0;
 FILE *fich ;
 fich =fopen("program.txt","r");
 if(fich == NULL){
   printf("error while opening the file !! \n");
   exit(0);
 }
 
 while ((ch = fgetc(fich))!=EOF){
   for(int i=0;i<6;i++){
      if ( ch == operators[i]){
      printf("%c is an operator ",ch);}
   }
   
   if(isalnum(ch)){
      buffer[j++]=ch;}
   else if((ch == ' ' || ch == '\n')&&(j!=0)){
      buffer[j]='\0';
      j=0;
      if(isKeyword(buffer)==1){
         printf("%s is keywords \n",buffer);}
      else{
         printf("%s is identifier \n",buffer);}
   }
 }
 fclose(fich);
 return 0 ;
}
