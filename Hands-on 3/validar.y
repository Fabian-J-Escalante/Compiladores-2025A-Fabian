%{
#include <stdio.h>
#include <stdlib.h>
%}
%token NUMBER
%left '+' '-'
%left '*' '/'
%right UMINUS
%%
input:  expr '\n' { printf("Expresión válida\n"); }
  | error '\n' { yyerror("Expresión inválida"); yyerrok; }
  ;

expr: expr '+' expr
  | expr '-' expr
  | expr '*' expr
  | expr '/' expr
  | '-' expr %prec UMINUS
  | '(' expr ')'
  | NUMBER
  ;
%%

int yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
    return 0;
}
int yywrap(void) {
    return 1;
}
int main(void) {
    printf("Añade la expresión que quieras:\n");
    while (yyparse() == 0) {}
    return 0;
}
