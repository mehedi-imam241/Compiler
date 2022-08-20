%option noyywrap

%x STRINGSTATE
%x COMMENTSTATE
%x MULTILINECOMMENTSTATE

%{
#include "symbolTablePackage/linkedList/symbolInfo.h"
#include "parser.tab.h"
using namespace std;

int idx;

extern FILE *error_out;

int line_count=1;
int string_start_line;
int comment_start_line;


string str ;
string temp;
extern int errCounter;
extern YYSTYPE yylval;



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

char returnCharFromStr(string yytxt)
{
	// \'\\[n|t|a|f|r|b|v|0|\\|\"]\'
	if(yytxt=="\\n")
	{
		return '\n';
	}
	else if(yytxt=="\\t") {
		return '\t';
	}
	else if(yytxt=="\\a")
	{
		return '\a';
	}
	else if(yytxt=="\\f")
	{
		return '\f';
	}
	else if(yytxt=="\\r")
	{
		return '\r';
	}
	else if(yytxt=="\\b")
	{
		return '\b';
	}
	else if(yytxt=="\\v")
	{
		return '\v';
	}
	else if(yytxt=="\\0")
	{
		return '\0';
	}
	else if(yytxt=="\\\\")
	{
		return '\\';
	}
		else if(yytxt=="\\\"")
	{
		return '\"';
	}
	return 0;
}

%}

WHITESPACE [ \t\f\r\v]+ 
CHARACTER [a-zA-Z0-9]
NEWLINE \n

%%
{WHITESPACE} {}
{NEWLINE} {line_count++;}


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
"printf" {
			return PRINTLN;
}
		
[+-]  {
			symbolINfo *s= new  symbolINfo(yytext, "ADDOP");
			yylval.smbl = s;
			return ADDOP;
}

[*/%]  {
			symbolINfo *s= new  symbolINfo(yytext, "MULOP");
			yylval.smbl = s;
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
		symbolINfo *s= new  symbolINfo(yytext, "RELOP");
		yylval.smbl = s;
		return RELOP;
}

"=" {
		return ASSIGNOP;
}

"&&" |
"||" {
		symbolINfo *s= new  symbolINfo(yytext, "LOGICOP");
		yylval.smbl = s;
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
	symbolINfo *s = new symbolINfo(yytext, "CONST_INT");
	yylval.smbl = s;
	return CONST_INT;
}

([0-9]+([.][0-9]*)?(E[+-]?[0-9]+)?|[.][0-9]+(E[+-]?[0-9]+)?) {
	symbolINfo *s = new symbolINfo(yytext, "CONST_FLOAT");
	yylval.smbl = s;
	return CONST_FLOAT;
}

[_a-zA-Z][_a-zA-Z0-9]* {

	symbolINfo *s = new symbolINfo(yytext, "ID");
	yylval.smbl = s;
	return ID;

}

\'\\\' {
	errCounter++;
	fprintf(error_out,"\nError at line %d: Unfinished character in %s\n",line_count,yytext);
}

\'.\' {
			str.clear();
			str.push_back(yytext[1]);
			symbolINfo *temp = new symbolINfo(str, "CONST_CHAR");
			yylval.smbl = temp;
			return CONST_CHAR;
}
\'\\[n|t|a|f|r|b|v|0|\\|\"]\' {
			str.clear();
			str.push_back(returnChar(yytext));
			symbolINfo *temp = new symbolINfo(str, "CONST_CHAR");
			yylval.smbl = temp;
			return CONST_CHAR;
}

\"	{
		BEGIN STRINGSTATE;
		string_start_line = line_count;
		str.clear();
		str.push_back('\"');
		temp.clear();
		temp.push_back('\"');
	}

<STRINGSTATE>\n	{
		line_count++;
		errCounter++;
		temp.push_back(yytext[0]);
		fprintf(error_out,"\nError at line %d: Unterminated string %s\n",string_start_line,temp.c_str());
		BEGIN INITIAL;
	}

<STRINGSTATE>\\\n {
		line_count++;
		temp.push_back(yytext[0]);
		str.push_back(' ');
}


<STRINGSTATE>\\[n|t|a|f|r|b|v|0|\\|\"] {
	    temp.push_back(yytext[0]);
		str.push_back(returnCharFromStr(yytext));
}

<STRINGSTATE>\" {
		str.push_back('\"');
		symbolINfo *temp = new symbolINfo(str, "STRING");

		str.clear();
		BEGIN INITIAL;
}

<STRINGSTATE>. {
		temp.push_back(yytext[0]);
		str.push_back(yytext[0]);	
}

"//" {
	BEGIN COMMENTSTATE;
	temp.clear();
	temp.append(yytext);
	comment_start_line = line_count;
}

<COMMENTSTATE>\\\n {
	line_count++;
	temp.append(yytext);
}

<COMMENTSTATE>\n {
	line_count++;
	BEGIN INITIAL;
	temp.append(yytext);
	temp.clear();
}


<COMMENTSTATE>. {
	temp.append(yytext);
}

"/*" {
	BEGIN MULTILINECOMMENTSTATE;
	temp.clear();
	temp.append(yytext);
	comment_start_line = line_count;
}
<MULTILINECOMMENTSTATE>\n {
	line_count++;
	temp.append(yytext);
}

<MULTILINECOMMENTSTATE><<EOF>> {
		errCounter++;
		fprintf(error_out,"\nError at line %d: Unterminated comment %s\n",comment_start_line,temp.c_str());
		yyterminate();
}

<MULTILINECOMMENTSTATE>. {
	temp.append(yytext);
}

<MULTILINECOMMENTSTATE>"*/" {
	temp.append(yytext);
	BEGIN INITIAL;
	temp.clear();
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
