%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>
#include <iostream>

#include <map>
#ifndef YYSTYPE
#define YYSTYPE char*
#endif

using namespace std;


int yylex();
extern int yyparse();
int str2int(char* s);
void int2str(int val, char* res);
void strcal(char* c1, char* c2, char* c_res, char op);
FILE* yyin; 

// 全局符号表声明
map<string, int> id_val;

char idStr[50];
char numStr[50];

void yyerror(const char* s);
%}

//优先级 ↓

//运算符
%token ADD
%token SUB
%token MUL
%token DIV
%token EQUAL

//整数
%token NUMBER
%token ID

//小括号
%token l_paren
%token r_paren

%left ADD SUB //所以改成ADD有啥区别啊 改了一下翻译方式？
%left MUL DIV
%right UMINUS //what??
%right EQUAL

%%

lines	:	lines statement ';' { printf("%s\n", $2); }//把这行打出来然后回车？
		|	lines ';'
		|
		;

statement	:	ID EQUAL expr{ printf("a equation!"); $$ = (char *)malloc(50*sizeof(char)); $$ = strcpy($$, $3);
								string tmp = $1;
								id_val[tmp]=str2int($3);//存表
								//printf("%d", id_val[$1]);
						  }//改一下这里
			|	expr
			;

expr	:	expr ADD expr { $$ = (char *)malloc(50*sizeof(char)); strcal($1, $3, $$, '+'); }
		|	expr SUB expr { $$ = (char *)malloc(50*sizeof(char)); strcal($1, $3, $$, '-'); }
		|	expr MUL expr { $$ = (char *)malloc(50*sizeof(char)); strcal($1, $3, $$, '*'); }
		|	expr DIV expr { $$ = (char *)malloc(50*sizeof(char)); strcal($1, $3, $$, '/'); }
		|	ID EQUAL expr 
		|	l_paren expr r_paren  { $$ = (char *)malloc(50*sizeof(char)); $$ = strcpy($$, $2); }
		|	'-' expr %prec UMINUS { $$ = (char *)malloc(50*sizeof(char)); $$ = "-"; strcat($$, $2); }
		|	NUMBER { $$ = (char *)malloc(50*sizeof(char)); $$ = strcpy($$, $1);} //malloc太重要了... 一定要深拷贝。
		|   ID { $$ = (char *)malloc(50*sizeof(char)); 
					if (id_val.find($1) == id_val.end()){
						$$="";
					}
					else{
						int2str(id_val[$1], $$);
					}
				}
		;

%%

int str2int(char* s){
	int res=0.0;
	for(int i=0; i<strlen(s); i++){
		res = res * 10 + s[i] - '0';
	}
	return res;
}
void int2str(int val, char* res){
	char tmp[50]={};
	int i=0;
	while(val!=0){
		int re = val%10;
		tmp[i] = (char)(re+'0');
		val/=10;
		i++;
	}
	tmp[i]='\0';
	res[i]='\0';
	int len=i-1;
	i--;
	for(i; i>=0; i--){
		res[len-i]=tmp[i];
	}
}

void strcal(char* c1, char* c2, char* c_res, char op){
	int v1 = str2int(c1);
	int v2 = str2int(c2);
	//printf("%s", c1);
	//printf("%s", c2);
	int v_res;
	if(op=='+')
		v_res = v1+v2;
	else if(op=='-')
		v_res = v1-v2;
	else if(op=='*')
		v_res = v1*v2;
	else{
		v_res = v1/v2;
	}
	char tmp[50]={};
	int i=0;
	while(v_res!=0){
		int re = v_res%10;
		tmp[i] = (char)(re+'0');
		v_res/=10;
		i++;
	}
	tmp[i]='\0';
	c_res[i]='\0';
	int len=i-1;
	i--;
	for(i; i>=0; i--){
		c_res[len-i]=tmp[i];
	}
}

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
			//printf("|%s",idStr);
			ungetc(t,stdin);
			return ID;
		}
		else if(t=='=')
			return EQUAL;
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
