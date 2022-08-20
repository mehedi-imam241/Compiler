%{
#include "symbolTablePackage/globals.h"
#include "symbolTablePackage/symbolTable.cpp"
using namespace std;

int yyparse(void);
int yylex(void);
extern FILE *yyin;
extern int line_count;
FILE* error_out;

int function_start_line ;

symbolTable table;

int errCounter = 0, totalBuckets;
string lastDeclaredType;
vector<symbolINfo*> l;
vector<symbolINfo*> d;

string retType;
bool isReturned;

void yyerror(string s)
{	
	//cout<<endl<<endl<<"yerr"<<endl<<endl;
	fprintf(error_out, "line no. %d: Error no. %d found\n%s\n", line_count, ++errCounter, s.c_str());
}

bool isEqualVec(vector<symbolINfo*> v1 ,vector<symbolINfo*> v2)
{
	for(int i=0;i<v1.size();i++)
	{
		if(v1[i]->getVariableType() != v2[i]->getVariableType())
		{
			return false;
		}
	}
	return true;
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

%nonassoc LOWER_THAN_ELSE 
%nonassoc ELSE

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

		$$ = new symbolINfo('\n' + $1->getName(), "unit");

		fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
    | func_declaration 
    {
     	fprintf(logout,"line no. %d: unit: func_declaration\n\n",line_count);

     	$$ = new symbolINfo('\n' + $1->getName(), "unit");

		fprintf(logout, "%s\n\n", $$->getName().c_str());
    }
    | func_definition 
    {
     	fprintf(logout,"line no. %d: unit: func_definition\n\n",line_count);

     	$$ = new symbolINfo('\n' + $1->getName(), "unit");

		fprintf(logout, "%s\n\n", $$->getName().c_str());
    }
    ;
     
func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON 
	{
		fprintf(logout,"line no. %d: func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON\n\n",line_count);
		
		string line = $1->getName() + $2->getName() + "(" + $4->getName() + ");";

		$$ = new symbolINfo(line, "func_declaration");

		fprintf(logout, "%s\n\n", $$->getName().c_str());

		//$2->setReturnType($1->getVariableType());
		//cout << $2->getName() << " " << $2->returnType << endl;

		string id = "ID";

		if (!table.insert($2->getName(), id))
		{
			fprintf(error_out, "Error no. %d at line no. %d\n%s Already Declared \n\n", ++errCounter, line_count,$2->getName().c_str());
			fprintf(logout, "Error no. %d at line no. %d\n%s Already Declared \n\n", errCounter, line_count,$2->getName().c_str());
		}

		symbolINfo *smbl = table.lookUP($2->getName());
		smbl->setReturnType($1->getName());
		smbl->isFunc = true;


		// for(symbolINfo* s:l)
		// {
		// 	d.push_back(s);
		// }
		smbl->paramList = l;
		l.clear();

	}
	| type_specifier ID LPAREN RPAREN SEMICOLON 
	{
		fprintf(logout,"line no. %d: func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON\n\n",line_count);
		
		string line = $1->getName() + $2->getName() + "( );";

		$$ = new symbolINfo(line, "func_declaration");

		fprintf(logout, "%s\n\n", $$->getName().c_str());

		//$2->setReturnType($1->getVariableType());
		//cout << $2->getName() << " " << $2->returnType << endl;

		string id = "ID";

		if (!table.insert($2->getName(), id))
		{
			fprintf(error_out, "Error no. %d at line no. %d\n%s Already Exists\n\n", ++errCounter, line_count,$2->getName().c_str());
			fprintf(logout, "Error no. %d at line no. %d\n%s Already Exists\n\n", errCounter, line_count,$2->getName().c_str());
		}

		symbolINfo *smbl = table.lookUP($2->getName());
		smbl->setReturnType($1->getName());
		smbl->isFunc = true;
			
	}
	;
		 
func_definition : type_specifier ID LPAREN parameter_list RPAREN {
		table.enterScope();	
		function_start_line = line_count;	
		for(symbolINfo* smbl:l)
		{
			// smbl->print();
			if (!table.insert(smbl->getName(), "ID"))
			{
				fprintf(error_out, "Error no. %d at line no. %d\n%s Already Declared\n\n", ++errCounter, line_count,smbl->getName().c_str());
				fprintf(logout, "Error no. %d at line no. %d\n%s Already Declared\n\n", errCounter, line_count,smbl->getName().c_str());
			}
			else {
				symbolINfo* temp = table.lookUP(smbl->getName());
				temp->setVariableType(smbl->getVariableType());
			}

		}}
	    compound_statement 
	{
		fprintf(logout,"line no. %d: func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement \n\n",line_count);

		$$  = new symbolINfo($1->getName() + " " +$2->getName() + "(" + $4->getName() + ")" + $7->getName(), "func_definition");

		$2->setReturnType($1->getVariableType()) ;

		fprintf(logout, "%s\n\n", $$->getName().c_str());


		table.exitScope();

		string id = "ID";


		symbolINfo *s = table.lookUP($2->getName());

		if(s!=NULL){ 
			if(!s->isFunc)
			{
				fprintf(error_out, "Error no. %d at line no. %d\nMultiple Declaration of %s\n\n", ++errCounter, function_start_line, s->getName().c_str());
				fprintf(logout, "Error no. %d at line no. %d\nMultiple Declaration of %s\n\n", errCounter, function_start_line, s->getName().c_str());
			}
			else if(l.size()!=s->paramList.size())
			{
				fprintf(error_out, "Error no. %d at line no. %d\nTotal Argument Number mismatched in function %s\n\n", ++errCounter, function_start_line, s->getName().c_str());
				fprintf(logout, "Error no. %d at line no. %d\nTotal Argument Number mismatched in function %s\n\n", errCounter, function_start_line, s->getName().c_str());
			} 
			else if(!isEqualVec(l,s->paramList))
			{
				fprintf(error_out, "Error no. %d at line no. %d\nType Mismatched in function %s\n\n", ++errCounter, function_start_line, s->getName().c_str());
				fprintf(logout, "Error no. %d at line no. %d\nType Mismatched in function %s\n\n", errCounter, function_start_line, s->getName().c_str());
			}
			else if(s->getReturnType()!=$1->getName())
			{
				fprintf(error_out, "Error no. %d at line no. %d\nReturn Type didn't match in function %s\n\n", ++errCounter, function_start_line, s->getName().c_str());
				fprintf(logout, "Error no. %d at line no. %d\nReturn Type didn't match in function %s\n\n", errCounter, function_start_line, s->getName().c_str());
			}
		}

		table.insert($2->getName(), id);
		s = table.lookUP($2->getName());
		s->setReturnType($1->getName());

		for(symbolINfo* smbl:l)
		{
			s->paramList.push_back(smbl);
		}

		l.clear();
		table.printAllScopeTable();

	}
	| type_specifier ID LPAREN RPAREN {table.enterScope();  function_start_line = line_count;} compound_statement 
	{
		fprintf(logout,"line no. %d: func_definition : type_specifier ID LPAREN RPAREN compound_statement\n\n",line_count);
	

		$$ = new symbolINfo($1->getName() +" "+ $2->getName() + "()" + $6->getName(), "func_definition");

		$2->setReturnType($1->getVariableType()) ;
		//cout << $2->getName() << " " << $2->returnType << endl;		

		fprintf(logout, "%s\n\n", $$->getName().c_str());

		table.exitScope();

		string id = "ID";

		symbolINfo *s = table.lookUP($2->getName());

		if(s!=NULL){ 
			if(!s->isFunc)
			{
				fprintf(error_out, "Error no. %d at line no. %d\nMultiple Declaration in function %s\n\n", ++errCounter, function_start_line,s->getName().c_str());
				fprintf(logout, "Error no. %d at line no. %d\nMultiple Declaration in function %s\n\n", errCounter, function_start_line,s->getName().c_str());
			}
			else if(s->getReturnType()!=$1->getName())
			{
				fprintf(error_out, "Error no. %d at line no. %d\nReturn Type didn't match in function %s\n\n", ++errCounter, function_start_line,s->getName().c_str());
				fprintf(logout, "Error no. %d at line no. %d\nReturn Type didn't match in function %s\n\n", errCounter, function_start_line,s->getName().c_str());
			}
		}

		table.insert($2->getName(), id);
		s = table.lookUP($2->getName());
		s->setReturnType($1->getName());

		table.printAllScopeTable();
	}
 	;				


parameter_list : parameter_list COMMA type_specifier ID 
	{
		fprintf(logout,"line no. %d: parameter_list : parameter_list COMMA type_specifier ID\n\n",line_count);
		$$ = new symbolINfo( $1->getName() + ", " + $3->getName() +" "+$4->getName(), "parameter_list");
		
		fprintf(logout, "%s\n\n", $$->getName().c_str());


		$4->setVariableType(lastDeclaredType);
		$4->setReturnType ($3->getReturnType()) ;

		l.push_back($4);
		//table.printAllScopeTable();

	}
	| parameter_list COMMA type_specifier 
	{
		fprintf(logout,"line no. %d: parameter_list : parameter_list COMMA type_specifier\n\n",line_count);
		$$ = new symbolINfo($1->getName() + ", " + $3->getName(), "parameter_list");
		fprintf(logout, "%s\n\n", $$->getName().c_str());

	}
 	| type_specifier ID 
 	{

		fprintf(logout,"line no. %d: parameter_list : type_specifier ID\n\n",line_count);

		$$->setName($$->getName()+" "+ $2->getName());
		fprintf(logout, "%s\n\n", $$->getName().c_str());


		$2->setVariableType(lastDeclaredType);
		l.clear();
		l.push_back($2);

		//table.printAllScopeTable();

	}
	| type_specifier 
	{
		fprintf(logout,"line no. %d: parameter_list : type_specifier\n\n",line_count);
		fprintf(logout, "%s\n\n", $1->getName().c_str());

		$$ = new symbolINfo($1->getName(), "parameter_list");
		
		$$->setVariableType(lastDeclaredType);

	}
 	;

 		
compound_statement : LCURL statements RCURL 
	{
		fprintf(logout,"line no. %d: compound_statement : LCURL statements RCURL\n\n",line_count);
		$$ = new symbolINfo("{ \n" + $2->getName() + "}", "parameter_list");
		fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
 	| LCURL RCURL 
 	{
		fprintf(logout,"line no. %d: compound_statement : LCURL RCURL\n\n",line_count);
		fprintf(logout, "%s\n\n", "{}");
		$$ = new symbolINfo("{}", "parameter_list");
	}
 	;
 		    
var_declaration : type_specifier declaration_list SEMICOLON
	{
		fprintf(logout,"line no. %d: var_declaration : type_specifier declaration_list SEMICOLON\n\n",line_count);
	
		$$ = new symbolINfo($1->getName()+" "+ $2->getName() + ";", "parameter_list");
		$$->setVariableType($1->getName());

		// $$->print();
		// cout<<"hello world"<<endl;

		fprintf(logout, "%s\n\n", $$->getName().c_str());
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
		fprintf(logout,"line no. %d: type_specifier : FLOAT\n\n",line_count);
		fprintf(logout,"float\n\n");

		symbolINfo *s = new symbolINfo("float","type_specifier");
		s->setVariableType("float");
		$$ = s;

		lastDeclaredType = "float";
	}
 	| VOID
	{
		fprintf(logout,"line no. %d: type_specifier : VOID\n\n",line_count);
		fprintf(logout,"void\n\n");

		symbolINfo *s = new symbolINfo("void","type_specifier");
		s->setVariableType("void");
		$$ = s;

		lastDeclaredType = "void";
	}
 	;
 		
declaration_list : declaration_list COMMA ID
	{
		fprintf(logout,"line no. %d: declaration_list : declaration_list COMMA ID\n\n",line_count);

		$$->setName($1->getName() + ", " + $3->getName());

		fprintf(logout,"%s\n\n", $$->getName().c_str());

		if (!table.insert($3->getName(), "ID"))
		{
			fprintf(error_out, "Error no. %d at line no. %d\nAlready Exists\n\n", ++errCounter, line_count);
			fprintf(logout, "Error no. %d at line no. %d\nAlready Exists\n\n", errCounter, line_count);
		}

		table.printAllScopeTable();

		symbolINfo *s = table.lookUP($3->getName());
		
		if(lastDeclaredType == "void")
		{
			fprintf(error_out, "Error no. %d at line no. %d\nVariable type can't be void\n\n", ++errCounter, line_count);
			fprintf(logout, "Error no. %d at line no. %d\nVariable type can't be void\n\n", errCounter, line_count);
		}
		else 
		{
			s->setVariableType(lastDeclaredType);
		}

	}
 	| declaration_list COMMA ID LTHIRD CONST_INT RTHIRD
	{
		fprintf(logout,"line no. %d: declaration_list : declaration_list COMMA ID LTHIRD CONST_INT RTHIRD\n\n",line_count);

		string line;
		line+= $1->getName() + ", " + $3->getName() + "[" + $5->getName() + "]" ;

		$$->setName(line);

		fprintf(logout, "%s\n\n", $$->getName().c_str());


		// stringstream ss;
		// ss<<$5->getName();
		// ss>>val;

		if (!table.insert($3->getName(), "ID"))
		{

			fprintf(error_out, "Error no. %d at line no. %d\n%s Already Declared\n\n", ++errCounter, line_count, $3->getName().c_str());
			fprintf(logout, "Error no. %d at line no. %d\n%s Already Declared\n\n", errCounter, line_count, $3->getName().c_str());
		}

		symbolINfo *s = table.lookUP($3->getName());
		
		if(lastDeclaredType == "void")
		{
			fprintf(error_out, "Error no. %d at line no. %d\nVariable type can't be void\n\n", ++errCounter, line_count);
			fprintf(logout, "Error no. %d at line no. %d\nVariable type can't be void\n\n", errCounter, line_count);
		}
		else 
		{
			s->isArray = true;
			s->setVariableType(lastDeclaredType);
		}
	}
 	| ID
	{
		fprintf(logout,"line no. %d: declaration_list : ID\n\n",line_count);

		$$ = new symbolINfo($1->getName(),"declaration_list");

		fprintf(logout,"%s\n\n", $1->getName().c_str());


		if (!table.insert($1->getName(), "ID"))
		{
			fprintf(error_out, "Error no. %d at line no. %d\n%s Already Exists\n\n", ++errCounter, line_count, $1->getName().c_str());
			fprintf(logout, "Error no. %d at line no. %d\n%s Already Exists\n\n", errCounter, line_count, $1->getName().c_str());
		}

		symbolINfo *s1 = table.lookUP($1->getName());
		
		if(lastDeclaredType == "void")
		{
			fprintf(error_out, "Error no. %d at line no. %d\nVariable type can't be void\n\n", ++errCounter, line_count);
			fprintf(logout, "Error no. %d at line no. %d\nVariable type can't be void\n\n", errCounter, line_count);
		}
		else 
		{
			s1->setVariableType(lastDeclaredType);
		}

		table.printAllScopeTable();

	}
 	| ID LTHIRD CONST_INT RTHIRD
	{

		fprintf(logout,"line no. %d: declaration_list : ID LTHIRD CONST_INT RTHIRD\n\n",line_count);

		string line = $1->getName() + "[" + $3->getName() + "]";

		$$ = new symbolINfo(line, "declaration_list");

		fprintf(logout,"%s\n\n", $$->getName().c_str());

		if (!table.insert($1->getName(), "ID"))
		{

			fprintf(error_out, "Error no. %d at line no. %d\n%s Already Exists\n\n", ++errCounter, line_count, $1->getName().c_str());
			fprintf(logout, "Error no. %d at line no. %d\n%s Already Exists\n\n", errCounter, line_count, $1->getName().c_str());
		}

		symbolINfo *s1 = table.lookUP($1->getName());

		if(lastDeclaredType == "void")
		{
			fprintf(error_out, "Error no. %d at line no. %d\nVariable type can't be void\n\n", ++errCounter, line_count);
			fprintf(logout, "Error no. %d at line no. %d\nVariable type can't be void\n\n", errCounter, line_count);
		}
		else 
		{
			s1->isArray = true;
			s1->setVariableType(lastDeclaredType);
		}
	}
 	;
 		  
statements : statement
	{
		fprintf(logout,"line no. %d: statements : statement\n\n",line_count);
		fprintf(logout, "%s\n\n", $1->getName().c_str());
		$$ = new symbolINfo($1->getName(), "statements");
	}
    | statements statement
	{
		fprintf(logout,"line no. %d: statements : statements statement\n\n",line_count);

		string line;
		line+= $1->getName()+ $2->getName();
		$$ = new symbolINfo(line, "statements");

		fprintf(logout, "%s\n\n", line.c_str());
	}
    ;
	   
statement : var_declaration
	{
		fprintf(logout,"line no. %d: statement : var_declaration\n\n",line_count);

		$$ = new symbolINfo($1->getName() + '\n', "statement");

		fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
	| expression_statement
	{
		fprintf(logout,"line no. %d: statement : expression_statement\n\n",line_count);
		$$ = new symbolINfo($1->getName()+ '\n', "statement");
		fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
	| compound_statement
	{
		fprintf(logout,"line no. %d: statement : compound_statement\n\n",line_count);
		$$ = new symbolINfo($1->getName() + '\n', "statement");
		fprintf(logout, "%s\n\n", $1->getName().c_str());
	}
	| FOR LPAREN expression_statement expression_statement expression RPAREN statement
	{
		fprintf(logout,"line no. %d: statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement\n\n",line_count);
		$$ = new symbolINfo("for ( " + $3->getName() + $4->getName() + $5->getName() + " ) " + $7->getName(), "statement");
		fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
	| IF LPAREN expression RPAREN statement %prec LOWER_THAN_ELSE
	{
		fprintf(logout,"line no. %d: statement : IF LPAREN expression RPAREN statement\n\n",line_count);
		$$ = new symbolINfo("if ( " + $3->getName() + " ) " + $5->getName(), "statement");
		fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
	| IF LPAREN expression RPAREN statement ELSE statement
	{
		fprintf(logout,"line no. %d: statement : IF LPAREN expression RPAREN statement ELSE statement\n\n",line_count);
		$$ = new symbolINfo("if ( " + $3->getName() + " ) " + $5->getName() + " else " + $7->getName(), "statement");
		fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
	| WHILE LPAREN expression RPAREN statement
	{
		fprintf(logout,"line no. %d: statement : WHILE LPAREN expression RPAREN statement\n\n",line_count);
		$$ = new symbolINfo("while (" + $3->getName() + ") " + $5->getName(), "statement");
		fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
	| PRINTLN LPAREN ID RPAREN SEMICOLON
	{
		fprintf(logout,"line no. %d: statement : PRINTLN LPAREN ID RPAREN SEMICOLON\n\n",line_count);
	}
	| RETURN expression SEMICOLON
	{
		fprintf(logout,"line no. %d: statement : RETURN expression SEMICOLON\n\n",line_count);
		$$ = new symbolINfo("return " + $2->getName() + ";", "statement");
		fprintf(logout, "%s\n\n", $$->getName().c_str());
		retType = $2->getVariableType();
		isReturned = true;
	}
	;
	  
expression_statement : SEMICOLON
	{
		fprintf(logout,"line no. %d: expression_statement : SEMICOLON\n\n",line_count);
		$$ = new symbolINfo(";","expression_statement");
		fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
	| expression SEMICOLON 
	{
		fprintf(logout,"line no. %d: expression_statement : expression SEMICOLON\n\n",line_count);
		$$ = new symbolINfo($1->getName() + ";", "expression_statement");
		fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
	;
	  
variable : ID
	{
		fprintf(logout,"line no. %d: variable: ID\n\n",line_count);
		fprintf(logout, "%s\n\n", $1->getName().c_str());

		symbolINfo *s = table.lookUP($1->getName());

		if(s == NULL){
			//cout<<"error"<<endl;
		}
		else{
			$$->setVariableType(s->getVariableType());
		} 
		$$->setType("variable");
		// $$->print();

		//cout<< $$->getName()<<" "<< $$->getVariableType()<<" "<< $$->getType()<<line_count<<endl;
		
	} 		
	| ID LTHIRD expression RTHIRD 
	{
		fprintf(logout,"line no. %d: variable: ID LTHIRD expression RTHIRD\n\n",line_count);

		string line;
		line+=$1->getName() + "[" + $3->getName() + "]";
		fprintf(logout, "%s\n\n", line.c_str());
	
		$$ = new symbolINfo(line, "variable");


		symbolINfo *s = table.lookUP($1->getName());


		if(!s->isArray)
		{
			
			fprintf(error_out, "Error no. %d at line no. %d\n%s is not an array\n\n", ++errCounter, line_count,$1->getName().c_str());
			fprintf(logout, "Error no. %d at line no. %d\n%s is not an array\n\n", errCounter, line_count,$1->getName().c_str());
		}

		$$->setVariableType(s->getVariableType());


		
		if($3->getVariableType() != "int")
		{
			fprintf(error_out, "Error no. %d at line no. %d\nArray indexing error %s\n\n", ++errCounter, line_count,line.c_str());
			fprintf(logout, "Error no. %d at line no. %d\nArray indexing error %s\n\n", errCounter, line_count,line.c_str());
		}
		//$$->print();
		//$1->print();
	}
	;
	 
 expression : logic_expression	
	{
		fprintf(logout,"line no. %d: expression : logic_expression \n\n",line_count);
		fprintf(logout, "%s\n\n", $1->getName().c_str());
	
		$$->setType("expression");

		// $$->setVariableType($1->getVariableType());
	}
    | variable ASSIGNOP logic_expression 
	{
		fprintf(logout,"line no. %d: expression : variable ASSIGNOP logic_expression\n\n",line_count);


		$$ = new symbolINfo($1->getName() + " = " + $3->getName(), "expression");

		int p = $1->getName().find("[");
		string str;
		bool hasBrackets = false;

		if (p != string::npos)
		{
			str = $1->getName().substr(0,p);
			hasBrackets = true;
		}
		else 
		{
			str = $1->getName();
		}

		//cout<<"here "<<str<<endl;

		table.printAllScopeTable();
		symbolINfo *s = table.lookUP(str);



		if(s == NULL)
		{
			fprintf(error_out, "Error no. %d at line no. %d\nvariable not declared	%s\n\n", ++errCounter, line_count, str.c_str());
			fprintf(logout, "Error no. %d at line no. %d\nvariable not declared	%s\n\n", errCounter, line_count, str.c_str());
		}
		else
		{
			//cout<<s->getVariableType()<<" "<<$3->getVariableType()<<" "<<line_count<<endl;
			if(s->isArray && !hasBrackets)
			{
				fprintf(error_out, "Error no. %d at line no. %d\nType mismatch in array %s\n\n", ++errCounter, line_count, str.c_str());
				fprintf(logout, "Error no. %d at line no. %d\nType mismatch in array %s\n\n", errCounter, line_count, str.c_str());
			}
			else if(s->getVariableType() == "float" && $3->getVariableType()=="int"){}
			else if(s->getVariableType() == "int" && $3->getVariableType()=="float"){}
			else if(s->getVariableType() != $3->getVariableType())
			{
				fprintf(error_out, "Error no. %d at line no. %d\nAssignment Error\n\n", ++errCounter, line_count);
				fprintf(logout, "Error no. %d at line no. %d\nAssignment Error\n\n", errCounter, line_count);
			}
		}

		$$->setVariableType($1->getVariableType());
		fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
    ;
			
logic_expression : rel_expression 
	{
		fprintf(logout,"line no. %d: logic_expression : rel_expression \n\n",line_count);

		$$= new symbolINfo($1->getName(),"rel_expression");
		$$->setVariableType($1->getVariableType());

		fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
    | rel_expression LOGICOP rel_expression    
	{
		fprintf(logout,"line no. %d: logic_expression : rel_expression LOGICOP rel_expression \n\n",line_count);
		$$ = new symbolINfo($1->getName() + " " + $2->getName()+ " " + $3->getName(), "logic_expression");
		$$->setVariableType("int");
		fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
    ;
			
rel_expression	: simple_expression 
	{
		fprintf(logout,"line no. %d: rel_expression : simple_expression \n\n",line_count);
		$$->setType("rel_expression");
		//$1->print();
		fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
	| simple_expression RELOP simple_expression	
	{
		fprintf(logout,"line no. %d: rel_expression : simple_expression RELOP simple_expression \n\n",line_count);
	
		$$ = new symbolINfo($1->getName() +" "+ $2->getName() +" "+ $3->getName(), "rel_expression");

		$$->setVariableType("int");
		fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
	;
				
simple_expression : term 
	{
		fprintf(logout,"line no. %d: simple_expression : term \n\n",line_count);
		$$->setVariableType($1->getVariableType()) ;
		//$1->print();
		fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
    | simple_expression ADDOP term 
	{
		fprintf(logout,"line no. %d: simple_expression : simple_expression ADDOP term \n\n",line_count);

		string line = $1->getName() + $2->getName() + $3->getName();

		$$ = new symbolINfo(line, "simple_expression");

		fprintf(logout, "%s\n\n", $$->getName().c_str());

		if($1->getVariableType() == "void" || $3->getVariableType() == "void")
		{
			fprintf(error_out, "Error no. %d at line no. %d\nVoid function used in expression %s\n\n", ++errCounter, line_count, line.c_str());
			fprintf(logout, "Error no. %d at line no. %d\nVoid function used in expression %s\n\n", errCounter, line_count, line.c_str());
		}
		else if($1->getVariableType() == "int" && $3->getVariableType() == "int")
		{
			$$->setVariableType("int") ;
		}
		else
		{
			$$->setVariableType("float") ;
		}
	}
    ;
					
term : unary_expression
	{
		fprintf(logout,"line no. %d: term : unary_expression\n\n",line_count);
		$$->setVariableType($1->getVariableType());
		fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
    |  term MULOP unary_expression
	{
		fprintf(logout,"line no. %d: term : term MULOP unary_expression \n\n",line_count);

		string line = $1->getName() + $2->getName() + $3->getName();
		$$ = new symbolINfo(line, "term");

		fprintf(logout, "%s\n\n", $$->getName().c_str());

		
		// cout<< $2->getName()<<endl;
		bool zero = false;
    	regex exp("0*(.0+)?");

    	if(regex_match($3->getName(),exp))
    	{
        	zero = true;
    	}


		if($2->getName()=="%" && zero)
		{
			fprintf(error_out, "Error no. %d at line no. %d\nModulus by zero\n\n", ++errCounter, line_count);
			fprintf(logout, "Error no. %d at line no. %d\nModulus by zero\n\n", errCounter, line_count);
		}
		else if($2->getName()=="/" && zero)
		{
			fprintf(error_out, "Error no. %d at line no. %d\nDivide by zero\n\n", ++errCounter, line_count);
			fprintf(logout, "Error no. %d at line no. %d\nDivide by zero\n\n", errCounter, line_count);
		}
		else if($1->getVariableType() == "void" || $3->getVariableType() == "void")
		{
			fprintf(error_out, "Error no. %d at line no. %d\nVoid function used in expression %s\n\n", ++errCounter, line_count,line.c_str());
			fprintf(logout, "Error no. %d at line no. %d\nVoid function used in expression %s\n\n", errCounter, line_count,line.c_str());
		}
		else if($1->getVariableType() == "int" && $3->getVariableType() == "int")
		{
			$$->setVariableType("int") ;
		}
		else
		{
			$$->setVariableType("float") ;
		}
	}
    ;

unary_expression : ADDOP unary_expression  
	{
		fprintf(logout,"line no. %d: unary_expression : ADDOP unary_expression\n\n",line_count);

		$$ = new symbolINfo($1->getName() + $2->getName(), "unary_expression");
		$$->setVariableType($2->getVariableType());
		fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
	| NOT unary_expression 
	{
		fprintf(logout,"line no. %d: unary_expression : NOT unary_expression \n\n",line_count);

		$$ = new symbolINfo("!" + $2->getName(), "unary_expression");

		$$->setVariableType($2->getVariableType());

		fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
	| factor 
	{
		fprintf(logout,"line no. %d: unary_expression : factor \n\n",line_count);
		$$ = new symbolINfo($1->getName(),"unary_expression");

		$$->setVariableType($1->getVariableType());
		//$1->print();
		
		fprintf(logout, "%s\n\n", $$->getName().c_str());


	}
	;
	
factor : variable 
	{
		fprintf(logout,"line no. %d: factor : variable\n\n",line_count);
		$$->setType("factor");
		fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
	| ID LPAREN argument_list RPAREN
	{

		fprintf(logout,"line no. %d: factor : ID LPAREN argument_list RPAREN\n\n",line_count);

		$$ = new symbolINfo($1->getName()+"("+$3->getName()+")", "factor");

		symbolINfo *temp = table.lookUP($1->getName());

		//cout<<l.size()<<" "<<endl;
		// cout<<"hello world";
		//temp->print();
		// cout<<"hello world";



		if(temp == NULL)
		{
			//cout<<"hello world";
			fprintf(error_out, "Error no. %d at line no. %d\nUndeclared Function\n\n", ++errCounter, line_count);
			fprintf(logout, "Error no. %d at line no. %d\nUndeclared Function\n\n", errCounter, line_count);
		}
		else {
			if(l.size()>temp->paramList.size())
			{
				fprintf(error_out, "Error no. %d at line no. %d\nToo many arguments\n\n", ++errCounter, line_count);
				fprintf(logout, "Error no. %d at line no. %d\nToo many arguments\n\n", errCounter, line_count);
			}
			else if(l.size()<temp->paramList.size())
			{
				fprintf(error_out, "Error no. %d at line no. %d\nToo few arguments\n\n", ++errCounter, line_count);
				fprintf(logout, "Error no. %d at line no. %d\nToo few arguments\n\n", errCounter, line_count);
			}
			else if(l.size() && temp->paramList.size()){
				int i = 0;
				for(symbolINfo* smbl:l)
				{
					symbolINfo *s = table.lookUP(smbl->getName());
					if(s==NULL)
					{
						if(smbl->getVariableType()=="")
						{

							fprintf(error_out, "Error no. %d at line no. %d\nUndeclared variable\n\n", ++errCounter, line_count);
							fprintf(logout, "Error no. %d at line no. %d\nUndeclared variable\n\n", errCounter, line_count);
						}
						else if(temp->paramList[i]->getVariableType()!= smbl->getVariableType())
						{	
							fprintf(error_out, "Error no. %d at line no. %d\nType mistmatched\n\n", ++errCounter, line_count);
							fprintf(logout, "Error no. %d at line no. %d\nType mistmatched\n\n", errCounter, line_count);
						}
					}
					else {
						if(temp->paramList[i]->isArray != s->isArray)
						{
							fprintf(error_out, "Error no. %d at line no. %d\nType Mismatch\n\n", ++errCounter, line_count);
							fprintf(logout, "Error no. %d at line no. %d\nType Mismatch\n\n", errCounter, line_count);
						}
						else if(temp->paramList[i]->getVariableType()!=s->getVariableType())
						{
							fprintf(error_out, "Error no. %d at line no. %d\nType Mismatched\n\n", ++errCounter, line_count);
							fprintf(logout, "Error no. %d at line no. %d\nType Mismatched\n\n", errCounter, line_count);
						}
					}
					i++;
				}
			}
		}
		l.clear();

		if(temp!=NULL)
		{
			$$->setVariableType(temp->getReturnType()) ;
		}

		fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
	| LPAREN expression RPAREN
	{
		fprintf(logout,"line no. %d: factor : LPAREN expression RPAREN\n\n",line_count);
		$$ = new symbolINfo("(" + $2->getName() + ")", "factor");
		$$->setVariableType($2->getVariableType());
		fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
	| CONST_INT
	{
		fprintf(logout,"line no. %d: factor : CONST_INT\n\n",line_count);
		$$ = new symbolINfo($1->getName(), "factor");
		$$->setVariableType("int") ;
		fprintf(logout, "%s\n\n", $$->getName().c_str());
		//$$->print();
	} 
	| CONST_FLOAT
	{
		fprintf(logout,"line no. %d: factor : CONST_FLOAT \n\n",line_count);
		$$ = new symbolINfo($1->getName(), "factor");
		$$->setVariableType("float") ;

		fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
	| variable INCOP 
	{
		fprintf(logout,"line no. %d: factor : variable INCOP \n\n",line_count);
		$$ = new symbolINfo($1->getName() + "++", "factor");
		$$->setVariableType($1->getVariableType()) ;
		fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
	| variable DECOP
	{
		fprintf(logout,"line no. %d: factor : variable DECOP \n\n",line_count);
		$$ = new symbolINfo($1->getName() + "--", "factor");
		$$->setVariableType($1->getVariableType()) ;
		fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
	;
	
argument_list : arguments
	{
		fprintf(logout,"line no. %d: argument_list : arguments\n\n",line_count);
		$$ = new symbolINfo($1->getName(), "argument_list");
		fprintf(logout, "%s\n\n", $$->getName().c_str());
	} 
	| { }
	;
	
arguments : arguments COMMA logic_expression
	{
		fprintf(logout,"line no. %d: arguments : arguments COMMA logic_expression \n\n",line_count);
		$$ = new symbolINfo($1->getName() + ", " + $3->getName(), "arguments");
		fprintf(logout, "%s\n\n", $$->getName().c_str());

		//cout<<endl<<"here"<<$3->getVariableType()<<endl;

		l.push_back($3);
	}
	| logic_expression
	{
		fprintf(logout,"line no. %d: arguments : logic_expression \n\n",line_count);
		$$ = new symbolINfo($1->getName(), "arguments");
		fprintf(logout, "%s\n\n", $$->getName().c_str());
		//cout<<endl<<$1->getVariableType()<<endl;

		l.push_back($1);


	}
	;
 

%%

int main(int argc,char *argv[])
{
	totalBuckets = 7;
	table.enterScope();

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
	fprintf(logout,"\n\ntotal lines: %d\n",line_count);
	fprintf(logout,"total errors encountered: %d\n",errCounter);
	
	fclose(logout);
	fclose(error_out);
	
	return 0;
}
 
