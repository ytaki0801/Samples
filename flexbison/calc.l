%{
#include "calc.tab.h"
void yyerror(char *);
%}

%%
"+"     return(ADDOP);
"-"     return(SUBOP);
"*"     return(MULOP);
"/"     return(DIVOP);
"("     return(LP);
")"     return(RP);
\n      return(NL);
[0-9]+ { yylval = atoi(yytext); return(NUMBER); }
.       ;
%%

void yyerror(char *msg) { printf("%s at '%c'\n", msg, *yytext); exit(1); }
