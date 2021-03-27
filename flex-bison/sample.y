%{
#include <stdio.h>
extern int yylex(void);
extern int yyerror(const char* s);
%}

%token NUM EOL ADD SUB MUL DIV LPB RPB

%%

list	:
	| list expr EOL { printf("%d\n", $2); }
	;

expr	: expr ADD expr	{ $$ = $1 + $3; }
	| expr SUB expr	{ $$ = $1 - $3; }
	| expr MUL expr	{ $$ = $1 * $3; }
	| expr DIV expr	{ $$ = $1 / $3; }
	| LPB expr RPB	{ $$ = $2; }
	| NUM		{ $$ = $1; }
	;

%%

#include "lex.yy.c"
int yyerror(const char* s)
{
  printf("%s\n", s);
  return 0;
}
int main(void) { yyparse(); }

