%option noyywrap 

%{
#include<bits/stdc++.h>
#include "S1705058_SymbolInfo.h"
#include "1805039.tab.h"
using namespace std;

extern YYSTYPE yylval;
extern FILE* error_out;

int line_count = 1;
int LineStart = 1;
int errCounter = 0;
string str ;



int returnChar(string yytxt)
{
	// \'\\[n|t|a|f|r|b|v|0|\\|\"]\'
	if(yytxt=="\'\\n\'")
	{
		return '\n';
	}
	else if(yytxt=="\'\\t\'") {
		return '\t';
	}
	else if(yytxt=="\'\\a\'")
	{
		return '\a';
	}
	else if(yytxt=="\'\\f\'")
	{
		return '\f';
	}
	else if(yytxt=="\'\\r\'")
	{
		return '\r';
	}
	else if(yytxt=="\'\\b\'")
	{
		return '\b';
	}
	else if(yytxt=="\'\\v\'")
	{
		return '\v';
	}
	else if(yytxt=="\'\\0\'")
	{
		return '\0';
	}
	else if(yytxt=="\'\\\\\'")
	{
		return '\\';
	}
	else if(yytxt=="\'\\\"\'")
	{
		return '\"';
	}
	return 0;
}

%}

WHITESPACE [ \t\f\r\v]+ 
NEWLINE \n

%%
{WHITESPACE} {}
{NEWLINE} {line_count++;}

"println" | 
"printf" {
	return PRINTLN;
}


"if" {
			return IF;
}
		
"else" {
			return ELSE;
}

"for" {
			return FOR;
}

"do" {
			return DO;
}

"int" {
			return INT;
}

"float"	{
			return FLOAT;
}

"void" {
			return VOID;
}

"default" {
			return DEFAULT;
}

"switch" {
			return SWITCH;
}

"while"	{
			return WHILE;
}

"break"	{
			return BREAK;
}

"char"	{
			return CHAR;
}

"double" {
			return DOUBLE;
}

"return" {
			return RETURN;
}

"case" {
			return CASE;
}

"continue" {
			return CONTINUE;
}
		
[+-]  {
			SymbolInfo *s= new  SymbolInfo(yytext, "ADDOP");
			yylval.Symbol = s;
			return ADDOP;
}

[*/%]  {
			SymbolInfo *s= new  SymbolInfo(yytext, "MULOP");
			yylval.Symbol = s;
			return MULOP;
}

"++" {
			return INCOP;
}

"--" {
			return DECOP;
}

"<" |
"<=" |
">" |
">=" | 
"==" | 
"!=" {
		SymbolInfo *s= new  SymbolInfo(yytext, "RELOP");
		yylval.Symbol = s;
		return RELOP;
}

"=" {
		return ASSIGNOP;
}

"&&" |
"||" {
		SymbolInfo *s= new  SymbolInfo(yytext, "LOGICOP");
		yylval.Symbol = s;
		return LOGICOP;
} 

"!"		{
			return NOT;
}

"("		{	
			return LPAREN;	
}

")" {
			return RPAREN;		
}

"{" {
			return LCURL;		
}

"}" {
			return RCURL;	
}

"[" {
			return LTHIRD;		
}

"]" {
			return RTHIRD;			
}

"," {
			return COMMA;	
}

";" {
			return SEMICOLON;	
}

[0-9]+ {
	SymbolInfo *s = new SymbolInfo(yytext, "CONST_INT");
	yylval.Symbol = s;
	return CONST_INT;
}

([0-9]+([.][0-9]*)?(E[+-]?[0-9]+)?|[.][0-9]+(E[+-]?[0-9]+)?) {
	SymbolInfo *s = new SymbolInfo(yytext, "CONST_FLOAT");
	yylval.Symbol = s;
	return CONST_FLOAT;
}

[_a-zA-Z][_a-zA-Z0-9]* {

	SymbolInfo *s = new SymbolInfo(yytext, "ID");
	yylval.Symbol = s;
	return ID;

}

\'\\\' {
	errCounter++;
	fprintf(error_out,"\nError at line %d: Unfinished character in %s\n",line_count,yytext);
}

\'.\' {
			str.clear();
			str.push_back(yytext[1]);
			SymbolInfo *temp = new SymbolInfo(str, "CONST_CHAR");
			yylval.Symbol = temp;
			return CONST_CHAR;
}
\'\\[n|t|a|f|r|b|v|0|\\|\"]\' {
			str.clear();
			str.push_back(returnChar(yytext));
			SymbolInfo *temp = new SymbolInfo(str, "CONST_CHAR");
			yylval.Symbol = temp;
			return CONST_CHAR;
}



[0-9]*\.[0-9]*(\.[0-9]*)+ {
	errCounter++;
	fprintf(error_out,"\nError at line %d: Too many decimal points in number %s\n",line_count,yytext);
}

[0-9]+[_a-zA-Z][_a-zA-Z0-9]* {
	errCounter++;
	fprintf(error_out,"\nError at line %d: Invalid Suffix on numeric constant or invalid prefix on identifier %s\n",line_count,yytext);
}

[0-9]+E[0-9]*\.[0-9]* {
	errCounter++;
	fprintf(error_out,"\nError at line %d: Ill formed number %s\n",line_count,yytext);
}

\'.{2,}\' {
	errCounter++;
	fprintf(error_out,"\nError at line %d: Multi character constant error in %s\n",line_count,yytext);
}

\'\' {
	errCounter++;
	fprintf(error_out,"\nError at line %d: Empty character constant error in %s\n",line_count,yytext);
}

\'[^\'\n]+ {
	errCounter++;
	fprintf(error_out,"\nError at line %d: Unfinished character in %s\n",line_count,yytext);
}
. {
	errCounter++;
	fprintf(error_out,"\nError at line %d: Unrcognized character in %s\n",line_count,yytext);
}

%%

/* int main(int argc,char *argv[]){
	
	if(argc!=2){
		printf("Please provide input file name and try again\n");
		return 0;
	}
	
	FILE *fin=fopen(argv[1],"r");
	if(fin==NULL){
		printf("Cannot open specified file\n");
		return 0;
	}
	totalBuckets = 7;
	error_out= fopen("log.txt","w");
	tokenout= fopen("token.txt","w");
	yyin= fin;
	yylex();
	smtbl.printAllScopeTable();
	fprintf(error_out,"\nTotal Lines: %d\n",line_count);
	fprintf(error_out,"Total errors: %d\n",errCounter);
	fclose(yyin);
	fclose(tokenout);
	fclose(error_out);
	return 0;
} */