%{
#include "SymbolTable.h"
#include "optimizeCode.cpp"
#include "variableIdentity.cpp"

using namespace std;

int yyparse(void);
int yylex(void);

string TypeSpecifier = ""; // Necessary For storing type_specifier 
string ReturnStatementType = ""; // Necessary for matching return type and definiton
class VariableIdentity ReturnExp;
int LabelCount = 0;
int TempCount = 0;
bool ReturnCalled = false;
FILE* error_out;
FILE* Log;
FILE* Assembly;
FILE* Optimized;

extern int line_count;
extern int errCounter;
extern FILE *yyin;

SymbolTable *table = new SymbolTable(30);

vector<SymbolInfo*> Parameters;
vector<VariableIdentity> VariablesUsed;

void yyerror(const char *s)
{
	fprintf(error_out, "Error at Line %d: %s\n\n", line_count, s);
	errCounter++;
}

string NewLabel(){
	return "L" + to_string(++LabelCount);
}

string NewTemp(){
	class VariableIdentity Temp;
	Temp.Name = "T" + to_string(++TempCount);
	Temp.Size = "0";
	VariablesUsed.push_back(Temp);
	return "T" + to_string(TempCount);
}

void optimizeCode();

void printUtil()
{
			string assemblyPrint = "";
			
		    assemblyPrint+= "PRINTLN PROC\n";
		    assemblyPrint+= "    ;Store Register States\n";
		    assemblyPrint+= "    PUSH AX\n";
		    assemblyPrint+= "    PUSH BX\n";
		    assemblyPrint+= "    PUSH CX\n";
		    assemblyPrint+= "    PUSH DX\n\n";
		    assemblyPrint+= "    ;Divisor\n    MOV BX, 10\n";
		    assemblyPrint+= "    ;Counter\n    MOV CX, 0\n";
		    assemblyPrint+= "    ;For remainder\n    MOV DX, 0\n\n";
		    assemblyPrint+= "    ;Check for 0 or negative\n    CMP AX, 0\n";
		    assemblyPrint+= "    ;Print Zero\n    JE PRINT_ZERO\n";
		    assemblyPrint+= "    ;Positive Number\n    JNL START_STACK\n";
		    assemblyPrint+= "    ;Negative Number, Print the sign and Negate the number\n";
		    assemblyPrint+= "    PUSH AX\n";
		    assemblyPrint+= "    MOV AH, 2\n";
		    assemblyPrint+= "    MOV DL, 2DH\n";
		    assemblyPrint+= "    INT 21H\n";
		    assemblyPrint+= "    POP AX\n";
		    assemblyPrint+= "    NEG AX\n";
		    assemblyPrint+= "    MOV DX, 0\n";
		    assemblyPrint+= "    START_STACK:\n";
		    assemblyPrint+= "        ;If AX=0, Start Printing\n";
		    assemblyPrint+= "        CMP AX,0\n";
		    assemblyPrint+= "        JE START_PRINTING\n";
		    assemblyPrint+= "        ;AX = AX / 10\n";
		    assemblyPrint+= "        DIV BX\n";
		    assemblyPrint+= "        ;Remainder is Stored in DX\n";
		    assemblyPrint+= "        PUSH DX\n";
		    assemblyPrint+= "        INC CX\n";
		    assemblyPrint+= "        MOV DX, 0\n";
		    assemblyPrint+= "        JMP START_STACK\n";
		    assemblyPrint+= "    START_PRINTING:\n";
		    assemblyPrint+= "        MOV AH, 2\n";
		    assemblyPrint+= "        ;Counter becoming 0 implies that the number has been printed\n";
		    assemblyPrint+= "        CMP CX, 0\n";
		    assemblyPrint+= "        JE DONE_PRINTING\n";
		    assemblyPrint+= "        POP DX\n";
		    assemblyPrint+= "        ;To get the ASCII Equivalent\n        ADD DX, 30H\n";
		    assemblyPrint+= "        INT 21H\n";
		    assemblyPrint+= "        DEC CX\n";
		    assemblyPrint+= "        JMP START_PRINTING\n";
		    assemblyPrint+= "    PRINT_ZERO:\n";
		    assemblyPrint+= "        MOV AH, 2\n";
		    assemblyPrint+= "        MOV DX, 30H\n";
		    assemblyPrint+= "        INT 21H\n";
		    assemblyPrint+= "    DONE_PRINTING:\n";
		    assemblyPrint+= "        ;Print a New Line\n";
		    assemblyPrint+= "        MOV DL, 0AH\n";
		    assemblyPrint+= "        INT 21H\n";
		    assemblyPrint+= "        MOV DL, 0DH\n";
		    assemblyPrint+= "        INT 21H\n";
		    assemblyPrint+= "    ;Restore Register States and Return\n";
		    assemblyPrint+= "    POP DX\n";
		    assemblyPrint+= "    POP CX\n";
		    assemblyPrint+= "    POP BX\n";
		    assemblyPrint+= "    POP AX\n";
		    assemblyPrint+= "    RET\n";
		    assemblyPrint+= "PRINTLN ENDP\n\n";
			fprintf(Assembly, "%s", assemblyPrint.c_str());
}

void printErr(string s, int lineCount)
{
	string printstr = "Error at Line %d: "+s;
	fprintf(error_out, printstr.c_str(), lineCount);
	fprintf(Log, printstr.c_str(), lineCount);
	errCounter++;
}

%}

%union{
	SymbolInfo* smbl;
}

%token IF ELSE FOR WHILE INT FLOAT DOUBLE CHAR RETURN VOID PRINTLN DO
%token SWITCH CASE DEFAULT CONTINUE INCOP DECOP ASSIGNOP NOT SEMICOLON 
%token COMMA LPAREN RPAREN LCURL RCURL LTHIRD RTHIRD CONST_CHAR BREAK 

%token<smbl>ADDOP MULOP RELOP LOGICOP CONST_INT CONST_FLOAT ID

%type<smbl>start program unit var_declaration func_declaration 
%type<smbl>func_definition type_specifier parameter_list factor
%type<smbl>variable declaration_list argument_list arguments 
%type<smbl>logic_expression expression compound_statement statement
%type<smbl>rel_expression simple_expression term unary_expression
%type<smbl>expression_statement statements

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE


%%

start : program
	{
		fprintf(Log, "Line no. %d: start : program\n\n", line_count);
		fprintf(Log, "%s\n\n", $1->GetSymbolName().c_str());

		if(errCounter == 0){

			fprintf(Assembly, ".MODEL SMALL\n\n.STACK 100H\n\n.DATA\n");

			fprintf(Assembly, "    ADDRESS DW ?\n");
			for(int Counter=0; Counter<VariablesUsed.size(); Counter++){
				if(VariablesUsed[Counter].Size == "0"){
					fprintf(Assembly, "    %s DW ?\n", VariablesUsed[Counter].Name.c_str());
				}
				else{
					fprintf(Assembly, "    %s DW %s DUP (?)\n", VariablesUsed[Counter].Name.c_str(), VariablesUsed[Counter].Size.c_str());
				}
			}
			
			fprintf(Assembly, "\n.CODE\n");
			printUtil();

			fprintf(Assembly, "%s", $1->GetCode().c_str());
			fprintf(Assembly, "    END MAIN");
		}
	}
	;

program : program unit 
	{
		fprintf(Log, "Line no. %d: program : program unit\n\n", line_count);
		$1->SetSymbolName($1->GetSymbolName() + "\n" + $2->GetSymbolName());
		fprintf(Log, "%s\n\n", $1->GetSymbolName().c_str());
		$$->SetCode($1->GetCode()+$2->GetCode());
	}
	| unit
	{
		fprintf(Log, "Line no. %d: program : unit\n\n", line_count);
		fprintf(Log, "%s\n\n", $1->GetSymbolName().c_str());
		$$ = new SymbolInfo($1->GetSymbolName(), "program");
		$$->SetCode($1->GetCode());
	}
	;
	
unit : var_declaration
	{
		fprintf(Log, "Line no. %d: unit : var_declaration\n\n", line_count);
		fprintf(Log, "%s\n\n", $1->GetSymbolName().c_str());
		$$ = new SymbolInfo($1->GetSymbolName(), "unit");
		$$->SetCode($1->GetCode());
	}
    | func_declaration
    {
		fprintf(Log, "Line no. %d: unit : func_declaration\n\n", line_count);
		fprintf(Log, "%s\n\n", $1->GetSymbolName().c_str());
		$$= new SymbolInfo($1->GetSymbolName(), "unit");
		$$->SetCode($1->GetCode());
	}
    | func_definition
    {
		fprintf(Log, "Line no. %d: unit : func_definition\n\n", line_count);
		fprintf(Log, "%s\n\n", $1->GetSymbolName().c_str());
		$$ = new SymbolInfo($1->GetSymbolName(), "unit");
		$$->SetCode($1->GetCode());
	}
    ;
     
func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON
		{
			fprintf(Log, "Line no. %d: func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON\n\n", line_count);
			
			SymbolInfo* Sym = new SymbolInfo($2->GetSymbolName(), "ID");
			
			if(table->LookUp($2->GetSymbolName())){
				printErr("Previous Declaration of Function \'"+$2->GetSymbolName()+"\' Found\n\n",line_count);
			}
			// Unique name
			else{
				Sym->SetReturnType($1->GetSymbolType());
				Sym->SetIdentity("func_declaration");
				
				for(int Counter = 0; Counter < $4->ParamList.size(); Counter++){
					Sym->ParamList.push_back($4->ParamList[Counter]);
				}
				table->Insert(Sym);
			}
			
			string Line = $1->GetSymbolType() + " " + $2->GetSymbolName() + "(";

			
			for(int Counter = 0; Counter < $4->ParamList.size(); Counter++){
				if($4->ParamList[Counter]->GetIdentity() == "Type_Only")	Line += $4->ParamList[Counter]->GetSymbolType();
				else Line += $4->ParamList[Counter]->GetSymbolType() + " " + $4->ParamList[Counter]->GetSymbolName();
				
				if(Counter != $4->ParamList.size() - 1){
					Line += ", ";
				}
			}
			Line += ");";
			
			SymbolInfo* sym = new SymbolInfo(Line, "function_declaration");
			$$ = sym;
			
			fprintf(Log, "%s\n\n", Line.c_str());
			
			// parameter_list populated Parameter vector, so it needs to be cleared
			Parameters.clear();
			
		}
		| type_specifier ID LPAREN RPAREN SEMICOLON
		{
			fprintf(Log, "Line no. %d: func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON\n\n", line_count);
			
			SymbolInfo* Sym = new SymbolInfo($2->GetSymbolName(), "ID");
			
			if(table->LookUp($2->GetSymbolName())){
				printErr("Previous Declaration of Function \'"+$2->GetSymbolName()+"\' Found\n\n",line_count);
			}else{
				Sym->SetReturnType($1->GetSymbolType());
				Sym->SetIdentity("func_declaration");
				table->Insert(Sym);
			}
			
			string Line = "";
			Line += $1->GetSymbolType() + " " + $2->GetSymbolName() + "();";
			
			$$ = new SymbolInfo(Line, "function_declaration");
			
			fprintf(Log, "%s\n\n", Line.c_str());
			
			// No parameter_list was used, so Parameters needs not be cleared
		}
		;

func_definition : type_specifier ID LPAREN parameter_list RPAREN LCURL{

			table->EnterScope(Log);
			
			// Since parameter_list is used, the parameters stored in Parameters vector will populate the new scope
			for(int Counter = 0; Counter < Parameters.size(); Counter++){
				SymbolInfo* ParamToInsert = new SymbolInfo(Parameters[Counter]->GetSymbolName(), Parameters[Counter]->GetSymbolType());
				ParamToInsert->SetVariableType(Parameters[Counter]->GetVariableType());
				
				// Variable already exists in current scope
				
				if(table->LookUpCurrentScope(Parameters[Counter]->GetSymbolName())){
					printErr("Multiple Declaration of \'"+Parameters[Counter]->GetSymbolName()+"\'\n\n",line_count);
				}else{
					table->Insert(ParamToInsert);
					
					//For Assembly
					class VariableIdentity Temp;
					Temp.Name = Parameters[Counter]->GetSymbolName() + table->GetCurrentScopeID();
					Temp.Size = "0";
					VariablesUsed.push_back(Temp);
				}
			}	

		} statements RCURL
		{
			fprintf(Log, "Line no. %d: func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement\n\n", line_count);
			string Lines = "";
			Lines += $1->GetSymbolType() + " " + $2->GetSymbolName() + "(";
			
			for(int Counter = 0; Counter < $4->ParamList.size(); Counter++){
				Lines += $4->ParamList[Counter]->GetSymbolType() + " " + $4->ParamList[Counter]->GetSymbolName();
				if(Counter != $4->ParamList.size() - 1){
					Lines += ", ";
				}
			}
			Lines += "){\n"; //+ $8->GetSymbolName() + "\n}";
			for(int Counter = 0; Counter < $8->ParamList.size(); Counter++){
				Lines += $8->ParamList[Counter]->GetSymbolName() + "\n";
			}
			Lines += "}";
			
			fprintf(Log, "%s\n\n", Lines.c_str());
			
			SymbolInfo* FuncDef = new SymbolInfo(Lines, "func_definition");
			$$ = FuncDef;
			
			//Generate Assembly Code
			string code = "";
			if($2->GetSymbolName() == "main"){
				code += "MAIN PROC\n";
				code += "    ;Initialize Data Segment\n";
				code += "    MOV AX, @DATA\n";
				code += "    MOV DS, AX\n\n";
			}else{
				code += $2->GetSymbolName() + " PROC\n";
				code += "    ;Save Address\n";
				code += "    POP ADDRESS\n\n";
				code += "    ;Get Function Parameters\n";
				
				for(int Counter = Parameters.size() - 1; Counter >= 0; Counter--){
					code += "    POP " + Parameters[Counter]->GetSymbolName() + table->GetCurrentScopeID() + "\n";
				}
			}
			
			code += $8->GetCode();
			
			if($2->GetSymbolName() == "main"){
				code += "    ;End of main\n";
				code += "    MOV AH, 4CH\n";
				code += "    INT 21H\n";
				code += "MAIN ENDP\n";
			}
			else{
				code += "    ;Push Return Value\n";
				
				if(ReturnStatementType != ""){
					if(ReturnExp.Size == "0"){
						//code += "    MOV AX, " + ReturnExp.Name + "\n";
						code += "    PUSH " + ReturnExp.Name + "\n";
					}else{
						code += "    LEA SI, " + ReturnExp.Name + "\n";
						code += "    ADD SI, " + ReturnExp.Size + "*2\n";
						//code += "    MOV AX, [SI]\n";
						code += "    PUSH [SI]\n";
					}
				}
				code += "    PUSH ADDRESS\n";
				code += "    RET\n";
				code += $2->GetSymbolName() + " ENDP\n\n";
			}
			
			$$->SetCode(code);
			
			bool ReturnTypeErrorFound = false;
			
			// Check if the function was DECLARED before
			SymbolInfo* Declared = table->LookUp($2->GetSymbolName());
			
			// The name exists in the scopetable
			if(Declared){
				// If the name is not of a DECLARATION, then its an error
				if(Declared->GetIdentity() != "func_declaration"){
					printErr("Previous Definition of \'"+$2->GetSymbolName()+"\' Found\n\n",line_count);
				}
				// DECLARATION found, now to see if parameter counts match
				else if(Declared->ParamList.size() != $4->ParamList.size()){
					printErr("Parameter Count Of \'"+$2->GetSymbolName()+"\' Does Not Match With The Declaration\n\n",line_count);
				}
				// Everything in order, now to see if parameter list match
				else{
					bool Match = true;
					
					for(int Counter = 0; Counter < $4->ParamList.size(); Counter ++){
						// Check if type specifier matches
						if(Declared->ParamList[Counter]->GetSymbolType() != $4->ParamList[Counter]->GetSymbolType()){
							Match = false;
							break;
						}
					}
					// Parameters matched
					if(Match){
						// Now check if the return statement matched with the declaration
						if($1->GetSymbolType() == Declared->GetReturnType()){
							// The function definition is complete, no further definition should be allowed, so, Declared should be marked as Defined in the SymbolTable
							Declared->SetIdentity("function_definition");
							Declared->SetImplementationID(table->GetCurrentScopeID());
						}
						else{
							printErr("Return Type Of \'"+$2->GetSymbolName()+"\' Does Not Match With The Declaration\n\n",line_count);
							ReturnTypeErrorFound = true;
						}
					}
					// Parameters Did Not Match
					else{
						printErr("Parameters Of \'"+$2->GetSymbolName()+"\' Does Not Match With The Declaration\n\n",line_count);
					}
					
				}
			}
			
			// The Name Does Not Exist in the ScopeTable, So, It was not Declared before
			else{
				SymbolInfo* Defined = new SymbolInfo($2->GetSymbolName(), "ID");
				Defined->SetIdentity("function_definition");
				Defined->SetReturnType($1->GetSymbolType());
				
				for(int Counter = 0; Counter < Parameters.size(); Counter++){
					Defined->ParamList.push_back(Parameters[Counter]);
				}
				Defined->SetImplementationID(table->GetCurrentScopeID());
				table->InsertToGlobalScope(Defined);
			}
			
			if(!ReturnTypeErrorFound){
				// Match return type with definition
				// A void function with return statement of other type
				if($1->GetSymbolType() == "void" && ReturnStatementType != ""){
					printErr("Return With Value in Function Returning Void\n\n",line_count);
				}
				// A non void function without a return type
				else if($1->GetSymbolType() != "void" && ReturnStatementType == ""){
					if($2->GetSymbolName() == "main"){}
					else{
						printErr("Return With No Value in Function Returning Non-Void\n\n", line_count);
					}
				}
				// Mismatch in return type except void
				else if($1->GetSymbolType() != "void" && $1->GetSymbolType() != ReturnStatementType){
					if($1->GetSymbolType() == "float" && ReturnStatementType == "int"){}
					else{
						printErr("Incompatible Return Type\n\n", line_count);
					}
				}
				ReturnStatementType = "";
			}
			ReturnCalled = false;
			Parameters.clear();
			
			// Exit the scope
			table->PrintAllScopes(Log);
			table->ExitScope(Log);
		}
		| type_specifier ID LPAREN RPAREN LCURL{
			// This time, just creating a new scope is enough
			table->EnterScope(Log);
		} statements RCURL
		{
			fprintf(Log, "Line no. %d: func_definition : type_specifier ID LPAREN RPAREN compound_statement\n\n", line_count);
			string Lines = "";
			Lines += $1->GetSymbolType() + " " + $2->GetSymbolName() + "(){\n";//+ $7->GetSymbolName() + "\n}";
			for(int Counter = 0; Counter < $7->ParamList.size(); Counter++){
				Lines += $7->ParamList[Counter]->GetSymbolName() + "\n";
			}
			Lines += "}";
			fprintf(Log, "%s\n\n", Lines.c_str());
			
			$$ = new SymbolInfo(Lines, "func_definition");

			//Generate Assembly Code
			string code = "";
			if($2->GetSymbolName() == "main"){
				code += "MAIN PROC\n";
				code += "    ;Initialize Data Segment\n";
				code += "    MOV AX, @DATA\n";
				code += "    MOV DS, AX\n\n";
			}else{
				code += $2->GetSymbolName() + " PROC\n";
				code += "    ;Save Address\n";
				code += "    POP ADDRESS\n\n";
			}
			
			code += $7->GetCode();
			
			if($2->GetSymbolName() == "main"){
				code += "    ;End of main\n";
				code += "    MOV AH, 4CH\n";
				code += "    INT 21H\n";
				code += "MAIN ENDP\n";
			}
			else{
				code += "    ;Push Return Value\n";
				if(ReturnStatementType != ""){
					if(ReturnExp.Size == "0"){
						//code += "    MOV AX, " + ReturnExp.Name + "\n";
						code += "    PUSH " + ReturnExp.Name + "\n";
					}else{
						code += "    LEA SI, " + ReturnExp.Name + "\n";
						code += "    ADD SI, " + ReturnExp.Size + "*2\n";
						//code += "    MOV AX, [SI]\n";
						code += "    PUSH [SI]\n";
					}
				}
				code += "    PUSH ADDRESS\n";
				code += "    RET\n";
				code += $2->GetSymbolName() + " ENDP\n\n";
			}
			
			$$->SetCode(code);
			
			bool ReturnTypeErrorFound = false;
			
			// Check if the function was DECLARED before
			SymbolInfo* Declared = table->LookUp($2->GetSymbolName());
			
			// The name exists in the scopetable
			if(Declared){
				// If the name is not of a DECLARATION, then its an error
				if(Declared->GetIdentity() != "func_declaration"){
					printErr("Previous Definition of \'"+$2->GetSymbolName()+"\' Found\n\n", line_count);
				}
				// DECLARATION found, the function can't have any parameters declared before
				else if(Declared->ParamList.size() > 0){
					printErr("Parameter Count Of \'"+$2->GetSymbolName()+"\' Does Not Match With The Declaration\n\n", line_count);
				}
				// Everything is fine
				else{
					// Now check if the return statement matched with the declaration
					if($1->GetSymbolType() == Declared->GetReturnType()){
						// The function definition is complete, no further definition should be allowed, so, Declared should be marked as Defined in the SymbolTable
						Declared->SetIdentity("function_definition");
						Declared->SetImplementationID(table->GetCurrentScopeID());
					}
					else{
						printErr("Return type Of \'"+$2->GetSymbolName()+"\' Does Not Match With The Declaration\n\n", line_count);
						ReturnTypeErrorFound = true;
					}
				}
			}
			// The Name Does Not Exist in the ScopeTable, So, It was not Declared before
			else{
				// Exit the scope
				SymbolInfo* Defined = new SymbolInfo($2->GetSymbolName(), "ID");
				Defined->SetIdentity("function_definition");
				Defined->SetReturnType($1->GetSymbolType());
				Defined->SetImplementationID(table->GetCurrentScopeID());
				table->InsertToGlobalScope(Defined);
			}
			
			if(!ReturnTypeErrorFound){
				// Match return type with definition
				// A void function with return statement of other type
				if($1->GetSymbolType() == "void" && ReturnStatementType != ""){
					printErr("Return With Value in Function Returning Void\n\n", line_count);
				}
				// A non void function without a return type
				else if($1->GetSymbolType() != "void" && ReturnStatementType == ""){
					if($2->GetSymbolName() == "main"){}
					else{
						printErr("Return With No Value in Function Returning Non-Void\n\n", line_count);
					}
				}
				// Mismatch in return type
				else if($1->GetSymbolType() != "void" && $1->GetSymbolType() != ReturnStatementType){
					if($1->GetSymbolType() == "float" && ReturnStatementType == "int"){}
					else{
						printErr("Incompatible Return Type\n\n", line_count);
					}
				}
				ReturnStatementType = "";
			}
			ReturnCalled = false;
			// Exit the scope
			table->PrintAllScopes(Log);
			table->ExitScope(Log);
		}
 		;				


parameter_list  : parameter_list COMMA type_specifier ID
		{
			fprintf(Log, "Line no. %d: parameter_list  : parameter_list COMMA type_specifier ID\n\n", line_count);
			
			SymbolInfo* NewParam = new SymbolInfo($4->GetSymbolName(),$3->GetSymbolType());
			NewParam->SetIdentity("Variable"); 
			NewParam->SetVariableType($3->GetSymbolType());
			$$->ParamList.push_back(NewParam);
			
			SymbolInfo* IDParam = new SymbolInfo($4->GetSymbolName(), "ID");
			IDParam->SetVariableType($3->GetSymbolType());
			Parameters.push_back(IDParam);
			
			for(int Counter = 0; Counter < $$->ParamList.size(); Counter++){
				if($$->ParamList[Counter]->GetIdentity() == "Type_Only") fprintf(Log, "%s", $$->ParamList[Counter]->GetSymbolType().c_str());
				else fprintf(Log, "%s %s", $$->ParamList[Counter]->GetSymbolType().c_str(), $$->ParamList[Counter]->GetSymbolName().c_str());
				if(Counter != $$->ParamList.size() - 1){
					fprintf(Log, ", ");
				}
			}
			
			fprintf(Log, "\n\n");
		}
		| parameter_list COMMA type_specifier
		{
			fprintf(Log, "Line no. %d: parameter_list  : parameter_list COMMA type_specifier\n\n", line_count);
			
			SymbolInfo* NewParam = new SymbolInfo("",$3->GetSymbolType());
			NewParam->SetIdentity("Type_Only"); 
			$$->ParamList.push_back(NewParam);
			
			for(int Counter = 0; Counter < $$->ParamList.size(); Counter++){
				if($$->ParamList[Counter]->GetIdentity() == "Type_Only") fprintf(Log, "%s", $$->ParamList[Counter]->GetSymbolType().c_str());
				else fprintf(Log, "%s %s", $$->ParamList[Counter]->GetSymbolType().c_str(), $$->ParamList[Counter]->GetSymbolName().c_str());
				if(Counter != $$->ParamList.size() - 1){
					fprintf(Log, ", ");
				}
			}
			
			fprintf(Log, "\n\n");
		}
 		| type_specifier ID
 		{
			fprintf(Log, "Line no. %d: parameter_list  : type_specifier ID\n\n", line_count);
			
			// Need A SymbolInfo To Contain The List
			SymbolInfo* List = new SymbolInfo("parameter_list");
			$$ = List;
			
			// Insert This Parameter Into the List
			SymbolInfo* NewParam = new SymbolInfo($2->GetSymbolName(),$1->GetSymbolType());
			NewParam->SetIdentity("Variable"); 
			NewParam->SetVariableType($1->GetSymbolType());
			$$->ParamList.push_back(NewParam);
			
			// The variable Parameters stores the names of the IDs, if needed, they can be used to populate a new scope, for example, when a function definition is being used
			// If not needed, the variable is cleared later
			SymbolInfo* IDParam = new SymbolInfo($2->GetSymbolName(), "ID");
			IDParam->SetVariableType($1->GetSymbolType());
			Parameters.push_back(IDParam);
			
			
			fprintf(Log, "%s %s\n\n", $1->GetSymbolType().c_str(), $2->GetSymbolName().c_str());
		}
		| type_specifier
		{
			fprintf(Log, "Line no. %d: parameter_list  : type_specifier\n\n", line_count);
			
			// Need A SymbolInfo To Contain The List
			SymbolInfo* List = new SymbolInfo("parameter_list");
			$$ = List;
			
			// Insert This Parameter Into the List
			SymbolInfo* NewParam = new SymbolInfo("",$1->GetSymbolType());
			NewParam->SetIdentity("Type_Only"); 
			$$->ParamList.push_back(NewParam);
			
			fprintf(Log, "%s\n\n", $1->GetSymbolType().c_str());
		}
 		;

 		
compound_statement : LCURL{
			//table->EnterScope(Log);		
		} statements RCURL
		{
			fprintf(Log, "Line no. %d: compound_statement : LCURL statements RCURL\n\n", line_count);
			
			string Lines = "";
			Lines += "{\n";
			for(int Counter = 0; Counter < $3->ParamList.size(); Counter++){
				Lines += $3->ParamList[Counter]->GetSymbolName() + "\n";
			}
			Lines += "}";
			fprintf(Log, "%s\n\n", Lines.c_str());
			
			$$ = $3;
			$$->SetSymbolName(Lines);
			$$->SetSymbolType("compound_statement");
			//table->PrintAllScopes(Log);
			//table->ExitScope(Log);
		}
 		| LCURL RCURL
		{
			fprintf(Log, "Line no. %d: compound_statement : LCURL RCURL\n\n", line_count);
			fprintf(Log, "{}\n\n");
			
			SymbolInfo* ComStat = new SymbolInfo("{}", "compound_statement");
			$$ = ComStat;
		}
 		;
 		    
var_declaration : type_specifier declaration_list SEMICOLON
		{
			fprintf(Log, "Line no. %d: var_declaration : type_specifier declaration_list SEMICOLON\n\n", line_count);
			string Lines = "";
			
			Lines += $1->GetSymbolType() + " ";
			for(int Counter = 0; Counter < $2->ParamList.size(); Counter++){
				Lines += $2->ParamList[Counter]->GetSymbolName();
				if($2->ParamList[Counter]->GetIdentity() == "array"){
					Lines += "[" + to_string($2->ParamList[Counter]->GetVariableSize()) + "]";
				}
				if(Counter != $2->ParamList.size()-1){
					Lines += ", ";
				}
			}
			Lines += ";";
			
			SymbolInfo* VarDec = new SymbolInfo(Lines, "var_declaration");
			$$ = VarDec;
			// Did not Generate Any Code, Since the Declaration Part Will be Done on program rule
			
			// Void Variable is not allowed
			if($1->GetSymbolType() == "void"){
				printErr("Variable or Field Declared Void\n\n", line_count);
			}
			fprintf(Log, "%s\n\n", Lines.c_str());
			$2->ParamList.clear();
		}
 		;
 		 
type_specifier : INT
		{
			fprintf(Log, "Line no. %d: type_specifier : INT\n\n", line_count);
			TypeSpecifier = "int";
			
			SymbolInfo* TypeSpec = new SymbolInfo("int");
			$$ = TypeSpec;
			
			fprintf(Log, "%s\n\n", $$->GetSymbolType().c_str());
		}
 		| FLOAT
 		{
			fprintf(Log, "Line no. %d: type_specifier : FLOAT\n\n", line_count);
			TypeSpecifier = "float";
			
			SymbolInfo* TypeSpec = new SymbolInfo("float");
			$$ = TypeSpec;
			
			fprintf(Log, "%s\n\n", $$->GetSymbolType().c_str());
		}
 		| VOID
 		{
			fprintf(Log, "Line no. %d: type_specifier : VOID\n\n", line_count);
			TypeSpecifier = "void";
			
			SymbolInfo* TypeSpec = new SymbolInfo("void");
			$$ = TypeSpec;
			
			fprintf(Log, "%s\n\n", $$->GetSymbolType().c_str());
		}
 		;
 		
declaration_list : declaration_list COMMA ID
		{
			fprintf(Log, "Line no. %d: declaration_list : declaration_list COMMA ID\n\n", line_count);
			
			SymbolInfo* Temp = new SymbolInfo($3->GetSymbolName(), $3->GetSymbolType());
			Temp->SetVariableType(TypeSpecifier);
			Temp->SetIdentity("Variable");
			if(table->GetCurrentScopeID() == "1"){
				Temp->GlobalVar = true;
			}
			$$->ParamList.push_back(Temp);
			
			class VariableIdentity VarID;
			VarID.Name = $3->GetSymbolName() + table->GetCurrentScopeID();
			VarID.Size = "0";
			VariablesUsed.push_back(VarID);
			
			// Variable Already Declared
			if(table->LookUpCurrentScope($3->GetSymbolName())){
				printErr("Multiple Declaration of \'"+$3->GetSymbolName()+"\' In Current Scope\n\n", line_count);
			}
			else if(TypeSpecifier != "void"){ 
				table->Insert(Temp);
			}
			
			// Print the List
			for(int Counter = 0; Counter < $$->ParamList.size(); Counter++){
				fprintf(Log, "%s", $$->ParamList[Counter]->GetSymbolName().c_str());
				if($$->ParamList[Counter]->GetIdentity() == "array"){
					fprintf(Log, "[%d]", $$->ParamList[Counter]->GetVariableSize());
				}
				if(Counter != $$->ParamList.size() - 1){
					fprintf(Log, ", ");
				}
			}
			fprintf(Log, "\n\n");
		}
 		| declaration_list COMMA ID LTHIRD CONST_INT RTHIRD
		{
			fprintf(Log, "Line no. %d: declaration_list : declaration_list COMMA ID LTHIRD CONST_INT RTHIRD\n\n", line_count);
			int ArraySize = atoi($5->GetSymbolName().c_str());
			
			SymbolInfo* Temp = new SymbolInfo($3->GetSymbolName(), $3->GetSymbolType());
			Temp->SetVariableType(TypeSpecifier);
			Temp->SetIdentity("array");
			Temp->SetVariableSize(ArraySize);
			$$->ParamList.push_back(Temp);
			
			class VariableIdentity VarID;
			VarID.Name = $3->GetSymbolName() + table->GetCurrentScopeID();
			VarID.Size = $5->GetSymbolName();
			VariablesUsed.push_back(VarID);
			
			// Array of 0 or negative size
			if(ArraySize < 1){
				printErr("Cannot allocate an array of constant size "+$5->GetSymbolName()+"\n\n", line_count);

			}
			// Variable Already Declared
			else if(table->LookUpCurrentScope($3->GetSymbolName())){
				printErr("Multiple Declaration of \'"+$3->GetSymbolName()+"\' In Current Scope\n\n", line_count);
			}
			else if(TypeSpecifier != "void"){
				if(TypeSpecifier == "int") Temp->CreateIntegerArray();
				else if(TypeSpecifier == "float") Temp->CreateFloatArray();
				else if(TypeSpecifier == "char") Temp->CreateCharacterArray();
				table->Insert(Temp);
			}
			
			// Print the List
			for(int Counter = 0; Counter < $$->ParamList.size(); Counter++){
				fprintf(Log, "%s", $$->ParamList[Counter]->GetSymbolName().c_str());
				if($$->ParamList[Counter]->GetIdentity() == "array"){
					fprintf(Log, "[%d]", $$->ParamList[Counter]->GetVariableSize());
				}
				if(Counter != $$->ParamList.size() - 1){
					fprintf(Log, ", ");
				}
			}
			fprintf(Log, "\n\n");
		}
 		| ID
		{
			fprintf(Log, "Line no. %d: declaration_list : ID\n\n", line_count);
			fprintf(Log, "%s\n\n", $1->GetSymbolName().c_str());
			
			SymbolInfo* List = new SymbolInfo("declaration_list");
			List->SetIdentity("declaration_list");
			$$ = List;
			
			SymbolInfo* Temp = new SymbolInfo($1->GetSymbolName(), $1->GetSymbolType());
			Temp->SetVariableType(TypeSpecifier);
			Temp->SetIdentity("Variable");
			if(table->GetCurrentScopeID() == "1"){
					Temp->GlobalVar = true;
			}
			$$->ParamList.push_back(Temp);
			
			class VariableIdentity VarID;
			VarID.Name = $1->GetSymbolName() + table->GetCurrentScopeID();
			VarID.Size = "0";
			VariablesUsed.push_back(VarID);
			
			// Variable Already Declared
			if(table->LookUpCurrentScope($1->GetSymbolName())){
				printErr("Multiple Declaration of \'"+$1->GetSymbolName()+"\' In Current Scope\n\n", line_count);
			}
			else if(TypeSpecifier != "void"){
				table->Insert(Temp);
			}
			
		}
 		| ID LTHIRD CONST_INT RTHIRD
		{
			fprintf(Log, "Line no. %d: declaration_list : ID LTHIRD CONST_INT RTHIRD\n\n", line_count);
			fprintf(Log, "%s[%s]\n\n", $1->GetSymbolName().c_str(), $3->GetSymbolName().c_str());
			
			SymbolInfo* List = new SymbolInfo("declaration_list");
			List->SetIdentity("declaration_list");
			$$ = List;
			int ArraySize = atoi($3->GetSymbolName().c_str());
			
			SymbolInfo* Temp = new SymbolInfo($1->GetSymbolName(), $1->GetSymbolType());
			Temp->SetVariableType(TypeSpecifier);
			Temp->SetIdentity("array");
			Temp->SetVariableSize(ArraySize);
			$$->ParamList.push_back(Temp);
			
			class VariableIdentity VarID;
			VarID.Name = $1->GetSymbolName() + table->GetCurrentScopeID();
			VarID.Size = $3->GetSymbolName();
			VariablesUsed.push_back(VarID);
			
			// Array of 0 or negative size
			if(ArraySize < 1){
				printErr("Cannot allocate an array of constant size "+$3->GetSymbolName()+"\n\n", line_count);
			}
			// Variable Already Declared
			else if(table->LookUpCurrentScope($1->GetSymbolName())){
				printErr("Multiple Declaration of \'"+$1->GetSymbolName()+"\' In Current Scope\n\n", line_count);
			}
			else if(TypeSpecifier != "void"){
				if(TypeSpecifier == "int") Temp->CreateIntegerArray();
				else if(TypeSpecifier == "float") Temp->CreateFloatArray();
				else if(TypeSpecifier == "char") Temp->CreateCharacterArray();
				table->Insert(Temp);
			}
		}
 		;
 		  
statements : statement
		{
			fprintf(Log, "Line no. %d: statements : statement\n\n", line_count);
			fprintf(Log, "%s\n\n", $1->GetSymbolName().c_str());
			
			SymbolInfo* Statements = new SymbolInfo("statements");
			Statements->ParamList.push_back($1);
			$$ = Statements;
			$$->SetCode($1->GetCode());
		}
	    | statements statement
		{
			fprintf(Log, "Line no. %d: statements : statements statement\n\n", line_count);
			string Lines = "";
			$$ = $1;
			$$->ParamList.push_back($2);
			for(int Counter = 0; Counter < $1->ParamList.size(); Counter++){
				Lines += $1->ParamList[Counter]->GetSymbolName() + "\n";
			}
			fprintf(Log, "%s\n\n", Lines.c_str());
			$$->SetCode($1->GetCode() + $2->GetCode());
		}
	    ;
	   
statement : var_declaration
		{
			fprintf(Log, "Line no. %d: statement : var_declaration\n\n", line_count);
			fprintf(Log, "%s\n\n", $1->GetSymbolName().c_str());
			$$ = $1;
			$$->SetSymbolType("statement");
		}
	    | expression_statement
		{
			fprintf(Log, "Line no. %d: statement : expression_statement\n\n", line_count);
			fprintf(Log, "%s\n\n", $1->GetSymbolName().c_str());
			$$ = $1;
			$$->SetSymbolType("statement");
		}
	    | compound_statement
		{
			fprintf(Log, "Line no. %d: statement : compound_statement\n\n", line_count);
			fprintf(Log, "%s\n\n", $1->GetSymbolName().c_str());
			$$ = $1;
			$$->SetSymbolType("statement");
		}
	    | FOR LPAREN expression_statement expression_statement expression RPAREN statement
		{
			fprintf(Log, "Line no. %d: statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement\n\n", line_count);
			string Lines = "";
			Lines += "for(" + $3->GetSymbolName() + $4->GetSymbolName() + $5->GetSymbolName() + ")" + $7->GetSymbolName();
			fprintf(Log, "%s\n\n", Lines.c_str());
			
			string LoopLabel = NewLabel();
			string DoneLabel = NewLabel();
			string code = "    ;for loop\n";
			
			/*
				1. Initialize ($3)
				2. Label, Comparison to see if loop is running ($4)
				3. Loop Body ($7)
				4. Update Loop Variable ($5)
				5. Goto 2
				6. Label, Exit
			*/
			
			code += $3->GetCode();
			code += LoopLabel + ":\n";
			code += $4->GetCode();
			code += "    MOV AX, " + $4->GetAssemblySymbol() + "\n";
			code += "    CMP AX, 0\n";
			code += "    JE " + DoneLabel + "\n";
			code += $7->GetCode();
			code += $5->GetCode();
			code += "    JMP " + LoopLabel + "\n\n";
			code += DoneLabel + ":\n";
			
			SymbolInfo* Stat = new SymbolInfo(Lines, "statement");
			$$ = Stat;
			if(!ReturnCalled){
				$$->SetCode(code);
			}
		}
	    | IF LPAREN expression RPAREN statement %prec LOWER_THAN_ELSE
		{
			fprintf(Log, "Line no. %d: statement : IF LPAREN expression RPAREN statement\n\n", line_count);
			string Lines = "";
			Lines += "if(" + $3->GetSymbolName() + ")" + $5->GetSymbolName();
			fprintf(Log, "%s\n\n", Lines.c_str());
			
			string Else = NewLabel();
			string code = $3->GetCode();
			code += "    ;if(" + $3->GetSymbolName() + ")\n";
			code += "    MOV AX, " + $3->GetAssemblySymbol() + "\n";
			code += "    CMP AX, 0\n";
			code += "    JE " + Else + "\n";
			code += $5->GetCode();
			code += Else + ":\n";
			
			SymbolInfo* Stat = new SymbolInfo(Lines, "statement");
			$$ = Stat;
			if(!ReturnCalled){
				$$->SetCode(code);
			}
		}
	    | IF LPAREN expression RPAREN statement ELSE statement
		{
			fprintf(Log, "Line no. %d: statement : IF LPAREN expression RPAREN statement ELSE statement\n\n", line_count);
			 string Lines = "";
			Lines += "if(" + $3->GetSymbolName() + ")" + $5->GetSymbolName() + "else" + $7->GetSymbolName();
			fprintf(Log, "%s\n\n", Lines.c_str());
			
			string Else = NewLabel();
			string DoneLabel = NewLabel();
			string code = $3->GetCode();
			code += "    ;if(" + $3->GetSymbolName() + ")...else...\n";
			code += "    MOV AX, " + $3->GetAssemblySymbol() + "\n";
			code += "    CMP AX, 0\n";
			code += "    JE " + Else + "\n";
			code += $5->GetCode();
			code += "    JMP " + DoneLabel + "\n\n";
			
			code += Else + ":\n";
			code += $7->GetCode();
			
			code += DoneLabel + ":\n";
			
			SymbolInfo* Stat = new SymbolInfo(Lines, "statement");
			$$ = Stat;
			if(!ReturnCalled){
				$$->SetCode(code);
			}
		}
	    | WHILE LPAREN expression RPAREN statement
		{
			fprintf(Log, "Line no. %d: statement : WHILE LPAREN expression RPAREN statement\n\n", line_count);
			string Lines = "";
			Lines += "while(" + $3->GetSymbolName() + ")" + $5->GetSymbolName();
			fprintf(Log, "%s\n\n", Lines.c_str());
			
			/*
				1. Comparison to see if loop runs
				2. Loop Body
				3. Goto 1
				4. Exit
			*/
			
			string LoopLabel = NewLabel();
			string DoneLabel = NewLabel();
			string code = "    ;while()\n";
			code += LoopLabel + ":\n";
			code += $3->GetCode();
			code += "    MOV AX, " + $3->GetAssemblySymbol() + "\n";
			code += "    CMP AX, 0\n";
			code += "    JE " + DoneLabel + "\n";
			code += $5->GetCode();
			code += "    JMP " + LoopLabel + "\n\n";
			code += DoneLabel + ":\n";
			
			SymbolInfo* Stat = new SymbolInfo(Lines, "statement");
			$$ = Stat;
			if(!ReturnCalled){
				$$->SetCode(code);
			}
		}
	    | PRINTLN LPAREN ID RPAREN SEMICOLON
		{
			fprintf(Log, "Line no. %d: statement : PRINTLN LPAREN ID RPAREN SEMICOLON\n\n", line_count);
			string Line = "println(" + $3->GetSymbolName() + ");";
			fprintf(Log, "%s\n\n", Line.c_str());
			
			SymbolInfo* Stat = new SymbolInfo(Line, "statement");
			$$ = Stat;
			
			SymbolInfo* Var = table->LookUp($3->GetSymbolName());
			if(!Var){
				fprintf(error_out, "Error at Line %d: \'%s\' Undeclared\n\n", line_count, $3->GetSymbolName().c_str());
				fprintf(Log, "Error at Line %d: \'%s\' Undeclared\n\n", line_count, $3->GetSymbolName().c_str());
				errCounter++;
			}
			string code = "    ;println(" + $3->GetSymbolName() + ")\n";
			if(Var->GlobalVar){
				code += "    MOV AX, " + $3->GetSymbolName() + "1\n";
			}
			else{
				code += "    MOV AX, " + $3->GetSymbolName() + table->GetCurrentScopeID() + "\n";
			}
			code += "    CALL PRINTLN\n\n";
			if(!ReturnCalled){
				$$->SetCode(code);
			}
		}
	    | RETURN expression SEMICOLON
		{
			fprintf(Log, "Line no. %d: statement : RETURN expression SEMICOLON\n\n", line_count);
			fprintf(Log, "return %s;\n\n", $2->GetSymbolName().c_str());
			
			SymbolInfo* Stat = new SymbolInfo("return " + $2->GetSymbolName() + ";", "statement");
			$$ = Stat;
			if(!ReturnCalled){
				$$->SetCode($2->GetCode());
			}
			ReturnStatementType = $2->GetVariableType();
			class VariableIdentity ReturnIdentity;
			ReturnIdentity.Name = $2->GetAssemblySymbol();
			if($2->GetIdentity() == "AccessArray"){
				ReturnIdentity.Size = to_string($2->GetArrayAccessVariable());
			}
			else{
				ReturnIdentity.Size = "0";
			}
			ReturnExp = ReturnIdentity;
			ReturnCalled = true;
		}
	    ;
	  
expression_statement : SEMICOLON			
		{
			fprintf(Log, "Line no. %d: expression_statement : SEMICOLON\n\n", line_count);
			fprintf(Log, ";\n\n");
			
			SymbolInfo* Semicolon = new SymbolInfo(";", "expression_statement");
			$$ = Semicolon;
		}
		| expression SEMICOLON 
		{
			fprintf(Log, "Line no. %d: expression_statement : expression SEMICOLON\n\n", line_count);
			fprintf(Log, "%s;\n\n", $1->GetSymbolName().c_str());
			
			$$ = $1;
			$$->SetSymbolName($1->GetSymbolName() + ";");
			$$->SetSymbolType("expression_statement");
		}
		;
	  
variable : ID 		
		{
			fprintf(Log, "Line no. %d: variable : ID\n\n", line_count);
			fprintf(Log, "%s\n\n", $1->GetSymbolName().c_str());
			$$ = $1;
			// This nonterminal is used as operand or argument, not for declaration. So, it must be declared before.
			SymbolInfo* Temp = table->LookUp($1->GetSymbolName());
			if(!Temp){
				printErr("\'"+$1->GetSymbolName()+"\' Undeclared\n\n", line_count);
				$$->SetVariableType("error");
			}else{
				$$->SetVariableType(Temp->GetVariableType());
				if(Temp->GetVariableType() == "int"){
					$$->IValue = Temp->IValue;
				}else if(Temp->GetVariableType() == "float"){
					$$->FValue = Temp->FValue;
				}
				$$->RetVal = Temp->RetVal;
				$$->GlobalVar = Temp->GlobalVar;
			}
			$$->SetIdentity("Variable");
		}
	    | ID LTHIRD expression RTHIRD 
		{
			fprintf(Log, "Line no. %d: variable : ID LTHIRD expression RTHIRD\n\n", line_count);
			fprintf(Log, "%s[%s]\n\n", $1->GetSymbolName().c_str(), $3->GetSymbolName().c_str());
			
			SymbolInfo* ArrayVariable = new SymbolInfo($1->GetSymbolName(), "Variable");
			ArrayVariable->SetIdentity("AccessArray");
			
			// Is It Declared?
			SymbolInfo* Temp = table->LookUp($1->GetSymbolName());
			if(!Temp){
				printErr("\'"+$1->GetSymbolName()+"\' Undeclared\n\n", line_count);
				ArrayVariable->SetVariableType("error");
			}
			// Is It An Array?
			else if(Temp->GetVariableSize() < 1){
				printErr("Subscripted Value(\'"+$1->GetSymbolName()+"\') Is Not An Array\n\n", line_count);
				ArrayVariable->SetVariableType("error");
			}
			// Index is undefined variable
			else if($3->GetVariableType() == "error"){
				// Do no printing, the error is already caught
				ArrayVariable->SetVariableType("error");
			}
			// Is The Index An Integer?
			else if($3->GetVariableType() != "int"){

				printErr("Array Subscript Is Not An Integer\n\n", line_count);
				ArrayVariable->SetVariableType("error");
			}
			else{
				// Is The Index Within Array Bound?	
				int Index;
				if($3->GetIdentity() == "Variable"){
					Index = $3->IValue;
				}else{
					Index = atoi($3->GetSymbolName().c_str());
				}
				if(Index >= Temp->GetVariableSize()){
					printErr("Array Index Out Of Bound\n\n", line_count);
					ArrayVariable->SetVariableType("error");
				}
				// Is the index positive?
				else if(Index < 0){
					printErr("Array Index Cannot Be Less Than Zero\n\n", line_count);
					ArrayVariable->SetVariableType("error");
				}
				else{
					ArrayVariable->SetArrayAccessVariable(Index);
					ArrayVariable->SetVariableType(Temp->GetVariableType());
					
					if(Temp->GetVariableType() == "int"){
						ArrayVariable->IValue = Temp->IntValue[Index];
					}
					else if(Temp->GetVariableType() == "float"){
						ArrayVariable->FValue = Temp->FloatValue[Index];
					}
					ArrayVariable->RetVal = Temp->RetVal;
				}
			}
			////printf("Var: %s %d\n", $1->GetSymbolName().c_str(), ArrayVariable->GetArrayAccessVariable());
			$$ = ArrayVariable;
		}
	    ;
	 
expression : logic_expression	
		{
			fprintf(Log, "Line no. %d: expression : logic_expression\n\n", line_count);
			fprintf(Log, "%s\n\n", $1->GetSymbolName().c_str());
			$$ = $1;
			$$->SetSymbolType("expression");
		}
	    | variable ASSIGNOP logic_expression 	
		{
			fprintf(Log, "Line no. %d: expression : variable ASSIGNOP logic_expression\n\n", line_count);
			string Line = "";
			Line += $1->GetSymbolName();
			if($1->GetIdentity() == "AccessArray"){
				Line+= "[" + to_string($1->GetArrayAccessVariable()) + "]";
			}
			Line += " = " + $3->GetSymbolName();
			if($3->GetIdentity() == "AccessArray"){
				Line+= "[" + to_string($3->GetArrayAccessVariable()) + "]";
			}
			fprintf(Log, "%s\n\n", Line.c_str());
			
			SymbolInfo* Exp = new SymbolInfo(Line, "expression");
			$$ = Exp;
			
			// Is The Variable Declared?
			SymbolInfo* Temp = table->LookUp($1->GetSymbolName());
			SymbolInfo* Temp2 = table->LookUp($3->GetSymbolName());
			bool NoErrorFlag = true;
			
			string code = $3->GetCode();
			
			if(!Temp){
				// The error should be captured already, So do nothing
			}else{
				Temp->RetVal = $3->RetVal;
				// Is the variable an array (int a[10];) used like a non array (a = 5;)?
				if($1->GetIdentity() != "AccessArray" && Temp->GetIdentity() == "array"){
					printErr("Assignment to Expression with Array Type\n\n", line_count);
					NoErrorFlag = false;
				}
				// Is the variable a non-array (int a;) used like an array (a[5] = 1)?
				else if($1->GetArrayAccessVariable() >= 0 && Temp->GetIdentity() != "array"){
					printErr("Subscripted Value(\'"+$1->GetSymbolName()+"\') Is Not An Array\n\n", line_count);
					NoErrorFlag = false;
				}
				// RVALUE is array type
				else if(Temp2 && Temp2->GetIdentity() == "array" && $3->GetIdentity() != "AccessArray"){
					if($3->GetIdentity() != "Special"){
						printErr("Assignment to Expression with Array Type\n\n", line_count);
						NoErrorFlag = false;
					}
				}
				else if($3->GetVariableType() != "error" && Temp->GetVariableType() != $3->GetVariableType()){
					if(Temp->GetVariableType() == "float" && $3->GetVariableType() == "int"){}
					else if($3->GetVariableType() != "void"){
						printErr("Type Mismatch\n\n", line_count);
						NoErrorFlag = false;
					}
				}
				
				if(NoErrorFlag && $1->GetVariableType() != "error" && $3->GetVariableType() != "error"){
					// a[x] = ...
					if(Temp->GetIdentity() == "array"){
						// a[x] = var;
						if(Temp2){
							////printf("%s\n", Temp2->GetSymbolName().c_str());
							// a[x] = b[y];
							if(Temp2->GetIdentity() == "array" && $3->GetIdentity() != "Special"){
								if($1->GetVariableType() == "int"){
									Temp->IntValue[$1->GetArrayAccessVariable()] = Temp2->IntValue[$3->GetArrayAccessVariable()];
								}
								else{
									Temp->FloatValue[$1->GetArrayAccessVariable()] = $3->GetVariableType() == "float"?Temp2->FloatValue[$3->GetArrayAccessVariable()]:Temp2->IntValue[$3->GetArrayAccessVariable()];
								}
								code += "    ;AX = " + $3->GetSymbolName() + "[" + to_string($3->GetArrayAccessVariable()) + "]\n";
								code += "    LEA SI, " + $3->GetAssemblySymbol() + "\n";
								code += "    ADD SI, " + to_string($3->GetArrayAccessVariable()) + "*2\n";
								code += "    MOV AX, [SI]\n\n";
							}
							// a[x] = b;
							else{
								if($1->GetVariableType() == "int"){
									Temp->IntValue[$1->GetArrayAccessVariable()] = Temp2->IValue;
								}
								else{
									Temp->FloatValue[$1->GetArrayAccessVariable()] = $3->GetVariableType() == "float"?Temp2->FValue:Temp2->IValue;
								}
								code += "    ;AX = " + $3->GetSymbolName() + "\n";
								code += "    MOV AX, " + $3->GetAssemblySymbol() + "\n\n";
							}
						}
						// a[x] = raw value;
						else{
							if($3->GetIdentity() == "Special"){
								code += "    ;AX = " + $3->GetAssemblySymbol() + "\n";
								code += "    MOV AX, " + $3->GetAssemblySymbol() + "\n";
								Temp->IValue = $3->IValue;
								Temp->FValue = $3->FValue;
							}
							else{
								if($1->GetVariableType() == "int"){
									Temp->IntValue[$1->GetArrayAccessVariable()] = $3->IValue;
									code += "    ;AX = " + to_string($3->IValue) + "\n";
									code += "    MOV AX, " + to_string($3->IValue) + "\n\n";
								}
								else{
									Temp->FloatValue[$1->GetArrayAccessVariable()] = $3->GetVariableType() == "float"?$3->FValue:$3->IValue;
								}
							}
						}
						code += "    ;" + $1->GetSymbolName() + "[" + to_string($1->GetArrayAccessVariable()) + "] = AX\n";
						code += "    LEA SI, " + $1->GetSymbolName() + table->GetCurrentScopeID() + "\n";
						code += "    ADD SI, " + to_string($1->GetArrayAccessVariable()) + "*2\n";
						code += "    MOV [SI], AX\n\n";
					}
					else{
						// a = var;
						if(Temp2){
							////printf("%s\n", Temp2->GetSymbolName().c_str());
							// a = b[y];
							if(Temp2->GetIdentity() == "array" && $3->GetIdentity() != "Special"){
								////printf("%s %d\n", $3->GetSymbolName().c_str(), $3->GetArrayAccessVariable());
								if($1->GetVariableType() == "int"){
									Temp->IValue = Temp2->IntValue[$3->GetArrayAccessVariable()];
								}
								else{
									Temp->FValue = $3->GetVariableType() == "float"?Temp2->FloatValue[$3->GetArrayAccessVariable()]:Temp2->IntValue[$3->GetArrayAccessVariable()];
								}
								code += "    ;AX = " + $3->GetSymbolName() + "[" + to_string($3->GetArrayAccessVariable()) + "]\n";
								code += "    LEA SI, " + $3->GetAssemblySymbol() + "\n";
								code += "    ADD SI, " + to_string($3->GetArrayAccessVariable()) + "*2\n";
								code += "    MOV AX, [SI]\n\n";
							}
							// a = b;
							else{
								if($1->GetVariableType() == "int"){
									Temp->IValue = Temp2->IValue;
								}
								else{
									Temp->FValue = $3->GetVariableType() == "float"?Temp2->FValue:Temp2->IValue;
								}
								code += "    ;AX = " + $3->GetSymbolName() + "\n";
								code += "    MOV AX, " + $3->GetAssemblySymbol() + "\n";
							}
						}
						// a = raw value;
						else{
							if($3->GetIdentity() == "Special"){
								code += "    ;AX = " + $3->GetAssemblySymbol() + "\n";
								code += "    MOV AX, " + $3->GetAssemblySymbol() + "\n";
								//printf("%s, %d, %f\n", $3->GetSymbolName().c_str(), $3->IValue, $3->FValue);
								Temp->IValue = $3->IValue;
								Temp->FValue = $3->FValue;
							}
							else{
								if($1->GetVariableType() == "int"){
									Temp->IValue = $3->IValue;
									code += "    ;AX = " + to_string($3->IValue) + "\n";
									code += "    MOV AX, " + to_string($3->IValue) + "\n";
								}
								else{
									Temp->FValue = $3->GetVariableType() == "float"?$3->FValue:$3->IValue;
								}
							}
						}
						code += "    ;" + $1->GetSymbolName() + " = AX\n";
						if($1->GlobalVar){
							code += "    MOV " + $1->GetSymbolName() + "1, AX\n\n";
						}
						else{
							code += "    MOV " + $1->GetSymbolName() + table->GetCurrentScopeID() + ", AX\n\n";
						}
						
					}
					
				}
			}
			
			if($3->GetVariableType() == "void"){
				printErr("Void Value Not Ignored As It Ought To Be\n\n", line_count);
			}
			if(!ReturnCalled){
				$$->SetCode(code);
			}
		}
	    ;
			
logic_expression : rel_expression 	
		{
			fprintf(Log, "Line no. %d: logic_expression : rel_expression\n\n", line_count);
			fprintf(Log, "%s\n\n", $1->GetSymbolName().c_str());
			//$$ = $1;
			$$->SetSymbolType("logic_expression");
		}
		| rel_expression LOGICOP rel_expression 
		{
			fprintf(Log, "Line no. %d: logic_expression : rel_expression LOGICOP rel_expression\n\n", line_count);
			string Line = $1->GetSymbolName() + $2->GetSymbolName() + $3->GetSymbolName();
			fprintf(Log, "%s\n\n", Line.c_str());
			
			SymbolInfo* Rel = new SymbolInfo(Line, "logic_expression");
			//The result of LOGICOP should be an integer
			Rel->SetVariableType("int");
			
			if($1->GetVariableType() == "void" || $3->GetVariableType() == "void"){
				printErr("Void Value Not Ignored As It Ought To Be\n\n", line_count);
			}
			else{
				int Value;
				
				if($1->GetVariableType() == "int" && $3->GetVariableType() == "int"){
					int First = $1->IValue;
					int Second = $3->IValue;
					
					if($2->GetSymbolName() == "&&") {Value = First && Second;}
					else if($2->GetSymbolName() == "||") {Value = First || Second;}
				}
				else if($1->GetVariableType() == "int" && $3->GetVariableType() == "float"){
					int First = $1->IValue;
					float Second = $3->FValue;
					
					if($2->GetSymbolName() == "&&") {Value = First && Second;}
					else if($2->GetSymbolName() == "||") {Value = First || Second;}
				}
				else if($1->GetVariableType() == "float" && $3->GetVariableType() == "int"){
					float First = $1->FValue;
					int Second = $3->IValue;
					
					if($2->GetSymbolName() == "&&") {Value = First && Second;}
					else if($2->GetSymbolName() == "||") {Value = First || Second;}
				}
				else if($1->GetVariableType() == "float" && $3->GetVariableType() == "float"){
					float First = $1->FValue;
					float Second = $3->FValue;
					
					if($2->GetSymbolName() == "&&") {Value = First && Second;}
					else if($2->GetSymbolName() == "||") {Value = First || Second;}
				}
				
				Rel->IValue = Value;
			}
			
			string Falmse = NewLabel();
			string DoneLabel = NewLabel();
			string Temp = NewTemp();
			string code = $1->GetCode() + $3->GetCode();
			code += "    ;" + $1->GetAssemblySymbol() + $2->GetSymbolName() + $3->GetAssemblySymbol() + "\n";
			//code += "    MOV AX, " + $1->GetAssemblySymbol() + "\n";
			if($1->GetIdentity() == "AccessArray"){
				code += "    LEA SI, " + $1->GetAssemblySymbol() + "\n";
				code += "    ADD SI, " + to_string($1->GetArrayAccessVariable()) + "*2\n";
				code += "    MOV AX, [SI]\n\n";
			}
			else{
				code += "    MOV AX, " + $1->GetAssemblySymbol() + "\n";
			}
			//code += "    MOV DX, " + $3->GetAssemblySymbol() + "\n";
			if($3->GetIdentity() == "AccessArray"){
				code += "    LEA SI, " + $3->GetAssemblySymbol() + "\n";
				code += "    ADD SI, " + to_string($3->GetArrayAccessVariable()) + "*2\n";
				code += "    MOV DX, [SI]\n\n";
			}
			else{
				code += "    MOV DX, " + $3->GetAssemblySymbol() + "\n";
			}
			
			if($2->GetSymbolName() == "&&"){
				code += "    CMP AX, 0\n";
				code += "    JE " + Falmse + "\n";
				code += "    CMP DX, 0\n";
				code += "    JE " + Falmse + "\n";
				code += "    MOV AX, 1\n";
				code += "    JMP " + DoneLabel + "\n";
				code += Falmse + ":\n";
				code += "    MOV AX, 0\n";
			}
			else{
				code += "    CMP AX, 0\n";
				code += "    JNE " + Falmse + "\n";
				code += "    CMP DX, 0\n";
				code += "    JNE " + Falmse + "\n";
				code += "    MOV AX, 0\n";
				code += "    JMP " + DoneLabel + "\n";
				code += Falmse + ":\n";
				code += "    MOV AX, 1\n";
			}
			code += DoneLabel + ":\n";
			code += "    MOV " + Temp + ", AX\n\n";
			
			$$ = Rel;
			$$->RetVal = $1->RetVal || $3->RetVal;
			if(!ReturnCalled){
				$$->SetCode(code);
			}
			$$->SetAssemblySymbol(Temp);
			$$->SetIdentity("Special");
		}	
		;
			
rel_expression	: simple_expression 
		{
			fprintf(Log, "Line no. %d: rel_expression : simple_expression\n\n", line_count);
			fprintf(Log, "%s\n\n", $1->GetSymbolName().c_str());
			$$ = $1;
			$$->SetSymbolType("rel_expression");
		}
		| simple_expression RELOP simple_expression	
		{
			fprintf(Log, "Line no. %d: rel_expression : simple_expression RELOP simple_expression\n\n", line_count);
			string Line = $1->GetSymbolName() + $2->GetSymbolName() + $3->GetSymbolName();
			fprintf(Log, "%s\n\n", Line.c_str());
			
			SymbolInfo* Rel = new SymbolInfo(Line, "rel_expression");
			//The result of RELOP should be an integer
			Rel->SetVariableType("int");
			
			if($1->GetVariableType() == "void" || $3->GetVariableType() == "void"){
				printErr("Void Value Not Ignored As It Ought To Be\n\n", line_count);
			}
			else{
				int Value;
				if($1->GetVariableType() == "int" && $3->GetVariableType() == "int"){
					int First = $1->IValue;
					int Second = $3->IValue;
					
					if($2->GetSymbolName() == ">") {Value = First > Second;}
					else if($2->GetSymbolName() == "<") {Value = First < Second;}
					else if($2->GetSymbolName() == ">=") {Value = First >= Second;}
					else if($2->GetSymbolName() == "<=") {Value = First <= Second;}
					else if($2->GetSymbolName() == "==") {Value = First == Second;}
					else if($2->GetSymbolName() == "!=") {Value = First != Second;}
				}
				else if($1->GetVariableType() == "int" && $3->GetVariableType() == "float"){
					int First = $1->IValue;
					float Second = $3->FValue;
				
					if($2->GetSymbolName() == ">") {Value = First > Second;}
					else if($2->GetSymbolName() == "<") {Value = First < Second;}
					else if($2->GetSymbolName() == ">=") {Value = First >= Second;}
					else if($2->GetSymbolName() == "<=") {Value = First <= Second;}
					else if($2->GetSymbolName() == "==") {Value = First == Second;}
					else if($2->GetSymbolName() == "!=") {Value = First != Second;}
				}
				else if($1->GetVariableType() == "float" && $3->GetVariableType() == "int"){
					float First = $1->FValue;
					int Second = $3->IValue;
				
					if($2->GetSymbolName() == ">") {Value = First > Second;}
					else if($2->GetSymbolName() == "<") {Value = First < Second;}
					else if($2->GetSymbolName() == ">=") {Value = First >= Second;}
					else if($2->GetSymbolName() == "<=") {Value = First <= Second;}
					else if($2->GetSymbolName() == "==") {Value = First == Second;}
					else if($2->GetSymbolName() == "!=") {Value = First != Second;}
				}
				else if($1->GetVariableType() == "float" && $3->GetVariableType() == "float"){
					float First = $1->FValue;
					float Second = $3->FValue;
				
					if($2->GetSymbolName() == ">") {Value = First > Second;}
					else if($2->GetSymbolName() == "<") {Value = First < Second;}
					else if($2->GetSymbolName() == ">=") {Value = First >= Second;}
					else if($2->GetSymbolName() == "<=") {Value = First <= Second;}
					else if($2->GetSymbolName() == "==") {Value = First == Second;}
					else if($2->GetSymbolName() == "!=") {Value = First != Second;}
				}
				Rel->IValue = Value;
			}
			
			string code = $1->GetCode() + $3->GetCode();
			code += "    ;" + $1->GetAssemblySymbol() + $2->GetSymbolName() + $3->GetAssemblySymbol() + "\n";
			string Temp = NewTemp();
			string CodeLabel = NewLabel();
			string DoneLabel = NewLabel();
			//code += "    MOV AX, " + $1->GetAssemblySymbol() + "\n";
			if($1->GetIdentity() == "AccessArray"){
				code += "    LEA SI, " + $1->GetAssemblySymbol() + "\n";
				code += "    ADD SI, " + to_string($1->GetArrayAccessVariable()) + "*2\n";
				code += "    MOV AX, [SI]\n\n";
			}
			else{
				code += "    MOV AX, " + $1->GetAssemblySymbol() + "\n";
			}
			
			if($3->GetIdentity() == "AccessArray"){
				code += "    LEA SI, " + $3->GetAssemblySymbol() + "\n";
				code += "    ADD SI, " + to_string($3->GetArrayAccessVariable()) + "*2\n";
				code += "    MOV DX, [SI]\n\n";
			}
			else{
				code += "    MOV DX, " + $3->GetAssemblySymbol() + "\n";
			}
			
			code += "    CMP AX, DX\n";
			
			if($2->GetSymbolName() == ">") {
				code += "    JG " + CodeLabel + "\n";
				code += "    MOV AX, 0\n";
				code += "    JMP " + DoneLabel + "\n";
				code += CodeLabel + ":\n"; 
				code += "    MOV AX, 1\n";
				code += DoneLabel + ":\n";
				code += "    MOV " + Temp + ", AX\n\n";
			}
			else if($2->GetSymbolName() == "<") {
				code += "    JL " + CodeLabel + "\n";
				code += "    MOV AX, 0\n";
				code += "    JMP " + DoneLabel + "\n";
				code += CodeLabel + ":\n"; 
				code += "    MOV AX, 1\n";
				code += DoneLabel + ":\n";
				code += "    MOV " + Temp + ", AX\n\n";
			}
			else if($2->GetSymbolName() == ">=") {
				code += "    JGE " + CodeLabel + "\n";
				code += "    MOV AX, 0\n";
				code += "    JMP " + DoneLabel + "\n";
				code += CodeLabel + ":\n"; 
				code += "    MOV AX, 1\n";
				code += DoneLabel + ":\n";
				code += "    MOV " + Temp + ", AX\n\n";
			}
			else if($2->GetSymbolName() == "<=") {
				code += "    JLE " + CodeLabel + "\n";
				code += "    MOV AX, 0\n";
				code += "    JMP " + DoneLabel + "\n";
				code += CodeLabel + ":\n"; 
				code += "    MOV AX, 1\n";
				code += DoneLabel + ":\n";
				code += "    MOV " + Temp + ", AX\n\n";
			}
			else if($2->GetSymbolName() == "==") {
				code += "    JE " + CodeLabel + "\n";
				code += "    MOV AX, 0\n";
				code += "    JMP " + DoneLabel + "\n";
				code += CodeLabel + ":\n"; 
				code += "    MOV AX, 1\n";
				code += DoneLabel + ":\n";
				code += "    MOV " + Temp + ", AX\n\n";
			}
			else if($2->GetSymbolName() == "!=") {
				code += "    JNE " + CodeLabel + "\n";
				code += "    MOV AX, 0\n";
				code += "    JMP " + DoneLabel + "\n";
				code += CodeLabel + ":\n"; 
				code += "    MOV AX, 1\n";
				code += DoneLabel + ":\n";
				code += "    MOV " + Temp + ", AX\n\n";
			}
			
			$$ = Rel;
			$$->RetVal = $1->RetVal || $3->RetVal;
			if(!ReturnCalled){
				$$->SetCode(code);
			}
			$$->SetAssemblySymbol(Temp);
			$$->SetIdentity("Special");
		}
		;
				
simple_expression : term 
		{
			fprintf(Log, "Line no. %d: simple_expression : term\n\n", line_count);
			fprintf(Log, "%s\n\n", $1->GetSymbolName().c_str());
			// $$ = $1;
			$$->SetSymbolType("simple_expression");
		}
		| simple_expression ADDOP term 
		{
			fprintf(Log, "Line no. %d: simple_expression : simple_expression ADDOP term\n\n", line_count);
			string Line = $1->GetSymbolName() + $2->GetSymbolName() + $3->GetSymbolName();
			fprintf(Log, "%s\n\n", Line.c_str());
			SymbolInfo* Simp = new SymbolInfo(Line, "simple_expression");
			if($1->GetVariableType() == "float" || $3->GetVariableType() == "float"){
				Simp->SetVariableType("float");
				float First = $1->GetVariableType() == "float"?$1->FValue:$1->IValue;
				float Second = $3->GetVariableType() == "float"?$3->FValue:$3->IValue;
				if($2->GetSymbolName() == "+"){
					Simp->FValue = First + Second;
				}
				else if($2->GetSymbolName() == "-"){
					Simp->FValue = First - Second;
				}
			}
			else if($1->GetVariableType() == "void" || $3->GetVariableType() == "void"){
				printErr("Void Value Not Ignored As It Ought To Be\n\n", line_count);
				Simp->SetVariableType("error");
			}
			else if($1->GetVariableType() == "error"){
				Simp->SetVariableType($3->GetVariableType());
			}
			else if($3->GetVariableType() == "error"){
				Simp->SetVariableType($1->GetVariableType());
			}
			else{
				Simp->SetVariableType("int");
				int First = $1->IValue;
				int Second = $3->IValue;
				if($2->GetSymbolName() == "+"){
					Simp->FValue = First + Second;
				}
				else if($2->GetSymbolName() == "-"){
					Simp->FValue = First - Second;
				}
			}
			$$ = Simp;
			$$->RetVal = $1->RetVal || $3->RetVal;
			
			string code = $1->GetCode() + $3->GetCode();
			code += "    ;" + $1->GetAssemblySymbol() + $2->GetSymbolName() + $3->GetAssemblySymbol() + "\n";
			string Temp = NewTemp();
			if($2->GetSymbolName() == "+"){
				if($3->GetIdentity() == "AccessArray"){
					code += "    LEA SI, " + $3->GetAssemblySymbol() + "\n";
					code += "    ADD SI, " + to_string($3->GetArrayAccessVariable()) + "*2\n";
					code += "    MOV AX, [SI]\n\n";
				}
				else{
					code += "    MOV AX, " + $3->GetAssemblySymbol() + "\n";
				}
				if($1->GetIdentity() == "AccessArray"){
					code += "    LEA SI, " + $1->GetAssemblySymbol() + "\n";
					code += "    ADD SI, " + to_string($1->GetArrayAccessVariable()) + "*2\n";
					code += "    MOV DX, [SI]\n\n";
				}
				else{
					code += "    MOV DX, " + $1->GetAssemblySymbol() + "\n";
				}
				code += "    ADD AX, DX\n";
				code += "    MOV " + Temp + ", AX\n\n";
			}
			else{
				if($1->GetIdentity() == "AccessArray"){
					code += "    LEA SI, " + $1->GetAssemblySymbol() + "\n";
					code += "    ADD SI, " + to_string($1->GetArrayAccessVariable()) + "*2\n";
					code += "    MOV AX, [SI]\n\n";
				}
				else{
					code += "    MOV AX, " + $1->GetAssemblySymbol() + "\n";
				}
				if($3->GetIdentity() == "AccessArray"){
					code += "    LEA SI, " + $3->GetAssemblySymbol() + "\n";
					code += "    ADD SI, " + to_string($3->GetArrayAccessVariable()) + "*2\n";
					code += "    MOV DX, [SI]\n\n";
				}
				else{
					code += "    MOV DX, " + $3->GetAssemblySymbol() + "\n";
				}
				code += "    SUB AX, DX\n";
				code += "    MOV " + Temp + ", AX\n\n";
			}
			if(!ReturnCalled){
				$$->SetCode(code);
			}
			$$->SetAssemblySymbol(Temp);
			$$->SetIdentity("Special");
		}
		;
					
term :	unary_expression
		{
			fprintf(Log, "Line no. %d: term : unary_expression\n\n", line_count);
			fprintf(Log, "%s\n\n", $1->GetSymbolName().c_str());
			//$$ = $1;
			$$->SetSymbolType("term");
		}
     	|  term MULOP unary_expression
		{
			fprintf(Log, "Line no. %d: term : unary_expression\n\n", line_count);
			string Line = $1->GetSymbolName() + $2->GetSymbolName() + $3->GetSymbolName();
			fprintf(Log, "%s\n\n", Line.c_str());
			
			SymbolInfo* Sym = new SymbolInfo(Line, "term");
			Sym->RetVal = $3->RetVal || $1->RetVal;
			string code = $1->GetCode() + $3->GetCode();
			string Temp = NewTemp();
			
			// MULOP has the operator %. It only works on two integers on C and C++
			if($2->GetSymbolName() == "%"){
				Sym->SetVariableType("int");
				if($1->GetVariableType() != "int" || $3->GetVariableType() != "int"){
					printErr("Invalid Operands To Binary (Have \'"+$1->GetVariableType()+"\' and \'"+$3->GetVariableType()+"\')\n\n",line_count);
				}else{
					if($3->GetIdentity() == "Variable"){
						int Op = $3->IValue;
						if(Op==0 && !$3->RetVal){
							printErr("Modulus By Zero\n\n", line_count);
						}
					}
					else if($3->GetIdentity() == "AccessArray"){
						// Should Check
					}
					else{
						int Op = atoi($3->GetSymbolName().c_str());
						if(Op == 0 && !$3->RetVal){
							printErr("Modulus By Zero\n\n", line_count);
						}
					}
				}
				code += "    ;" + $1->GetAssemblySymbol() + $2->GetSymbolName() + $3->GetAssemblySymbol() + "\n";
				code += "    MOV DX, 0\n";
				if($1->GetIdentity() == "AccessArray"){
					code += "    LEA SI, " + $1->GetAssemblySymbol() + "\n";
					code += "    ADD SI, " + to_string($1->GetArrayAccessVariable()) + "*2\n";
					code += "    MOV AX, [SI]\n\n";
				}
				else{
					code += "    MOV AX, " + $1->GetAssemblySymbol() + "\n";
				}
				code += "    CWD\n";
				if($3->GetIdentity() == "AccessArray"){
					code += "    LEA SI, " + $3->GetAssemblySymbol() + "\n";
					code += "    ADD SI, " + to_string($3->GetArrayAccessVariable()) + "*2\n";
					code += "    MOV CX, [SI]\n\n";
				}
				else{
					code += "    MOV CX, " + $3->GetAssemblySymbol() + "\n";
				}
				code += "    IDIV CX\n";
				code += "    MOV " + Temp + ", DX\n\n";
			}else{
				// If any one of the operands is float, the result is a float
				if($1->GetVariableType() == "float" || $3->GetVariableType() == "float"){
					Sym->SetVariableType("float");
					float First = $1->GetVariableType() == "float"?$1->FValue:$1->IValue;
					float Second = $3->GetVariableType() == "float"?$3->FValue:$3->IValue;
					if($2->GetSymbolName() == "*"){
						if($1->RetVal || $3->RetVal){}
						else Sym->FValue = First * Second;
					}
					else if($2->GetSymbolName() == "/"){
						if(Second == 0 && !$3->RetVal){
							printErr("Division By Zero\n\n", line_count);
						}
						else{
							if($1->RetVal || $3->RetVal){
							}
							else{
								Sym->FValue = First / Second;
							}
						}
					}
				}
				// No void operations allowed
				else if($1->GetVariableType() == "void" || $3->GetVariableType() == "void"){
					printErr("Void Value Not Ignored As It Ought To Be\n\n", line_count);
					Sym->SetVariableType("error");
				}
				else if($1->GetVariableType() == "error"){
					Sym->SetVariableType($3->GetVariableType());
				}
				else if($3->GetVariableType() == "error"){
					Sym->SetVariableType($1->GetVariableType());
				}
				else{
					//printf("%s %s\n", $1->GetSymbolName().c_str(), $3->GetSymbolName().c_str());
					Sym->SetVariableType("int");
					
					int First = $1->IValue;
					int Second = $3->IValue;
					//printf("%d %d\n", First, Second);
					if($2->GetSymbolName() == "*"){
						if($1->RetVal || $3->RetVal){}
						else Sym->IValue = First * Second;
					}
					else if($2->GetSymbolName() == "/"){
						if(Second == 0  && !$3->RetVal){
							fprintf(error_out, "Error at Line %d: Division By Zero\n\n", line_count);
							fprintf(Log, "Error at Line %d: Division By Zero\n\n", line_count);
							errCounter++;
						}
						else{
							if($1->RetVal || $3->RetVal){
							}
							else{
								Sym->IValue = First / Second;
							}
						}
					}
				}
				
				if($2->GetSymbolName() == "/"){
					code += "    ;" + $1->GetAssemblySymbol() + $2->GetSymbolName() + $3->GetAssemblySymbol() + "\n";
					code += "    MOV DX, 0\n";
					if($1->GetIdentity() == "AccessArray"){
						code += "    LEA SI, " + $1->GetAssemblySymbol() + "\n";
						code += "    ADD SI, " + to_string($1->GetArrayAccessVariable()) + "*2\n";
						code += "    MOV AX, [SI]\n\n";
					}
					else{
						code += "    MOV AX, " + $1->GetAssemblySymbol() + "\n";
					}
					code += "    CWD\n";
					if($3->GetIdentity() == "AccessArray"){
						code += "    LEA SI, " + $3->GetAssemblySymbol() + "\n";
						code += "    ADD SI, " + to_string($3->GetArrayAccessVariable()) + "*2\n";
						code += "    MOV CX, [SI]\n\n";
					}
					else{
						code += "    MOV CX, " + $3->GetAssemblySymbol() + "\n";
					}
					code += "    IDIV CX\n";
					code += "    MOV " + Temp + ", AX\n\n";
				}
				else{
					code += "    ;" + $1->GetAssemblySymbol() + $2->GetSymbolName() + $3->GetAssemblySymbol() + "\n";
					if($1->GetIdentity() == "AccessArray"){
						code += "    LEA SI, " + $1->GetAssemblySymbol() + "\n";
						code += "    ADD SI, " + to_string($1->GetArrayAccessVariable()) + "*2\n";
						code += "    MOV AX, [SI]\n\n";
					}
					else{
						code += "    MOV AX, " + $1->GetAssemblySymbol() + "\n";
					}
					if($3->GetIdentity() == "AccessArray"){
						code += "    LEA SI, " + $3->GetAssemblySymbol() + "\n";
						code += "    ADD SI, " + to_string($3->GetArrayAccessVariable()) + "*2\n";
						code += "    MOV DX, [SI]\n\n";
					}
					else{
						code += "    MOV DX, " + $3->GetAssemblySymbol() + "\n";
					}
					code += "    IMUL DX\n";
					code += "    MOV " + Temp + ", AX\n\n";
				}
			}
			$$ = Sym;
			$$->SetIdentity("Special");
			if(!ReturnCalled){
				$$->SetCode(code);
			}
			$$->SetAssemblySymbol(Temp);
		}
     	;

unary_expression : ADDOP unary_expression
		{
			fprintf(Log, "Line no. %d: unary_expression : ADDOP unary_expression\n\n", line_count);
			string Expr = $1->GetSymbolName() + $2->GetSymbolName();
			fprintf(Log, "%s\n\n", Expr.c_str());
			
			$$ = $2;
			$$->SetSymbolName(Expr);
			$$->SetSymbolType("unary_expression");
			
			string code = $2->GetCode();
			
			if($1->GetSymbolName() == "+"){
				$$->SetAssemblySymbol($2->GetAssemblySymbol());
				$$->SetIdentity($2->GetIdentity());
			}
			else if($1->GetSymbolName() == "-"){
				$$->IValue = -$$->IValue;
				$$->FValue = -$$->FValue;
				
				string Temp = NewTemp();
				code += "    ;" + Temp + " = " + Expr + "\n";
				if($2->GetIdentity() == "AccessArray"){
					code += "    LEA SI, " + $2->GetAssemblySymbol() + "\n";
					code += "    ADD SI, " + to_string($2->GetArrayAccessVariable()) + "*2\n";
					code += "    MOV AX, [SI]\n\n";
				}
				else{
					code += "    MOV AX, " + $2->GetAssemblySymbol() + "\n";
				}
				code += "    MOV " + Temp + ", AX\n";
				code += "    NEG " + Temp + "\n\n";
				
				$$->SetAssemblySymbol(Temp);
				$$->SetIdentity("Special");
			}
			if(!ReturnCalled){
				$$->SetCode(code);
			}
		}
		| NOT unary_expression 
		{
			fprintf(Log, "Line no. %d: unary_expression : NOT unary_expression\n\n", line_count);
			string Expr = "!" + $2->GetSymbolName();
			fprintf(Log, "%s\n\n", Expr.c_str());
			
			SymbolInfo* Exp = new SymbolInfo(Expr, "unary_expression");
			Exp->SetVariableType("int");
			Exp->RetVal = $2->RetVal;
			$$ = Exp;
			if($2->GetVariableType() == "int"){
				$$->IValue = !$2->IValue;
			}
			else if($2->GetVariableType() == "float"){
				$$->IValue = !$2->FValue;
			}
			
			string code = $2->GetCode();
			string ZeroLabel = NewLabel();
			string DoneLabel = NewLabel();
			string Temp = NewTemp();
			
			code += "    ;!" + $2->GetAssemblySymbol() + "\n";
			if($2->GetIdentity() == "AccessArray"){
				code += "    LEA SI, " + $2->GetAssemblySymbol() + "\n";
				code += "    ADD SI, " + to_string($2->GetArrayAccessVariable()) + "*2\n";
				code += "    MOV AX, [SI]\n\n";
			}
			else{
				code += "    MOV AX, " + $2->GetAssemblySymbol() + "\n";
			}
			code += "    CMP AX , 0\n";
			code += "    JZ " + ZeroLabel + "\n";
			code += "    MOV AX, 0\n";
			code += "    MOV " + Temp + ", AX\n";
			code += "    JMP " + DoneLabel + "\n\n";
			
			code += ZeroLabel + ":\n";
			code += "    MOV AX, 1\n";
			code += "    MOV " + Temp + ", AX\n\n";
			
			code += DoneLabel + ":\n";
			
			if(!ReturnCalled){
				$$->SetCode(code);
			}
			$$->SetAssemblySymbol(Temp);
			$$->SetIdentity("Special");
		} 
		| factor 
		{
			fprintf(Log, "Line no. %d: unary_expression : factor\n\n", line_count);
			fprintf(Log, "%s\n\n", $1->GetSymbolName().c_str());
			$$ = $1;
			$$->SetSymbolType("unary_expression");
		}
		;
	
factor	: variable
		{
			fprintf(Log, "Line no. %d: factor : variable\n\n", line_count);
			string Line = $1->GetSymbolName();
			string Line2 = Line;
			if($1->GetIdentity() == "AccessArray"){
				Line+= "[" + to_string($1->GetArrayAccessVariable()) + "]";
			}
			fprintf(Log, "%s\n\n", Line.c_str());
			SymbolInfo* Fac = new SymbolInfo(Line2, "factor");
			
			Fac->SetVariableType($1->GetVariableType());
			Fac->SetIdentity($1->GetIdentity());
			Fac->SetArrayAccessVariable($1->GetArrayAccessVariable());
			if($1->GlobalVar){
				Fac->SetAssemblySymbol($1->GetSymbolName() + "1");
			}else{
				Fac->SetAssemblySymbol($1->GetSymbolName() + table->GetCurrentScopeID());
			}
			Fac->GlobalVar = $1->GlobalVar;
			
			////printf("Factor: %s %d\n", $1->GetSymbolName().c_str(), Fac->GetArrayAccessVariable());
			
			if(Fac->GetVariableType() == "int"){
				Fac->IValue = $1->IValue;
			}
			else if(Fac->GetVariableType() == "float"){
				Fac->FValue = $1->FValue;
			}
			Fac->RetVal = $1->RetVal;
			$$ = Fac;
		} 
		| ID LPAREN argument_list RPAREN
		{
			fprintf(Log, "Line no. %d: factor : ID LPAREN argument_list RPAREN\n\n", line_count);
			
			string Line = $1->GetSymbolName() + "(";
			for(int Counter = 0; Counter < $3->ParamList.size(); Counter++){
				Line += $3->ParamList[Counter]->GetSymbolName();
				if(Counter != $3->ParamList.size() - 1){
					Line += ", ";
				}
			}
			Line += ")";
			fprintf(Log, "%s\n\n", Line.c_str());
			
			SymbolInfo* Func = new SymbolInfo(Line, "factor");
			$$ = Func;
			string code = "";
			code += "    ;" + Line + "\n";
			code += "    PUSH ADDRESS\n";
			// Foo(a,b,c) -> Check for function call
			SymbolInfo* Fun = table->LookUp($1->GetSymbolName());
			
			if(Fun){
				// Function found, so the factor type should be the the type which the function returns
				$$->SetVariableType(Fun->GetReturnType());
				$$->RetVal = true;
			}else{
				// Function not found
				$$->SetVariableType("error");
				printErr("Undeclared Function \'"+$1->GetSymbolName()+"\'\n\n", line_count);
			}
			
			// Function not defined, or the name does not belong to a function
			if(Fun && (Fun->GetIdentity() != "function_definition" && Fun->GetIdentity() != "func_declaration")){
				printErr("Undefined Reference to Function \'"+$1->GetSymbolName()+"\'\n\n", line_count);
				$$->SetVariableType("error");
			}
			// Argument counts do not match
			else if(Fun && Fun->ParamList.size() > $3->ParamList.size()){
				printErr("Too Few Arguments to Function \'"+$1->GetSymbolName()+"\'\n\n", line_count);
				$$->SetVariableType("error");
			}
			else if(Fun && Fun->ParamList.size() < $3->ParamList.size()){
				printErr("Too Many Arguments to Function \'"+$1->GetSymbolName()+"\'\n\n", line_count);
				$$->SetVariableType("error");
			}
			// Function defined, argument counts match
			else if(Fun){
				////printf("%s %d\n", Fun->GetSymbolName().c_str(), $3->ParamList.size());
				// Arguments can be both variables or Values
				for(int Counter = 0; Counter < $3->ParamList.size(); Counter++){
					SymbolInfo* Temp = table->LookUp($3->ParamList[Counter]->GetSymbolName());
					// In case its a declared variable
					if(Temp){
						// Variable types did not match
						if(Temp->GetVariableType() != Fun->ParamList[Counter]->GetVariableType() || Temp->GetVariableSize() != Fun->ParamList[Counter]->GetVariableSize()){
							if(Fun->ParamList[Counter]->GetVariableType() == "float" && Temp->GetVariableType() == "int" && Temp->GetVariableSize() == Fun->ParamList[Counter]->GetVariableSize()){
								code += "    MOV AX, " + $3->ParamList[Counter]->GetSymbolName() + table->GetCurrentScopeID() + "\n";
								code += "    MOV " + Fun->ParamList[Counter]->GetSymbolName() + Fun->GetImplementationID() + ", AX\n";
							}
							else{
								printErr("Incompatible Type for Argument"+to_string(Counter + 1)+"of \'"+$1->GetSymbolName()+"\'\n\n", line_count);
								$$->SetVariableType("error");
								break;
							}
						}
						else{
							code += "    PUSH " + $3->ParamList[Counter]->GetSymbolName() + table->GetCurrentScopeID() + "\n";
						}
					}
					
					// In Case its a value, not a variable. In this case, as defined, it will have no special identity, unlike defined variables, who have "Variable" identity
					// If the identity is "Variable", that means the variable is not declared, since it is not in the smbl Table
					else if($3->ParamList[Counter]->GetIdentity() == "Variable"){
						if($3->ParamList[Counter]->GetVariableType() == "error"){}
						else{
							printErr("\'"+$3->ParamList[Counter]->GetSymbolName()+"\' Undeclared\n\n", line_count);
							$$->SetVariableType("error");
							break;
						}
					}
					else if($3->ParamList[Counter]->GetVariableType() != Fun->ParamList[Counter]->GetVariableType()){
						if(Fun->ParamList[Counter]->GetVariableType() == "float" && $3->ParamList[Counter]->GetVariableType() == "int"){
							code += "    PUSH" + $3->ParamList[Counter]->GetSymbolName() + "\n";
						}
						else{
							printErr("Incompatible Type for Argument" +to_string(Counter+1)+ "of \'"+$1->GetSymbolName()+"\'\n\n",line_count);
							$$->SetVariableType("error");
							break;
						}
					}
					else{
						//code += "    MOV " + Fun->ParamList[Counter]->GetSymbolName() + Fun->GetImplementationID() + ", " + $3->ParamList[Counter]->GetSymbolName() + "\n";
						code += "    PUSH " + $3->ParamList[Counter]->GetSymbolName() + "\n";
					}
				}
				code += "    CALL " + $1->GetSymbolName() + "\n\n";
				if(Fun->GetReturnType() != "void"){
					code += "    ;Restore Address & Store The Return Value\n";
					string Temp = NewTemp();
					code += "    POP " + Temp + "\n";
					code += "    POP ADDRESS\n\n";
					$$->SetAssemblySymbol(Temp);
					$$->SetIdentity("Special");
				}
			}
			if(!ReturnCalled){
				$$->SetCode(code);
			}
			$3->ParamList.clear();
		}
		| LPAREN expression RPAREN
		{
			fprintf(Log, "Line no. %d: factor : LPAREN expression RPAREN\n\n", line_count);
			
			string Line = "(" + $2->GetSymbolName() + ")";
			fprintf(Log, "%s\n\n", Line.c_str());
			
			SymbolInfo* Exp = new SymbolInfo(Line, "factor");
			// The new type after operation will remain the same as the old type
			Exp->SetVariableType($2->GetVariableType());
			if($2->GetVariableType() == "int"){
				Exp->IValue = $2->IValue;
			}
			else if($2->GetVariableType() == "float"){
				Exp->FValue = $2->FValue;
			}
			$$ = Exp;
			$$->SetCode($2->GetCode());
			$$->SetAssemblySymbol($$->GetSymbolName());
			$$->RetVal = $2->RetVal;
		}
		| CONST_INT 
		{
			fprintf(Log, "Line no. %d: factor : CONST_INT\n\n", line_count);
			fprintf(Log, "%s\n\n", $1->GetSymbolName().c_str());
			$$ = $1;
			$$->SetVariableType("int");
			$$->SetSymbolType("factor");
			$$->IValue = atoi($1->GetSymbolName().c_str());
			$$->SetAssemblySymbol($1->GetSymbolName());
		}
		| CONST_FLOAT
		{
			fprintf(Log, "Line no. %d: factor : CONST_FLOAT\n\n", line_count);
			fprintf(Log, "%s\n\n", $1->GetSymbolName().c_str());
			$$ = $1;
			$$->SetVariableType("float");
			$$->SetSymbolType("factor");
			$$->FValue = atof($1->GetSymbolName().c_str());
			$$->SetAssemblySymbol($1->GetSymbolName());
		}
		| variable INCOP 
		{
			fprintf(Log, "Line no. %d: factor : variable INCOP\n\n", line_count);
			string Line = $1->GetSymbolName();
			if($1->GetIdentity() == "AccessArray"){
				Line+= "[" + to_string($1->GetArrayAccessVariable()) + "]";
			}
			Line += "++";
			fprintf(Log, "%s\n\n", Line.c_str());
			
			SymbolInfo* Inc = new SymbolInfo($1->GetSymbolName(), "factor");
			Inc->SetVariableType($1->GetVariableType());
			$$ = Inc;
			
			SymbolInfo* Temp = table->LookUp($1->GetSymbolName());
			string code = "";
			if(Temp){
				string TempVar = NewTemp();
				if(Temp->GetVariableType() == "int"){
					if($1->GetIdentity() == "AccessArray"){
						$$->IValue = Temp->IntValue[$1->GetArrayAccessVariable()];
						Temp->IntValue[$1->GetArrayAccessVariable()]++;
						
						code += "    ;Variable INCOP\n";
						code += "    LEA SI, " + $1->GetSymbolName() + table->GetCurrentScopeID() + "\n";
						code += "    ADD SI, " + to_string($1->GetArrayAccessVariable()) + "*2\n";
						code += "    MOV AX, [SI]\n";
						code += "    MOV " + TempVar + ", AX\n";
						code += "    INC [SI]\n\n";
					}
					else if($1->GetIdentity() == "Variable"){
						$$->IValue = Temp->IValue;
						Temp->IValue++;
						
						code += "    ;Variable INCOP\n";
						code += "    MOV AX, " + $1->GetSymbolName() + table->GetCurrentScopeID() + "\n";
						code += "    MOV " + TempVar + ", AX\n";
						code += "    INC " + $1->GetSymbolName() + table->GetCurrentScopeID() + "\n\n";
					}
				}
				else if(Temp->GetVariableType() == "float"){
					if($1->GetIdentity() == "AccessArray"){
						$$->FValue = Temp->FloatValue[$1->GetArrayAccessVariable()];
						Temp->FloatValue[$1->GetArrayAccessVariable()]++;
					}
					else if($1->GetIdentity() == "Variable"){
						$$->FValue = Temp->FValue;
						Temp->FValue++;
					}
				}
				$$->SetIdentity("Special");
				if(!ReturnCalled){
					$$->SetCode(code);
				}
				$$->SetAssemblySymbol(TempVar);
			}
		}
		| variable DECOP
		{
			fprintf(Log, "Line no. %d: factor : variable DECOP\n\n", line_count);
			string Line = $1->GetSymbolName();
			if($1->GetIdentity() == "AccessArray"){
				Line+= "[" + to_string($1->GetArrayAccessVariable()) + "]";
			}
			Line += "--";
			fprintf(Log, "%s\n\n", Line.c_str());
			
			SymbolInfo* Dec = new SymbolInfo($1->GetSymbolName(), "factor");
			// The new type after operation will remain the same as the old type
			Dec->SetVariableType($1->GetVariableType());
			$$ = Dec;
			
			SymbolInfo* Temp = table->LookUp($1->GetSymbolName());
			string code = "";
			if(Temp){
				string TempVar = NewTemp();
				
				if(Temp->GetVariableType() == "int"){
					if($1->GetIdentity() == "AccessArray"){
						$$->IValue = Temp->IntValue[$1->GetArrayAccessVariable()];
						Temp->IntValue[$1->GetArrayAccessVariable()]--;
						
						code += "    ;Variable DECOP\n";
						code += "    LEA SI, " + $1->GetSymbolName() + table->GetCurrentScopeID() + "\n";
						code += "    ADD SI, " + to_string($1->GetArrayAccessVariable()) + "*2\n";
						code += "    MOV AX, [SI]\n";
						code += "    MOV " + TempVar + ", AX\n";
						code += "    DEC [SI]\n\n";
					}
					else if($1->GetIdentity() == "Variable"){
						$$->IValue = Temp->IValue;
						Temp->IValue--;
						
						code += "    ;Variable DECOP\n";
						code += "    MOV AX, " + $1->GetSymbolName() + table->GetCurrentScopeID() + "\n";
						code += "    MOV " + TempVar + ", AX\n";
						code += "    DEC " + $1->GetSymbolName() + table->GetCurrentScopeID() + "\n\n";
					}
				}
				else if(Temp->GetVariableType() == "float"){
					if($1->GetIdentity() == "AccessArray"){
						$$->FValue = Temp->FloatValue[$1->GetArrayAccessVariable()];
						Temp->FloatValue[$1->GetArrayAccessVariable()]--;
					}
					else if($1->GetIdentity() == "Variable"){
						$$->FValue = Temp->FValue;
						Temp->FValue--;
					}
				}
				$$->SetIdentity("Special");
				if(!ReturnCalled){
					$$->SetCode(code);
				}
				$$->SetAssemblySymbol(TempVar);
			}
		}
		;
	
argument_list : arguments
		{
			fprintf(Log, "Line no. %d: argument_list : arguments\n\n", line_count);
			for(int Counter = 0; Counter < $1->ParamList.size(); Counter++){
				fprintf(Log, "%s", $1->ParamList[Counter]->GetSymbolName().c_str());
				if(Counter != $1->ParamList.size() - 1){
					fprintf(Log, ", ");
				}
			}
			fprintf(Log, "\n\n");
			$$->SetSymbolType("argument_list");
		}
		|
		{
			fprintf(Log, "Line no. %d: argument_list : \n\n", line_count);
			$$ = new SymbolInfo("", "argument_list");
		}
 	    ;
	
arguments : arguments COMMA logic_expression
		{
			fprintf(Log, "Line no. %d: arguments : arguments COMMA logic_expression\n\n", line_count);
			SymbolInfo* Arg = new SymbolInfo($3->GetSymbolName(), "arguments");
			Arg->SetVariableType($3->GetVariableType());
			Arg->SetIdentity($3->GetIdentity());
			Arg->IValue = $3->IValue;
			Arg->FValue = $3->FValue;
			$$ = $1;
			$$->ParamList.push_back(Arg);
			$$->SetCode($1->GetCode() + $3->GetCode());
			for(int Counter = 0; Counter < $1->ParamList.size(); Counter++){
				fprintf(Log, "%s", $1->ParamList[Counter]->GetSymbolName().c_str());
				if(Counter != $1->ParamList.size() - 1){
					fprintf(Log, ", ");
				}
			}
			fprintf(Log, "\n\n");
		}
	    | logic_expression
		{
			fprintf(Log, "Line no. %d: arguments : logic_expression\n\n", line_count);
			fprintf(Log, "%s\n\n", $1->GetSymbolName().c_str());
			
			SymbolInfo* Args = new SymbolInfo("ArgList");
			SymbolInfo* Arg = new SymbolInfo($1->GetSymbolName(), "arguments");
			Arg->SetVariableType($1->GetVariableType());
			Arg->SetIdentity($1->GetIdentity());
			Arg->IValue = $1->IValue;
			Arg->FValue = $1->FValue;
			Arg->SetCode($1->GetCode());
			Args->ParamList.push_back(Arg);
			$$ = Args;
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

	Log = fopen(argv[2], "w");
	error_out = fopen(argv[3], "w");
	Assembly = fopen(argv[4], "w");
	Optimized = fopen(argv[5], "w");
	fclose(Log);
	fclose(error_out);
	fclose(Assembly);
	fclose(Optimized);
		
	Log = fopen(argv[2], "w");
	error_out = fopen(argv[3], "w");
	Assembly = fopen(argv[4], "w");
	Optimized = fopen(argv[5], "w");
	

	yyparse();
	
	fprintf(Log, "smbl Table:\n\n");
	table->PrintAllScopes(Log);
	fprintf(Log, "\n\n");
	fprintf(Log, "Total Lines: %d\n\n", line_count-1);
	fprintf(Log, "Total Errors: %d\n\n", errCounter);
	fprintf(error_out, "\n\nTotal Errors: %d\n\n", errCounter);
	
	fclose(Log);
	fclose(error_out);
	fclose(Assembly);
	
	Assembly = fopen(argv[4], "r");
	
	if(errCounter == 0){
		optimizeCode();
	}
	
	fclose(Assembly);
	fclose(Optimized);
}

