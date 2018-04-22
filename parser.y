/* Compiler Theory and Design
   Dr. Duane J. Jarc */

%{

#include <iostream>
#include <string>
#include <vector>
#include <map>

using namespace std;

#include "values.h"
#include "listing.h"
#include "symbols.h"

int yylex();
void yyerror(const char* message);

Symbols<double> symbols;

int result;

static double* args;
static int counter;
%}

%error-verbose

%union
{
  CharPtr iden;
  Operators oper;
  double value;
}

%token <iden> IDENTIFIER
%token <value> INT_LITERAL REAL_LITERAL BOOLEAN_LITERAL

%token <oper> ADDOP MULOP RELOP REMOP EXPOP
%token ANDOP OROP NOTOP

%token BEGIN_ BOOLEAN END ENDREDUCE FUNCTION INTEGER IS REDUCE RETURNS
%token REAL IF THEN ELSE ENDIF CASE OTHERS ARROW ENDCASE WHEN
%token NOT

%type <value> body statement expression term1 term2 term3 term4 term5 term6 cases case primary
%type <value> parameter
%%

function:
	function_header variables body {result = $3;};

function_header:
	FUNCTION IDENTIFIER parameters RETURNS type ';' |
  error ';'
  ;

variables:
  variable_ variables |
   ;

variable_:
  variable |
  error ';' ;

variable:
	IDENTIFIER ':' type IS statement {symbols.insert($1, $5);} ;

parameters:
  |
  parameter |
  parameters ',' parameter ;

parameter:
  IDENTIFIER ':' type {symbols.insert($1, args[counter++]);};

type:
	INTEGER |
  REAL |
	BOOLEAN ;

body:
	BEGIN_ statement END ';' {$$ = $2;} ;

statement:
	expression ';' |
  IF expression THEN statement ELSE statement ENDIF ';' {$$=($<value>2 == 1) ? $4:$6 ;}  |
  CASE expression IS cases OTHERS ARROW statement ENDCASE ';' {$$ = $2;} ;

/**statements:
 | statements statement;**/

cases:
  case | cases case ;

case:
  WHEN INT_LITERAL ARROW statement {$$ = $2;} ;


primary:
	'(' expression ')' {$$ = $2;} |
  INT_LITERAL | REAL_LITERAL | BOOLEAN_LITERAL |
  IDENTIFIER {if (!symbols.find($1, $$)) appendError(UNDECLARED, $1);} ;

expression:
 expression OROP term1 {$$ = $1 || $3;}  |
 term1
 ;

term1:
  term1 ANDOP term2 {$$ = $1 && $3;} |
  term2
  ;

term2:
  term2 RELOP term3 {$$ = evaluateRelational($1, $2, $3);} |
  term3
  ;

term3:
  term3 ADDOP term4 {$$ = evaluateADD($1, $2,$3);} |
  term4
  ;

term4:
  term4 MULOP term5 {$$ = evaluateADD($1, $2,$3);} |
  term4 REMOP term5 {$$ = evaluateADD($1, $2,$3);} |
  term5
  ;

term5:
  term5 EXPOP term6 {$$ = evaluateADD($1, $2,$3);} |
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
  args = new double[argc-1];
  for (int i = 0; i < argc; i++){
    args[i-1] = atof(argv[i]);
  }
	yyparse();
	if (lastLine() == 0)
    cout << "Result = " << result << endl;
	return 0;
}
