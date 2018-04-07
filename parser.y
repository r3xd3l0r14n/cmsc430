/* Compiler Theory and Design
   Dr. Duane J. Jarc */

%{

#include <string>

using namespace std;

#include "listing.h"

int yylex();
void yyerror(const char* message);

%}

%error-verbose

%token IDENTIFIER
%token INT_LITERAL

%token ADDOP MULOP RELOP ANDOP REMOP EXPOP OROP NOTOP

%token BEGIN_ BOOLEAN END ENDREDUCE FUNCTION INTEGER IS REDUCE RETURNS
%token REAL IF THEN ELSE ENDIF CASE OTHERS ARROW ENDCASE WHEN
%token REAL_LITERAL BOOLEAN_LITERAL NOT

%%

function:
	function_header variables body ;

function_header:
	FUNCTION IDENTIFIER parameters RETURNS type ';' |
  error ';'
  ;

variables:
  variable ;

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
	BEGIN_ statement END ';' ;

statement:
	expression ';' |
	REDUCE operator statements ENDREDUCE ';' |
  IF expression THEN statement ELSE statement ENDIF ';' |
  CASE expression IS cases OTHERS ARROW statement ';' ENDCASE ';' |
  error ';' ;

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
	'(' expressions ')' |
  NOT factor |
  INT_LITERAL | REAL_LITERAL | BOOLEAN_LITERAL |
  IDENTIFIER ;

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

/*binary_operator:
  ADDOP | MULOP | REMOP | EXPOP | RELOP | ANDOP | OROP ;

relation:
	relation RELOP term |
	term;

term:
	term ADDOP factor |
	factor ;

factor:
	factor MULOP primary |
	primary ;

primary:
	'(' expression ')' |
	INT_LITERAL |
	IDENTIFIER ;
  */

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
