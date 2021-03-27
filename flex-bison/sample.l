%%

"+"	{ return(ADD); }
"-"	{ return(SUB); }
"*"	{ return(MUL); }
"/"	{ return(DIV); }
"("	{ return(LPB); }
")"	{ return(RPB); }
\n	{ return(EOL); }
[0-9]+	{ yylval = atoi(yytext); return(NUM); }
.	;

%%

