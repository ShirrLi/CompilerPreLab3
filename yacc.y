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
%token NUMBER
%token ADD SUB MUL DIV LPAR RPAR
%left ADD SUB
%left MUL DIV
%right UMINUS
%left RPAR
%right LPAR
%%


lines   :   lines expr ';' { printf("%f\n", $2); }
    |   lines ';'
    |
    ;

expr    :   expr ADD expr   { $$ = $1 + $3; }
    |   expr SUB expr   { $$ = $1 - $3; }
    |   expr MUL expr   { $$ = $1 * $3; }
    |   expr DIV expr   { $$ = $1 / $3; }
    |   LPAR expr RPAR  { $$ = $2; }
    |   SUB expr %prec UMINUS   { $$ =-$2; }
    |   NUMBER  { $$ = $1; }
    ;

%%
// programs section

int yylex()
{
    // place your token retrieving 
    int t;
	while(1){
		t = getchar();
		if(t == ' ' || t == '\t' || t == '\n'){
			;
		}else if(isdigit(t)){
			yylval = 0;
			while(isdigit(t)){
				yylval = yylval * 10 + t - '0';
				t = getchar();
			}
			ungetc(t, stdin);
			return NUMBER;
		}
		else{
			switch(t){
				case '+':
					return ADD;
				case '-':
					return SUB;
				case '*':
					return MUL;
				case '/':
					return DIV;
				case '(':
					return LPAR;
				case ')':
					return RPAR;
				default:
					return t;
			}
		}
	}
}

int main(void)
{
    yyin = stdin;
    do{
        yyparse();
    } while(!feof(yyin));
    return 0;
}
void yyerror(const char* s) {
    fprintf(stderr, "Parse error: %s\n", s);
    exit(1);
}