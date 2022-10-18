%{
#include "y.tab.h"
#include "ch3hdr.h"
#include <math.h>
#undef yywrap
%}

%%
([0-9]+|([0-9]*\.[0-9]+)([eE][-+]?[0-9]+)?)     {
                yylval.dval = atof(yytext);
                return NUMBER;
        }
[ \t] ;
[A-Za-z][A-Za-z0-9]*    {
                yylval.symp=symlook(yytext);
                return NAME;
        }
"$"     { return 0; }
\n      |
.       return yytext[0];
%%

int yywrap()
{
        return 1;
}

struct symtab *
symlook(char *s){
        char *p;
        struct symtab *sp;
        for(sp=symtab;sp<&symtab[NSYMS];sp++){
                if(sp->name && !strcmp(sp->name,s))
                        return sp;
        if(!sp->name){
                sp->name=strdup(s);
                return sp;
                }
        }
        yyerror("Too many symbols.");
        exit(1);
}

