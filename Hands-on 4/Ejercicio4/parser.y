%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
int yyerror(char *s) { return 0; }

#define MAX_SCOPE 10
#define MAX_ID    100

static char *ambitos[MAX_SCOPE][MAX_ID];
static int   niveles[MAX_SCOPE];
static int   tope = 0;

void entrar_ambito() {
    tope++;
    niveles[tope] = 0;
}
void salir_ambito() {
    tope--;
}

void agregar_local(char *id) {
    ambitos[tope][niveles[tope]++] = strdup(id);
}
int buscar_local(char *id) {
    for (int i = tope; i >= 0; i--)
        for (int j = 0; j < niveles[i]; j++)
            if (strcmp(ambitos[i][j], id) == 0)
                return 1;
    return 0;
}
%}

%union { char *str; }

%token <str> ID
%token INT LLAVEIZQ LLAVEDER PUNTOYCOMA

%%

programa
    : 
    | programa sentencia
    ;

sentencia
    : declaracion
    | llamada
    | error PUNTOYCOMA   { yyerrok; }    
    | ID                  
        {
            if (!buscar_local($1))
                printf("Error semántico: '%s' no está declarado\n", $1);
            free($1);
            yyerrok;
        }
    ;

declaracion
    : INT ID PUNTOYCOMA
        { agregar_local($2); free($2); }
    | LLAVEIZQ 
        { entrar_ambito(); }
      instrucciones
      LLAVEDER 
        { salir_ambito(); }
    ;

llamada
    : ID PUNTOYCOMA
        {
            if (!buscar_local($1))
                printf("Error semántico: '%s' no está declarado\n", $1);
            free($1);
        }
    ;

instrucciones
    : 
    | instrucciones instruccion
    ;

instruccion
    : declaracion
    | llamada
    ;

%%

int main(void) {
    return yyparse();
}
