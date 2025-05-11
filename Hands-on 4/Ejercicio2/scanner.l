%{
#include "parser.tab.h"
#include <string.h>
#include <stdlib.h>
%}
%%
"int" { return INT; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.str = strdup(yytext); return ID; }
"=" { return IGUAL; }
";" { return PUNTOYCOMA; }
[ \t\n]+ ;
. { return yytext[0]; }
%%
