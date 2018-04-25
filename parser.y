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

%type <type> type statement statements expressions expression

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
  error ';' {$$ = MISMATCH};

statement:
	expression ';' |
  IF expression THEN statement ELSE statement ENDIF ';' {$$ = $3} |
  CASE expression IS cases OTHERS ARROW statement ';' ENDCASE ';' {$$=$3} |
  error ';' ;

cases:
  | cases case ;

case:
  WHEN INT_LITERAL ARROW statement ;

primary:
  '(' expression ')' |
  INT_LITERAL | REAL_LITERAL | BOOLEAN_LITERAL |
  IDENTIFIER ;

expression:
  expression OROP term1 |
  term1
  ;
  
term1:
  term1 ANDOP term2 |
  term1
  ;

term2:
  term2 RELOP term3 |
  term3
  ;

term3:
  term3 ADDOP term4 |
  term4
  ;

term4:
  term4 MULOP term5 |
  term4 REMOP term5 |
  term5
  ;

term5:
  term5 EXPOP term6 |
  term6
  ;

term6:
  NOTOP primary |
  primary
  ;


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
