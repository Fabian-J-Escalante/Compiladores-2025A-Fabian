%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
int yyerror(char *s) { printf("Error: %s\n", s); return 0; }

#define MAX_SIMB 200

typedef struct {
    char *nombre;
    int tipo;
    int aridad;
    int ambito;
} Simbolo;

static Simbolo tabla[MAX_SIMB];
static int ntabla = 0;
static int ambito_actual = 0;

void entrar_ambito() {
    ambito_actual++;
}

void salir_ambito() {
    for (int i = 0; i < ntabla; i++) {
        if (tabla[i].ambito == ambito_actual) {
            tabla[i].nombre[0] = '\0';
        }
    }
    ambito_actual--;
}

void agregar_variable(char *id) {
    for (int i = 0; i < ntabla; i++) {
        if (strcmp(tabla[i].nombre, id) == 0 &&
            tabla[i].ambito == ambito_actual) {
            printf("Error: redeclaración de '%s'\n", id);
            return;
        }
    }
    tabla[ntabla++] = (Simbolo){ strdup(id), 0, 0, ambito_actual };
}

void agregar_funcion(char *id, int aridad) {
    for (int i = 0; i < ntabla; i++) {
        if (strcmp(tabla[i].nombre, id) == 0 &&
            tabla[i].tipo == 1 &&
            tabla[i].ambito == 0) {
            printf("Error: función '%s' ya declarada\n", id);
            return;
        }
    }
    tabla[ntabla++] = (Simbolo){ strdup(id), 1, aridad, 0 };
}

int buscar_variable(char *id) {
    for (int nivel = ambito_actual; nivel >= 0; nivel--) {
        for (int i = 0; i < ntabla; i++) {
            if (tabla[i].ambito == nivel &&
                tabla[i].tipo == 0 &&
                strcmp(tabla[i].nombre, id) == 0) {
                return 1;
            }
        }
    }
    return 0;
}

int buscar_funcion(char *id) {
    for (int i = 0; i < ntabla; i++) {
        if (tabla[i].tipo == 1 &&
            strcmp(tabla[i].nombre, id) == 0) {
            return tabla[i].aridad;
        }
    }
    return -1;
}
%}

%union {
    char *str;
    int   num;
}

%token <str> ID
%token INT FUNC RETURN IGUAL
%token PARIZQ PARDER LLAVEIZQ LLAVEDER PUNTOYCOMA COMA

%type <num> parametros lista_param instruccion argumentos lista_args

%%

programa:
    unidades
;

unidades:
      unidad
    | unidades unidad
;

unidad:
      declaracion
    | instruccion
;

declaracion:
      INT ID PUNTOYCOMA          { agregar_variable($2); free($2); }
    | FUNC ID PARIZQ parametros PARDER bloque { agregar_funcion($2, $4); free($2); }
;

parametros:
                                { $$ = 0; }
    | lista_param               { $$ = $1; }
;

lista_param:
      ID                        { agregar_variable($1); $$ = 1; free($1); }
    | lista_param COMA ID        { agregar_variable($3); $$ = $1 + 1; free($3); }
;

bloque:
      LLAVEIZQ { entrar_ambito(); }
        instrucciones
      LLAVEDER { salir_ambito(); }
;

instrucciones:
      instruccion
    | instrucciones instruccion
;

instruccion:
      INT ID PUNTOYCOMA           { agregar_variable($2); free($2); }
    | ID IGUAL ID PUNTOYCOMA      {
            if (!buscar_variable($1) || !buscar_variable($3))
                printf("Error: identificador no declarado\n");
            free($1); free($3);
        }
    | ID PARIZQ argumentos PARDER PUNTOYCOMA {
            int esp = buscar_funcion($1);
            if (esp == -1)
                printf("Error: función '%s' no declarada\n", $1);
            else if (esp != $3)
                printf("Error: función '%s' espera %d argumentos\n", $1, esp);
            free($1);
        }
    | RETURN ID PUNTOYCOMA         {
            if (!buscar_variable($2))
                printf("Error: identificador no declarado\n");
            free($2);
        }
    | bloque
;

argumentos:
                                { $$ = 0; }
    | lista_args                { $$ = $1; }
;

lista_args:
      ID                        { if (!buscar_variable($1)) printf("Error: identificador no declarado\n"); $$ = 1; free($1); }
    | lista_args COMA ID         { if (!buscar_variable($3)) printf("Error: identificador no declarado\n"); $$ = $1 + 1; free($3); }
;

%%

int main(void) {
    return yyparse();
}
