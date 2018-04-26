/* Compiler Theory and Design
   Dr. Duane J. Jarc */

%{

#include <string>
#include <vector>
#include <map>

using namespace std;

#include "listing.h"
#include "types.h"
#include "symbols.h"

int yylex();
void yyerror(const char* message);

Symbols<Types> symbols;

%}

%error-verbose

%union
{
	CharPtr iden;
	Types type;
}

%token <iden> IDENTIFIER
%token <type> INT_LITERAL BOOLEAN_LITERAL REAL_LITERAL

%token ADDOP MULOP RELOP ANDOP REMOP EXPOP OROP NOTOP

%token BEGIN_ BOOLEAN END ENDREDUCE FUNCTION INTEGER IS REDUCE RETURNS
%token REAL IF THEN ELSE ENDIF CASE OTHERS ARROW ENDCASE WHEN
%token NOT

%type <type> type statement statement_ expression primary term1 term2 term3 term4 term5 term6


%%

function:
	function_header variables body ;

function_header:
	FUNCTION IDENTIFIER parameters RETURNS type ';' |
  error ';'
  ;

variables:
  variable_ variables |
  ;
variable_:
  variable |
  error ';';

variable:
	IDENTIFIER ':' type IS statement_
  {checkAssignment($3, $5, "Variable Initialization");
  symbols.insert($1,$3);} ;

parameters:
  |
  parameter |
  parameters parameter ;

parameter:
  IDENTIFIER ':' type;

type:
	INTEGER {$$= INT_TYPE;} |
  REAL {$$ = REAL_TYPE;} |
	BOOLEAN {$$ = BOOL_TYPE;} ;

body:
	BEGIN_ statement_ END ';' ;

statement_:
  statement ';' |
  error ';' {$$ = MISMATCH;};

statement:
	expression ';' |
  IF expression THEN statement ELSE statement ENDIF ';' {$$ = checkIfThen($3, $5);} |
  CASE expression IS cases OTHERS ARROW statement ';' ENDCASE ';' {$$=$2;}
   ;

cases:
  | cases case ;

case:
  WHEN INT_LITERAL ARROW statement ;



expression:
  expression OROP term1 {$$ = checkLogical($1, $3);} |
  term1
  ;

term1:
  term1 ANDOP term2 {$$ = checkLogical($1,$3);} |
  term1
  ;

term2:
  term2 RELOP term3 {$$ = checkRelational($1,$3);} |
  term3
  ;

term3:
  term3 ADDOP term4 {$$ = checkArithmetic($1,$3);} |
  term4
  ;

term4:
  term4 MULOP term5 {$$ = checkArithmetic($1, $3);} |
  term4 REMOP term5 {$$ = checkArithmetic($1, $3);} |
  term5
  ;

term5:
  term5 EXPOP term6 {$$ = checkArithmetic($1,$3);} |
  term6
  ;

term6:
  NOTOP primary {$$ = $2;} |
  primary
  ;

primary:
  '(' expression ')' {$$ = $2;} |
  INT_LITERAL | REAL_LITERAL | BOOLEAN_LITERAL |
  IDENTIFIER {if (!symbols.find($1, $$)) appendError(UNDECLARED, $1);};

%%

void yyerror(const char* message)
{
	appendError(SYNTAX, message);
}

int main(int argc, char *argv[])
{
	firstLine();
	yyparse();
	lastLine();
	return 0;
}
