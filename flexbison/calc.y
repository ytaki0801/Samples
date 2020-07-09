%{
extern int yylex(void);
extern void yyerror(char *);
#define YYSVAL int
#include <stdio.h>
%}

%token  NL
%token  NUMBER
%token  LP RP
%token  ADDOP SUBOP MULOP DIVOP

%%
s      : list
       ;
list   : 
       | list expr NL    { printf("%d\n", $2); }
       ;
expr   : expr ADDOP expr { $$ = $1 + $3; }
       | expr SUBOP expr { $$ = $1 - $3; }
       | expr MULOP expr { $$ = $1 * $3; }
       | expr DIVOP expr { $$ = $1 / $3; }
       | LP expr RP      { $$ = $2; }
       | NUMBER          { $$ = $1; }
       ;
%%

int main(void) { return yyparse(); }
