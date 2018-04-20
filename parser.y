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


%type <value> body statement expressions expression term1 term2
  term3 term4 term5 term6
	factor cases case

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
  IF expression THEN statement ELSE statement ENDIF ';' {$$ = evaluateif($1, $3,$5);}  |
  CASE expression IS cases OTHERS ARROW statement ENDCASE ';' {$$ = evaluatecase($1);};

/**statements:
 | statements statement;**/

cases:
  case | cases case ;

case:
  WHEN INT_LITERAL ARROW statement ;

operator:
  ADDOP |
  MULOP ;

factor:
	'(' expressions ')' {$$ = $2;} |
  NOT factor {$$ = $1} |
  INT_LITERAL {$$ = $3} | REAL_LITERAL {$$ = $3} | BOOLEAN_LITERAL {$$ = $3} |
  IDENTIFIER {if (!symbols.find($1, $$)) appendError(UNDECLARED, $1);} ;

expressions:
  expression |
  expressions ',' expression
  ;

expression:
 expression OROP term1  |
 term1
 ;

term1:
  term1 ANDOP term2 {$$ = $1 && $3;} |
  term2
  ;

term2:
  term2 RELOP term3 {$$ = evaluateRelational($1, $2,$3);} |
  term3
  ;

term3:
  term3 EXPOP term4 {$$ = evaluateADD($1, $2,$3);} |
  term4
  ;

term4:
  term4 REMOP term5 {$$ = evaluateADD($1, $2,$3);} |
  term5
  ;

term5:
  term5 MULOP term6 {$$ = evaluateADD($1, $2,$3);} |
  term6
  ;

term6:
  term6 ADDOP factor {$$ = evaluateADD($1, $2,$3);} |
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
