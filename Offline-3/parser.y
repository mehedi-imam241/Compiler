%{
#include "symbolTablePackage/globals.h"
#include "symbolTablePackage/symbolTable.cpp"
using namespace std;

int yyparse(void);
int yylex(void);
extern FILE *yyin;
extern int line_count;
FILE* error_out;

symbolTable table;

int errCounter = 0;
string lastDeclaredType;

void yyerror(char *s)
{	
	fprintf(error_out, "line no. %d: Error no. %d found\n%s\n", line_count, errCounter, s);
    errCounter++;
}


%}

%union 
{
	symbolINfo *smbl;
}

%token PRINTLN IF ELSE FOR DO INT FLOAT VOID DEFAULT SWITCH WHILE BREAK CHAR DOUBLE RETURN CASE CONTINUE INCOP DECOP ASSIGNOP NOT LPAREN RPAREN LCURL RCURL LTHIRD RTHIRD COMMA SEMICOLON 

%token <smbl> COMMENT
%token <smbl> ADDOP
%token <smbl> MULOP
%token <smbl> RELOP
%token <smbl> LOGICOP
%token <smbl> BITOP
%token <smbl> CONST_CHAR
%token <smbl> CONST_INT
%token <smbl> CONST_FLOAT
%token <smbl> ID
%token <smbl> STRING


%type <smbl> start program compound_statement type_specifier parameter_list declaration_list var_declaration unit func_declaration statement statements variable expression factor arguments argument_list expression_statement unary_expression simple_expression logic_expression rel_expression term func_definition 

%nonassoc LOWER_THAN_ELSE ELSE

%%

start : program
	{
		fprintf(logout,"line no. %d: start : program\n\n",line_count);

		symbolINfo *s = new symbolINfo($1->getName(), "start");
		$$ = s;

		fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
	;

program : program unit 
	{
		fprintf(logout,"line no. %d: program : program unit\n\n",line_count);

		$1->setName($1->getName() + "\n" + $2->getName());
		fprintf(logout, "%s\n\n", $1->getName().c_str());

		$$=$1;
	} 
	| unit 
	{
		fprintf(logout,"line no. %d: program : unit\n\n",line_count);

		symbolINfo *s = new symbolINfo($1->getName(), "program");
		$$ = s;

		fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
	;
	
unit : var_declaration 
	{
		fprintf(logout,"line no. %d: unit: var_declaration\n\n",line_count);

		symbolINfo *s = new symbolINfo('\n' + $1->getName(), "unit");
		$$ = s;

		fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
    | func_declaration 
    {
     	fprintf(logout,"line no. %d: unit: func_declaration\n\n",line_count);

     	symbolINfo *s = new symbolINfo('\n' + $1->getName(), "unit");
		$$ = s;

		fprintf(logout, "%s\n\n", $$->getName().c_str());
    }
    | func_definition 
    {
     	fprintf(logout,"line no. %d: unit: func_definition\n\n",line_count);

     	symbolINfo *s = new symbolINfo('\n' + $1->getName(), "unit");
		$$ = s;

		fprintf(logout, "%s\n\n", $$->getName().c_str());
    }
    ;
     
func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON 
	{
		fprintf(logout,"line no. %d: func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON\n\n",line_count);
		
		string line = $1->getName() + $2->getName() + "(" + $4->getName() + ");";

		symbolINfo *s = new symbolINfo(line, "func_declaration");
		$$ = s;

		fprintf(logout, "%s\n\n", $$->getName().c_str());

		$2->setReturnType($1->getVariableType());
		//cout << $2->getName() << " " << $2->returnType << endl;

		string id = "ID";

		if (!table.insert($2->getName(), id))
		{
			errCounter++;
			fprintf(error_out, "Error no. %d at line no. %d\nAlready Exists\n\n", errCounter, line_count);
		}

		//table.printCur(logout);
	}
	| type_specifier ID LPAREN RPAREN SEMICOLON 
	{
			fprintf(logout, "Line no. %d: func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON\n\n", line_count);
			
			string id = "ID";
			symbolINfo* Sym = new symbolINfo($2->getName(), id);
			
			// This Function Is Already Declared Once
			if(!table.insert($2->getName(),id)){
				fprintf(error_out, "Error at Line %d: Previous Declaration of Function \'%s\' Found\n\n", line_count, $2->getName().c_str());
				errCounter++;
			}
			
			string Line = "";
			Line += $1->getName() + " " + $2->getName() + "();";
			
			symbolINfo* sym = new symbolINfo(Line, "function_declaration");
			$$ = sym;
			
			fprintf(logout, "%s\n\n", Line.c_str());
			

	}
	;
		 
func_definition : type_specifier ID LPAREN parameter_list RPAREN {table.enterScope();} compound_statement 
	{
		// fprintf(logout,"line no. %d: func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement \n\n",line_count);

		// string line = $1->getName() + $2->getName() + "(" + $4->getName() + ")" + $7->getName();

		// symbolINfo *s = new symbolINfo(line, "func_definition");
		// $$ = s;

		// $2->returnType = $1->varType;
		// //cout << $2->getName() << " " << $2->returnType << endl;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());

		// for(int i = 0; i < paramList.size(); i++)
		// {
		// 	table.insertSymbol(paramList[i]->getName(), "ID", 0);
		// }

		// paramList.clear();

		// table.printCur(logout);
		// table.removeScope();

		// symbolINfo *sInfo = table.srch($2->getName());

		// if(sInfo == NULL)
		// {
		// 	table.insertSymbol($2->getName(), "ID", 0);
		// }

		// symbolINfo = table.srch($2->getName());
		// symbolINfo->returnType = $1->getName();

		// table.printAll(logout);
	}
	| type_specifier ID LPAREN RPAREN {table.enterScope();} compound_statement 
	{
		// fprintf(logout,"line no. %d: func_definition : type_specifier ID LPAREN RPAREN compound_statement\n\n",line_count);
	
		// string line = $1->getName() + $2->getName() + "()" + $6->getName();

		// symbolINfo *s = new symbolINfo(line, "func_definition");
		// $$ = s;

		// $2->returnType = $1->varType;
		// //cout << $2->getName() << " " << $2->returnType << endl;		

		// table.insertSymbol($2->getName(), "ID", 0);

		// symbolINfo = table.srch($2->getName());
		// symbolINfo->returnType = $1->getName();

		// fprintf(logout, "%s\n\n", $$->getName().c_str());

		// table.printCur(logout);
		// table.removeScope();
		// table.printAll(logout);
	}
 	;				


parameter_list : parameter_list COMMA type_specifier ID 
	{
		// fprintf(logout,"line no. %d: parameter_list : parameter_list COMMA type_specifier ID\n\n",line_count);

		// string line = $1->getName() + ", " + $3->getName() + $4->getName();

		// symbolINfo *s = new symbolINfo(line, "parameter_list");
		// $$ = s;

		// $4->varType = variableType;
		// $4->returnType = $3->returnType;
		
		// paramList.push_back($4);

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
	| parameter_list COMMA type_specifier 
	{
		// fprintf(logout,"line no. %d: parameter_list : parameter_list COMMA type_specifier\n\n",line_count);
	
		// string line = $1->getName() + ", " + $3->getName();

		// symbolINfo *s = new symbolINfo(line, "parameter_list");
		// $$ = s;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
 	| type_specifier ID 
 	{
		// fprintf(logout,"line no. %d: parameter_list : type_specifier ID\n\n",line_count);

		// $$->setName($$->getName() + $2->getName());

		// $2->varType = $1->varType;
		
		// paramList.push_back($2);

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
	| type_specifier 
	{
		// fprintf(logout,"line no. %d: parameter_list : type_specifier\n\n",line_count);

		// symbolINfo *s = new symbolINfo($1->getName(), "parameter_list");
		// $$ = s;

		// //$1->varType = variableType;
		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
 	;

 		
compound_statement : LCURL statements RCURL 
	{
		// fprintf(logout,"line no. %d: compound_statement : LCURL statements RCURL\n\n",line_count);

		// symbolINfo *s = new symbolINfo("{\n" + $2->getName() + "\n}", "parameter_list");
		// $$ = s;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
 	| LCURL RCURL 
 	{
		// fprintf(logout,"line no. %d: compound_statement : LCURL RCURL\n\n",line_count);

		// symbolINfo *s = new symbolINfo("{}", "parameter_list");
		// $$ = s;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
 	;
 		    
var_declaration : type_specifier declaration_list SEMICOLON
	{
		// fprintf(logout,"line no. %d: var_declaration : type_specifier declaration_list SEMICOLON\n\n",line_count);
	
		// symbolINfo *s = new symbolINfo($1->getName() + $2->getName() + ";", "parameter_list");
		// $$ = s;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
 	;
 		 
type_specifier : INT
	{
		fprintf(logout,"line no. %d: type_specifier : INT\n\n",line_count);
		fprintf(logout,"int\n\n");

		symbolINfo *s = new symbolINfo("int","type_specifier");
		s->setVariableType("int");
		$$ = s;

		lastDeclaredType = "int";

	}
 	| FLOAT
	{
		// fprintf(logout,"line no. %d: type_specifier : FLOAT\n\n",line_count);

		// symbolINfo *s = new symbolINfo("float ", "type_specifier");
		// $$ = s;

		// variableType = "float";
		
		// $$->varType = "float";

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
 	| VOID
	{
		// fprintf(logout,"line no. %d: type_specifier : VOID\n\n",line_count);

		// symbolINfo *s = new symbolINfo("void ", "type_specifier");
		// $$ = s;

		// variableType = "void";
		
		// $$->varType = "void";

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
 	;
 		
declaration_list : declaration_list COMMA ID
	{
		// fprintf(logout,"line no. %d: declaration_list : declaration_list COMMA ID\n\n",line_count);

		// $$->setName($$->getName() + ", " + $3->getName());

		// fprintf(logout,"%s\n\n", $$->getName().c_str());

		// check = table.insertSymbol($3->getName(), "ID", 0);

		// if (check == false)
		// {
		// 	errCounter++;
		// 	fprintf(error_out, "Error no. %d at line no. %d\nAlready Exists\n\n", errCounter, line_count);
		// }

		// symbolINfo *sInfo = table.srch($3->getName());
		
		// if(variableType != "void")
		// {
		// 	sInfo->varType = variableType;
		// }

		// else 
		// {
		// 	errCounter++;
		// 	fprintf(error_out, "Error no. %d at line no. %d\nVariable type can't be void\n\n", errCounter, line_count);
		// }

		//table.printCur(logout);
	}
 	| declaration_list COMMA ID LTHIRD CONST_INT RTHIRD
	{
		// fprintf(logout,"line no. %d: declaration_list : declaration_list COMMA ID LTHIRD CONST_INT RTHIRD\n\n",line_count);

		// $$->setName($$->getName() + ", " + $3->getName() + "[" + $5->getName() + "]" );

		// fprintf(logout, "%s\n\n", $$->getName().c_str());

		// int number = atoi($5->getName().c_str());

		// check = table.insertSymbol($3->getName(), "ID", number);

		// if (check == false)
		// {
		// 	errCounter++;
		// 	fprintf(error_out, "Error no. %d at line no. %d\nAlready Exists\n\n", errCounter, line_count);
		// }

		// //table.printCur(logout);

		// symbolINfo *sInfo = table.srch($3->getName());
	
		// if(variableType != "void")
		// {
		// 	sInfo->varType = variableType;
		// }

		// else 
		// {
		// 	errCounter++;
		// 	fprintf(error_out, "Error no. %d at line no. %d\nVariable type can't be void\n\n", errCounter, line_count);
		// }
	}
 	| ID
	{
		// fprintf(logout,"line no. %d: declaration_list : ID\n\n",line_count);

		// symbolINfo *s = new symbolINfo($1->getName(),"declaration_list");
		// $$ = s;

		// fprintf(logout,"%s\n\n", $$->getName().c_str());

		// check = table.insertSymbol($1->getName(), "ID", 0);

		// if (check == false)
		// {
		// 	errCounter++;
		// 	fprintf(error_out, "Error no. %d at line no. %d\nAlready Exists\n\n", errCounter, line_count);
		// }

		// symbolINfo *sInfo = table.srch($1->getName());
	
		// if(variableType != "void")
		// {
		// 	sInfo->varType = variableType;
		// }

		// else 
		// {
		// 	errCounter++;
		// 	fprintf(error_out, "Error no. %d at line no. %d\nVariable type can't be void\n\n", errCounter, line_count);
		// }
		

		//table.printCur(logout);
	}
 	| ID LTHIRD CONST_INT RTHIRD
	{
		// fprintf(logout,"line no. %d: declaration_list : ID LTHIRD CONST_INT RTHIRD\n\n",line_count);

		// string line = $1->getName() + "[" + $3->getName() + "]";

		// symbolINfo *s = new symbolINfo(line, "declaration_list");
		// $$ = s;

		// fprintf(logout,"%s\n\n", $$->getName().c_str());

		// int number=atoi($3->getName().c_str());
		
		// check = table.insertSymbol($1->getName(), "ID", number);

		// if (check == false)
		// {
		// 	errCounter++;
		// 	fprintf(error_out, "Error no. %d at line no. %d\nAlready Exists\n\n", errCounter, line_count);
		// }

		// symbolINfo *sInfo = table.srch($1->getName());
		
		// if(variableType != "void")
		// {
		// 	sInfo->varType = variableType;
		// }

		// else 
		// {
		// 	errCounter++;
		// 	fprintf(error_out, "Error no. %d at line no. %d\nVariable type can't be void\n\n", errCounter, line_count);
		// }

		// //table.printCur(logout);
	}
 	;
 		  
statements : statement
	{
		// fprintf(logout,"line no. %d: statements : statement\n\n",line_count);

		// symbolINfo *s = new symbolINfo($1->getName(), "statements");
		// $$ = s;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
    | statements statement
	{
		// fprintf(logout,"line no. %d: statements : statements statement\n\n",line_count);

		// $$->setName($$->getName() + $2->getName());

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
    ;
	   
statement : var_declaration
	{
		fprintf(logout,"line no. %d: statement : var_declaration\n\n",line_count);

		symbolINfo *s = new symbolINfo($1->getName() + '\n', "statement");
		$$ = s;

		fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
	| expression_statement
	{
		// fprintf(logout,"line no. %d: statement : expression_statement\n\n",line_count);

		// symbolINfo *s = new symbolINfo($1->getName()+ '\n', "statement");
		// $$ = s;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
	| compound_statement
	{
		// fprintf(logout,"line no. %d: statement : compound_statement\n\n",line_count);

		// symbolINfo *s = new symbolINfo($1->getName() + '\n', "statement");
		// $$ = s;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
	| FOR LPAREN expression_statement expression_statement expression RPAREN statement
	{
		// fprintf(logout,"line no. %d: statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement\n\n",line_count);
	
		// string line = "for (" + $3->getName() + $4->getName() + $5->getName() + ") " + $7->getName();

		// symbolINfo *s = new symbolINfo(line, "statement");
		// $$ = s;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
	| IF LPAREN expression RPAREN statement 		%prec LOWER_THAN_ELSE
	{
		// fprintf(logout,"line no. %d: statement : IF LPAREN expression RPAREN statement\n\n",line_count);
	
		// string line = "if (" + $3->getName() + ") " + $5->getName();

		// symbolINfo *s = new symbolINfo(line, "statement");
		// $$ = s;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
	// | IF LPAREN expression RPAREN statement ELSE statement
	// {
	// 	// fprintf(logout,"line no. %d: statement : IF LPAREN expression RPAREN statement ELSE statement\n\n",line_count);
	
	// 	// string line = "if (" + $3->getName() + ") " + $5->getName() + "else " + $7->getName();

	// 	// symbolINfo *s = new symbolINfo(line, "statement");
	// 	// $$ = s;

	// 	// fprintf(logout, "%s\n\n", $$->getName().c_str());
	// }
	| WHILE LPAREN expression RPAREN statement
	{
		// fprintf(logout,"line no. %d: statement : WHILE LPAREN expression RPAREN statement\n\n",line_count);
	
		// string line = "while (" + $3->getName() + ") " + $5->getName();

		// symbolINfo *s = new symbolINfo(line, "statement");
		// $$ = s;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
	| PRINTLN LPAREN ID RPAREN SEMICOLON
	{
		// fprintf(logout,"line no. %d: statement : PRINTLN LPAREN ID RPAREN SEMICOLON\n\n",line_count);
	}
	| RETURN expression SEMICOLON
	{
		// fprintf(logout,"line no. %d: statement : RETURN expression SEMICOLON\n\n",line_count);
	
		// symbolINfo *s = new symbolINfo("return " + $2->getName() + ";", "statement");
		// $$ = s;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
	;
	  
expression_statement : SEMICOLON
	{
		// fprintf(logout,"line no. %d: expression_statement : SEMICOLON\n\n",line_count);

		// symbolINfo *s = new symbolINfo(";", "expression_statement");
		// $$ = s;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
	| expression SEMICOLON 
	{
		// fprintf(logout,"line no. %d: expression_statement : expression SEMICOLON\n\n",line_count);

		// symbolINfo *s = new symbolINfo($1->getName() + ";", "expression_statement");
		// $$ = s;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
	;
	  
variable : ID
	{
		// fprintf(logout,"line no. %d: variable: ID\n\n",line_count);

		// symbolINfo *s = new symbolINfo($1->getName(), "variable");
		// $$ = s;

		// symbolINfo = table.srch($1->getName());

		// if(symbolINfo != NULL) $$->varType = symbolINfo->varType;
		
		// //cout<<$$->getName()<<"  hg  "<<$$->varType<<endl;
 
		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	} 		
	| ID LTHIRD expression RTHIRD 
	{
		// fprintf(logout,"line no. %d: variable: ID LTHIRD expression RTHIRD\n\n",line_count);
	
		// symbolINfo *s = new symbolINfo($1->getName() + "[" + $3->getName() + "]", "variable");
		// $$ = s;

		// $$->varType = $1->varType;
		
		// if($3->varType != "int")
		// {
		// 	errCounter++;
		// 	fprintf(error_out, "Error no. %d at line no. %d\nArray indexing error\n\n", errCounter, line_count);
		// 	//cout << $3->getName() << " \'" << $3->varType << "\' id:" << $1->getName() << endl ;
		// }

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
	;
	 
 expression : logic_expression	
	{
		// fprintf(logout,"line no. %d: expression : logic_expression \n\n",line_count);
	
		// symbolINfo *s = new symbolINfo($1->getName(), "expression");
		// $$ = s;

		// $$->varType = $1->varType;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
    | variable ASSIGNOP logic_expression 
	{
		// fprintf(logout,"line no. %d: expression : variable ASSIGNOP logic_expression\n\n",line_count);

		// symbolINfo *s = new symbolINfo($1->getName() + " = " + $3->getName(), "expression");
		// $$ = s;

		// string t = "";
		// for(int i = 0; i < $1->getName().length(); i++)
		// {
		// 	if($1->getName()[i] == '[') break;
			
		// 	else
		// 	{
		// 		t.push_back($1->getName()[i]);
		// 	}
		// }

		// symbolINfo *sInfo = table.srch(t);

		// if(sInfo == 0)
		// {
		// 	errCounter++;
		// 	fprintf(logout,"variable %s not declared\n",t.c_str());
		// }

		// else
		// {
		// 	if(sInfo->varType != $3->varType)
		// 	{
		// 		errCounter++;
		// 		fprintf(error_out, "Error no. %d at line no. %d\nAssignment error\n\n", errCounter, line_count);
		// 	}
		// }

		// $$->varType = $1->varType;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
    ;
			
logic_expression : rel_expression 
	{
		// fprintf(logout,"line no. %d: logic_expression : rel_expression \n\n",line_count);

		// symbolINfo *s = new symbolINfo($1->getName(), "logic_expression");
		// $$ = s;

		// $$->varType = $1->varType;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
    | rel_expression LOGICOP rel_expression    
	{
		// fprintf(logout,"line no. %d: logic_expression : rel_expression LOGICOP rel_expression \n\n",line_count);
		
		// symbolINfo *s = new symbolINfo($1->getName() + $2->getName() + $3->getName(), "logic_expression");
		// $$ = s;

		// $$->varType = "int";

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
    ;
			
rel_expression	: simple_expression 
	{
		// fprintf(logout,"line no. %d: rel_expression : simple_expression \n\n",line_count);

		// symbolINfo *s = new symbolINfo($1->getName(), "rel_expression");
		// $$ = s;

		// $$->varType = $1->varType;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
	| simple_expression RELOP simple_expression	
	{
		// fprintf(logout,"line no. %d: rel_expression : simple_expression RELOP simple_expression \n\n",line_count);
	
		// symbolINfo *s = new symbolINfo($1->getName() + $2->getName() + $3->getName(), "rel_expression");
		// $$ = s;
		
		// $$->varType = "int";

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
	;
				
simple_expression : term 
	{
		// fprintf(logout,"line no. %d: simple_expression : term \n\n",line_count);

		// symbolINfo *s = new symbolINfo($1->getName(), "simple_expression");
		// $$ = s;

		// $$->varType = $1->varType;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
    | simple_expression ADDOP term 
	{
		// fprintf(logout,"line no. %d: simple_expression : simple_expression ADDOP term \n\n",line_count);

		// symbolINfo *s = new symbolINfo($1->getName() + $2->getName() + $3->getName(), "simple_expression");
		// $$ = s;

		// if($1->varType == "float" || $3->varType == "float")
		// {
		// 	$$->varType = "float";
		// }

		// else
		// {
		// 	$$->varType = "int";
		// }

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
    ;
					
term : unary_expression
	{
		// fprintf(logout,"line no. %d: term : unary_expression\n\n",line_count);

		// symbolINfo *s = new symbolINfo($1->getName(), "term");
		// $$ = s;

		// $$->varType = $1->varType;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
    |  term MULOP unary_expression
	{
		// fprintf(logout,"line no. %d: term : term MULOP unary_expression\n\n",line_count);

		// symbolINfo *s = new symbolINfo($1->getName() + $2->getName() + $3->getName(), "term");
		// $$ = s;

		// if($1->varType == "float" || $3->varType == "float")
		// {
		// 	$$->varType = "float";
		// }

		// else
		// {
		// 	$$->varType = "int";
		// }

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
    ;

unary_expression : ADDOP unary_expression  
	{
		// fprintf(logout,"line no. %d: unary_expression : ADDOP unary_expression\n\n",line_count);

		// symbolINfo *s = new symbolINfo($1->getName() + $2->getName(), "unary_expression");
		// $$ = s;

		// $$->varType = $2->varType;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
	| NOT unary_expression 
	{
		// fprintf(logout,"line no. %d: unary_expression : NOT unary_expression \n\n",line_count);

		// symbolINfo *s = new symbolINfo("!" + $2->getName(), "unary_expression");
		// $$ = s;

		// $$->varType = $2->varType;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
	| factor 
	{
		// fprintf(logout,"line no. %d: unary_expression : factor \n\n",line_count);

		// symbolINfo *s = new symbolINfo($1->getName(), "unary_expression");
		// $$ = s;

		// $$->varType = $1->varType;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
	;
	
factor : variable 
	{
		// fprintf(logout,"line no. %d: factor : variable\n\n",line_count);

		// symbolINfo *s = new symbolINfo($1->getName(), "factor");
		// $$ = s;

		// $$->varType = $1->varType;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
	| ID LPAREN argument_list RPAREN
	{
		// fprintf(logout,"line no. %d: factor : ID LPAREN argument_list RPAREN\n\n",line_count);

		// symbolINfo *s = new symbolINfo($1->getName(), "factor");
		// $$ = s;

		// symbolINfo = table.srch($1->getName());
		// $$->varType = symbolINfo->returnType;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
	| LPAREN expression RPAREN
	{
		// fprintf(logout,"line no. %d: factor : LPAREN expression RPAREN\n\n",line_count);

		// symbolINfo *s = new symbolINfo("(" + $2->getName() + ")", "factor");
		// $$ = s;

		// $$->varType = $2->varType;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
	| CONST_INT
	{
		// fprintf(logout,"line no. %d: factor : CONST_INT\n\n",line_count);

		// symbolINfo *s = new symbolINfo($1->getName(), "factor");
		// $$ = s;

		// $$->varType = "int";

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	} 
	| CONST_FLOAT
	{
		// fprintf(logout,"line no. %d: factor : CONST_FLOAT \n\n",line_count);

		// symbolINfo *s = new symbolINfo($1->getName(), "factor");
		// $$ = s;

		// $$->varType = "float";

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
	| variable INCOP 
	{
		// fprintf(logout,"line no. %d: factor : variable INCOP \n\n",line_count);

		// symbolINfo *s = new symbolINfo($1->getName() + "++", "factor");
		// $$ = s;

		// $$->varType = $1->varType;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
	| variable DECOP
	{
		// fprintf(logout,"line no. %d: factor : variable DECOP \n\n",line_count);

		// symbolINfo *s = new symbolINfo($1->getName() + "--", "factor");
		// $$ = s;

		// $$->varType == $1->varType;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
	;
	
argument_list : arguments
	/* {
		fprintf(logout,"line no. %d: argument_list : arguments\n\n",line_count);

		symbolINfo *s = new symbolINfo($1->getName(), "argument_list");
		$$ = s;

		fprintf(logout, "%s\n\n", $$->getName().c_str());
	} */
	| { }
	;
	
arguments : arguments COMMA logic_expression
	{
		// fprintf(logout,"line no. %d: arguments : arguments COMMA logic_expression \n\n",line_count);

		// symbolINfo *s = new symbolINfo($1->getName() + ", " + $3->getName(), "arguments");
		// $$ = s;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
	| logic_expression
	{
		// fprintf(logout,"line no. %d: arguments : logic_expression \n\n",line_count);

		// symbolINfo *s = new symbolINfo($1->getName(), "arguments");
		// $$ = s;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
	;
 

%%

int main(int argc,char *argv[])
{

	if((yyin=fopen(argv[1],"r"))==NULL)
	{
		printf("Cannot Open Input File.\n");
		exit(1);
	}

	logout= fopen(argv[2],"w");
	fclose(logout);
	error_out= fopen(argv[3],"w");
	fclose(error_out);
	
	logout= fopen(argv[2],"a");
	error_out= fopen(argv[3],"a");
	
	yyparse();

	table.printAllScopeTable();
	fprintf(logout,"total lines: %d\n",line_count);
	fprintf(logout,"total errors encountered: %d\n",errCounter);
	
	fclose(logout);
	fclose(error_out);
	
	return 0;
}
 
