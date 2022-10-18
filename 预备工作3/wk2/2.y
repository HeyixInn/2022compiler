%{

#include <stdio.h>
#include <stdlib.h>
#ifndef YYSTYPE
#define YYSTYPE double
#endif


int yylex();
extern int yyparse();
FILE* yyin; 

void yyerror(const char* s);
%}

//优先级 ↓

//运算符
%token ADD
%token SUB
%token MUL
%token DIV

//整数
%token NUMBER

//小括号
%token l_paren
%token r_paren

%left ADD SUB //所以改成ADD有啥区别啊 改了一下翻译方式？
%left MUL DIV
%right UMINUS //what??

%%

lines	:	lines expr ';' { printf("%f\n", $2); }//把这行打出来然后回车？
		|	lines ';'
		|
		;

expr	:	expr ADD expr { $$ = $1 + $3; }
		|	expr SUB expr { $$ = $1 - $3; }
		|	expr MUL expr { $$ = $1 * $3; }
		|	expr DIV expr { $$ = $1 / $3; }
		|	l_paren expr r_paren  { $$ = $2; }
		|	SUB expr %prec UMINUS { $$ = -$2; }
		|	NUMBER { $$ = $1; }
		;

/*NUMBER	:	'0'				{ $$ = 0.0; }
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
*/
%%

//program section
int yylex(){
	//place your token retricing code here
	//return getchar();
	int t;
	while(1){
		t=getchar();
		if(t==' '||t=='\n'||t=='\t'){
			//do nothing
		}
		else if(t>='0' && t<='9'){
			yylval = 0;
			while(t>='0' && t<='9'){
				yylval = yylval * 10 + t - '0';
				t = getchar();
			}
			ungetc(t,stdin);
			return NUMBER;
		}
		else if(t=='+')
			return ADD;
		else if(t=='-')
			return SUB;
		else if(t=='*')
			return MUL;
		else if(t=='/')
			return DIV;
		else if(t=='(')
			return l_paren;
		else if(t==')')
			return r_paren;
		else
			return t;
	}
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
