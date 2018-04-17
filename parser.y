/* Compiler Theory and Design
   Dr. Duane J. Jarc */

%{

#include <string>
#include <string>
#include <vector>
#include <map>

using namespace std;

#include "values.h"
#include "listing.h"
#include "symbols.h"

int yylex();
void yyerror(const char* message);

Symbols<int> symbols;

int result;

%}

%error-verbose

%union
{
  CharPtr iden;
  Operators oper;
  int value;
}

%token <iden> IDENTIFIER
%token <value> INT_LITERAL

%token <oper> ADDOP MULOP RELOP REMOP EXPOP
%token ANDOP OROP NOTOP

%token BEGIN_ BOOLEAN END ENDREDUCE FUNCTION INTEGER IS REDUCE RETURNS
%token REAL IF THEN ELSE ENDIF CASE OTHERS ARROW ENDCASE WHEN
%token REAL_LITERAL BOOLEAN_LITERAL NOT


%type <value> body statement_ statement reductions expression relation term
	factor primary
%type <oper> operator

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
	IDENTIFIER ':' type IS statement ;

parameters:
  | parameters parameter ;

parameter:
  IDENTIFIER ':' type

type:
	INTEGER |
  REAL |
	BOOLEAN ;

body:
	BEGIN_ statement END ';' {$$ = $2;} ;

statement:
	expression ';' |
	REDUCE operator statements ENDREDUCE {$$ = $3;} ';' |
  IF expression THEN statement ELSE statement ENDIF ';' |
  CASE expression IS cases OTHERS ARROW statement ';' ENDCASE ';' ;

statements:
 | statements statement ;

cases:
  | cases case ;

case:
  WHEN INT_LITERAL ARROW statement ;

operator:
	ADDOP |
	MULOP ;

factor:
	'(' expressions ')' {$$ = $2;} |
  NOT factor |
  INT_LITERAL | REAL_LITERAL | BOOLEAN_LITERAL |
  IDENTIFIER {if (!symbols.find($1, $$)) appendError(UNDECLARED, $1);} ;

expressions:
  expression |
  expressions ',' expression
  ;

expression:
 expression OROP term1 |
 term1
 ;

term1:
  term1 ANDOP term2 |
  term2
  ;

term2:
  term2 RELOP term3 |
  term3
  ;

term3:
  term3 EXPOP term4 |
  term4
  ;

term4:
  term4 REMOP term5 |
  term5
  ;

term5:
  term5 MULOP term6 |
  term6
  ;

term6:
  term6 ADDOP factor |
  factor
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
	if (lastLine() == 0)
    cout << "Result = " << result << endl;
	return 0;
}
