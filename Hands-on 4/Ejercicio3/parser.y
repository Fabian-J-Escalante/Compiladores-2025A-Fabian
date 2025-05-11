%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
int yyerror(char *s) { return 0; }

#define MAX_FUNC 100
static char *funciones[MAX_FUNC];
static int   aridades[MAX_FUNC];
static int   nfuncs = 0;

void registrar_funcion(char *id, int n) {
    funciones[nfuncs] = strdup(id);
    aridades[nfuncs++] = n;
}

int obtener_aridad(char *id) {
    for (int i = 0; i < nfuncs; i++)
        if (strcmp(funciones[i], id) == 0)
            return aridades[i];
    return -1;
}
%}

%union { char *str; int num; }

%token <str> ID
%token FUNC PARIZQ PARDER PUNTOYCOMA COMA

%type <num> nonempty_param_list nonempty_args args

%%

programa
    :
    | programa sentencia
    ;

sentencia
    : declaracion
    | llamada
    | error PUNTOYCOMA   { yyerrok; }
    ;

declaracion
    : FUNC ID PARIZQ nonempty_param_list PARDER PUNTOYCOMA
        { registrar_funcion($2, $4); free($2); }
    ;

llamada
    : ID PARIZQ args PARDER PUNTOYCOMA
        {
            int expected = obtener_aridad($1);
            int got      = $3;
            if (expected >= 0) {
                if (got < expected)
                    printf("Error: se esperaban %d argumentos en '%s'\n",
                           expected, $1);
                else if (got > expected)
                    printf("Error: se esperaban %d argumentos en '%s'\n",
                           expected, $1);
            }
            free($1);
        }
    ;

nonempty_param_list
    : ID
        { $$ = 1; free($1); }
    | nonempty_param_list COMA ID
        { $$ = $1 + 1; free($3); }
    ;

args
    :            
        { $$ = 0; }
    | nonempty_args
        { $$ = $1; }
    ;

nonempty_args
    : ID
        { $$ = 1; free($1); }
    | nonempty_args COMA ID
        { $$ = $1 + 1; free($3); }
    ;
%%

int main(void) {
    return yyparse();
}
