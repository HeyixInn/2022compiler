%{
#include "stdio.h"
#include "ch3hdr.h"
#include <string.h>
%}

%union {
        double  dval;
        struct symtab *symp;
}

%token <symp> NAME
%token <dval> NUMBER
%left '-' '+'
%left '*' '/'
%nonassoc UMINUS

%type <dval> expression

%%
statement_list: statement '\n'
        |       statement_list statement '\n'

statement:      NAME '=' expression     { $1->value=$3; }
        |       expression              { printf("=%g\n",$1); }
        ;

expression:     expression '+' expression       { $$=$1+$3; }
        |       expression '-' expression       { $$=$1-$3; }
        |       expression '*' expression       { $$=$1*$3; }
        |       expression '/' expression
        { if($3==0.0)
                yyerror("divided by zero.\n");
          else
                $$=$1 / $3;
        }
        |       '-' expression %prec UMINUS     { $$ = -$2; }
        |       '(' expression ')'              { $$ = $2; }
        |       NUMBER                          { $$ = $1; }
        |       NAME                            { $$ = $1->value; }

%%

int main(){
        yyparse();
        return 0;
}

void yyerror(char *s){
        fprintf(stderr,"%s\n",s);
}
