%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <float.h>
#ifndef YYSTYPE
#define YYSTYPE double
#endif
struct symtab {
	char *name;
	double value;
}tab[100];
char idStr[50];
int yylex();
extern int yyparse();
FILE* yyin;
void yyerror(const char* s);
%}
%token NUMBER
%token ID
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
    |   ID '=' NUMBER   { 
			$1 = $3;
			insert($1,$3); 
			printf("%f,%f\n", $1,$3);
		}
    |   NUMBER  { $$ = $1; }
    |   ID    { $$ = $1; }
    ;

%%
// programs section
int find(char *s){
	printf("%s\n", s);
	for(int i=0;i;i++){
		printf("for %u",i);
		if(tab[i].value == 0){
			return 0;
			printf("return 0");
		}
		if(tab[i].name == s)
			return tab[i].value,
			printf("return value");
	}
}

void insert(char *n, double v){
	printf("insert%f,%f\n",n,v);
	for(int i=0;i;i++){
		if(tab[i].value == 0){
			tab[i].name = (char *)malloc(100);
			strcpy(tab[i].name, n);
			tab[i].value = v;
		}
	}
}

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
		}if((t >= 'a' && t <= 'z')||(t >= 'A' && t <= 'Z')||(t == '_')){
            int ti=0;
            while((t >= 'a' && t <= 'z')||(t >= 'A' && t <= 'Z')||(t == '_')||(t >= '0' && t <= '9')){
                idStr[ti] = t;
                ti++;
                t = getchar();
            }
            idStr[ti] = '\0';
            yylval = find(idStr);
			ungetc(t, stdin);
			return ID;
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