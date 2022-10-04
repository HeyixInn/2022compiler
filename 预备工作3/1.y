%{

#include <stdio.h>
#include <stdlib.h>
#ifndef YYSTYPE
#define YYSTYPE double
#endif


int yylex();
extern int yyparse();
FILE* yyin; //extern加不加 有啥区别？

void yyerror(const char* s);
%}

//优先级 ↓
%token ADD
%left ADD '-' //所以改成ADD有啥区别啊 改了一下翻译方式？
%left '*' '/'
%right UMINUS //what??

%%

lines	:	lines expr '\n' { printf("%f\n", $2); }//把这行打出来然后回车？
		|	lines '\n'
		|
		;

expr	:	expr ADD expr { $$ = $1 + $3; }
		|	expr '-' expr { $$ = $1 - $3; }
		|	expr '*' expr { $$ = $1 * $3; }
		|	expr '/' expr { $$ = $1 / $3; }
		|	'(' expr ')'  { $$ = $2; }
		|	'-' expr %prec UMINUS { $$ = -$2; }
		|	NUMBER
		;

NUMBER	:	'0'				{ $$ = 0.0; }
		|	'1'				{ $$ = 1.0; }
		|	'2'				{ $$ = 2.0; }
		|	'3'				{ $$ = 3.0; }
		|	'4'				{ $$ = 4.0; }
		|	'5'				{ $$ = 5.0; }
		|	'6'				{ $$ = 6.0; }
		|	'7'				{ $$ = 7.0; }
		|	'8'				{ $$ = 8.0; }
		|	'9'				{ $$ = 9.0; }
		;

%%

//program section
int yylex(){
	//place your token retricing code here
	//return getchar();
	int t;
	t=getchar();
	if(t=='+')
		return ADD;
	else
		return t;
}


int main() {
	yyin = stdin;

	do {
		yyparse();
	} while(!feof(yyin));

	return 0;
}

void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s\n", s);
	exit(1);
}
