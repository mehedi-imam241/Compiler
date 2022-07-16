%option noyywrap

%x STRINGSTATE
%x COMMENTSTATE
%x MULTILINECOMMENTSTATE

%{
#include "symbolTablePackage/globals.h"
#include "symbolTablePackage/symbolTable.cpp"

int totalBuckets;

int idx;

int line_count=1;
int string_start_line;
int comment_start_line;

symbolTable smtbl;
string str ;
string temp;
int errCounter = 0;

void printKeyword(string yytxt)
{
	str = yytxt;
	transform(str.begin(), str.end(),str.begin(), ::toupper);
	fprintf(tokenout,"<%s>",str.c_str());
	fprintf(logout,"\nLine no %d: TOKEN <%s> Lexeme %s found\n",line_count,str.c_str(),yytxt.c_str());
}

void printSymbol(string type, string yytxt)
{
	fprintf(tokenout,"<%s,%s>",type.c_str(),yytxt.c_str());
	fprintf(logout,"\nLine no %d: TOKEN <%s> Lexeme %s found\n",line_count,type.c_str(),yytxt.c_str());
}

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
		return '\b';
	}
	else if(yytxt=="\'\\0\'")
	{
		return '\b';
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
		return '\b';
	}
	else if(yytxt=="\\0")
	{
		return '\b';
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


"if" |
"else" |
"for" |
"while" |
"do" |
"break" |
"int" |
"char" |
"float" |
"double" |
"void" |
"return" |
"switch" |
"case" |
"default" |
"continue"  {
			printKeyword(yytext);
}
		
"+"	|
"-"	{
			printSymbol("ADDOP",yytext);
}

"*" | 
"/" |
"%" {
			printSymbol("MULOP",yytext);
}

"++" |
"--" {
			printSymbol("INCOP",yytext);
}

"<" |
"<=" |
">" |
">=" |
"==" |
"!=" {
		printSymbol("RELOP",yytext);
}
"=" {
		printSymbol("ASSIGNOP",yytext);
}

"&&" |
"||" {
		printSymbol("LOGICOP",yytext);
} 
"!" {
		printSymbol("NOT",yytext);
}

"(" {
		printSymbol("LPAREN",yytext);
}
")" {
		printSymbol("RPAREN",yytext);	
}
"{" {
		smtbl.enterScope();
		printSymbol("LCURL",yytext);
}
"}" {
		smtbl.exitScope();
		printSymbol("RCURL",yytext);
}
"[" {
		printSymbol("LTHIRD",yytext);	
}
"]" {
		printSymbol("RTHIRD",yytext);	
}
"," {
		printSymbol("COMMA",yytext);
}
";" {
		printSymbol("SEMICOLON",yytext);
}

[0-9]+ {
		printSymbol("CONST_INT",yytext);

		if(smtbl.insert(str,"CONST_INT"))
			smtbl.printAllScopeTable();
}

([0-9]+([.][0-9]*)?(E[+-]?[0-9]+)?|[.][0-9]+(E[+-]?[0-9]+)?) {
	printSymbol("CONST_FLOAT",yytext);
	if(smtbl.insert(str,"CONST_FLOAT"))
		smtbl.printAllScopeTable();

}

[_a-zA-Z][_a-zA-Z0-9]* {

	printSymbol("ID",yytext);

	if(smtbl.insert(yytext,"ID"))
		smtbl.printAllScopeTable();

}

\'\\\' {
	errCounter++;
	fprintf(logout,"\nError at line %d: Unfinished character in %s\n",line_count,yytext);
}

\'.\' {
	str.clear();
	str.push_back(yytext[1]);

	fprintf(tokenout,"<%s,%s>","CONST_CHAR",str.c_str());
	fprintf(logout,"\nLine no %d: TOKEN <CONST_CHAR> Lexeme %s found --> <CONST_CHAR,%s>\n",line_count,yytext,str.c_str());


	if(smtbl.insert(yytext,"CONST_CHAR"))
	smtbl.printAllScopeTable();
}
\'\\[n|t|a|f|r|b|v|0|\\|\"]\' {

	fprintf(tokenout,"<%s,%c>","CONST_CHAR",returnChar(yytext));
	fprintf(logout,"\nLine no %d: TOKEN <CONST_CHAR> Lexeme %s found --> <CONST_CHAR,%c>\n",line_count,yytext,returnChar(yytext));

	if(smtbl.insert(yytext,"CONST_CHAR"))
		smtbl.printAllScopeTable();
}

\"	{
		BEGIN STRINGSTATE;
		string_start_line = line_count;
		str.clear();
		temp.clear();
		temp.append(yytext);
	}

<STRINGSTATE>\n	{
		line_count++;
		errCounter++;
		fprintf(logout,"\nError at line %d: Unterminated string %s\n",string_start_line,temp.c_str());
		BEGIN INITIAL;
	}

<STRINGSTATE>\\\n {
		line_count++;
		str.push_back(' ');
		temp.push_back('\n');
}


<STRINGSTATE>\\[n|t|a|f|r|b|v|0|\\|\"] {
		str.push_back(returnCharFromStr(yytext));
		temp.append(yytext);
}

<STRINGSTATE>\" {
		temp.append(yytext);

		fprintf(tokenout,"<STRING,%s>",str.c_str());
		fprintf(logout,"\nLine no %d: TOKEN <STRING> Lexeme %s found --> <STRING,%s>\n",string_start_line,temp.c_str(),str.c_str());

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
	fprintf(logout,"\nLine no %d: comment found %s\n",comment_start_line,temp.c_str());
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
		fprintf(logout,"\nError at line %d: Unterminated comment %s\n",comment_start_line,temp.c_str());
		yyterminate();
}

<MULTILINECOMMENTSTATE>. {
	temp.append(yytext);
}

<MULTILINECOMMENTSTATE>"*/" {
	temp.append(yytext);
	fprintf(logout,"\nLine no %d: comment found %s\n",comment_start_line,temp.c_str());
	BEGIN INITIAL;
	temp.clear();
}

[0-9]*\.[0-9]*(\.[0-9]*)+ {
	errCounter++;
	fprintf(logout,"\nError at line %d: Too many decimal points in number %s\n",line_count,yytext);
}

[0-9]+[_a-zA-Z][_a-zA-Z0-9]* {
	errCounter++;
	fprintf(logout,"\nError at line %d: Invalid Suffix on numeric constant or invalid prefix on identifier %s\n",line_count,yytext);
}

[0-9]+E[0-9]*\.[0-9]* {
	errCounter++;
	fprintf(logout,"\nError at line %d: Ill formed number %s\n",line_count,yytext);
}

\'.{2,}\' {
	errCounter++;
	fprintf(logout,"\nError at line %d: Multi character constant error in %s\n",line_count,yytext);
}

\'\' {
	errCounter++;
	fprintf(logout,"\nError at line %d: Empty character constant error in %s\n",line_count,yytext);
}

\'[^\'\n]+ {
	errCounter++;
	fprintf(logout,"\nError at line %d: Unfinished character in %s\n",line_count,yytext);
}
. {
	errCounter++;
	fprintf(logout,"\nError at line %d: Unrcognized character in %s\n",line_count,yytext);
}

%%

int main(int argc,char *argv[]){
	
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
	logout= fopen("log.txt","w");
	tokenout= fopen("token.txt","w");

	yyin= fin;
	yylex();

	smtbl.printAllScopeTable();
	fprintf(logout,"\nTotal Lines: %d\n",line_count);
	fprintf(logout,"Total errors: %d\n",errCounter);

	fclose(yyin);
	fclose(tokenout);
	fclose(logout);

	return 0;
}
