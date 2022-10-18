%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#ifndef YYSTYPE
#define YYSTYPE char*
#endif

char idStr[50];
char numStr[50];

int yylex();
extern int yyparse();
FILE* yyin; //extern加不加 有啥区别？

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
%token ID

//小括号
%token l_paren
%token r_paren

%left ADD SUB //所以改成ADD有啥区别啊 改了一下翻译方式？
%left MUL DIV
%right UMINUS //what??
//%nonassoc UMINUS

%%

lines	:	lines expr ';' { printf("%s\n", $2); }//把这行打出来然后回车？
		|	lines ';'
		|
		;

expr	:	expr ADD expr { $$ = (char *)malloc(50*sizeof(char)); strcpy($$, $1); strcat($$, $3); strcat($$,"+ "); }
		|	expr SUB expr { $$ = (char *)malloc(50*sizeof(char)); strcpy($$, $1); strcat($$, $3); strcat($$,"- "); }
		|	expr MUL expr { $$ = (char *)malloc(50*sizeof(char)); strcpy($$, $1); strcat($$, $3); strcat($$,"* "); }
		|	expr DIV expr { $$ = (char *)malloc(50*sizeof(char)); strcpy($$, $1); strcat($$, $3); strcat($$,"/ "); }
		|	SUB expr %prec UMINUS { $$ = (char *)malloc(50*sizeof(char)); $$ = strcpy($$, "-"); strcat($$, $2); }
		//添加括号
		|	l_paren expr r_paren  { $$ = (char *)malloc(50*sizeof(char)); $$ = strcpy($$, $2); }
		|	NUMBER { $$ = (char *)malloc(50*sizeof(char)); strcpy($$, $1); strcat($$," "); }
		|	ID { $$ = (char *)malloc(50*sizeof(char)); strcpy($$, $1); strcat($$," "); }
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
			int ti = 0;
			while(t>='0' && t<='9'){
				numStr[ti] = t;
				t = getchar();
				ti++;
			}
			numStr[ti]='\0';
			yylval = numStr;
			ungetc(t,stdin);
			return NUMBER;
		}
		else if(t=='_'||(t>='a'&&t<='z')||(t>='A'&&t<='Z')){
			int ti = 0;
			while((t>='a'&&t<='z')||(t>='A'&&t<='Z')||t=='_'||(t>='0' && t<='9')){
				idStr[ti] = t;
				t = getchar();
				ti++;
			}
			idStr[ti]='\0';
			yylval = idStr;
			ungetc(t,stdin);
			return ID;
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
