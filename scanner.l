/* Compiler Theory and Design
   Colin R.R. Delorme
   24Mar 2018 */

/* This file contains flex input file */

%{
#include <cstdio>
#include <string>

using namespace std;

#include "listing.h"
#include "tokens.h"

%}

%option noyywrap

ws		[ \t\r]+
comment		\-\-.*\n
comment2 \/\/.*\n
line		[\n]
id		[A-Za-z](_?[A-Za-z0-9])*
digit		\-?[0-9]
int		{digit}+
punc		[\(\),:;]
realLit \-?[0-9]+[\.][0-9]*
%%

{ws}		{ ECHO; }
{comment}	{ ECHO; nextLine();}
{comment2} { ECHO; nextLine();}
{line}		{ ECHO; nextLine();}
"<"		{ ECHO; return(RELOP); }
"+"		{ ECHO; return(ADDOP); }
"-"   { ECHO; return(ADDOP); }
"*"		{ ECHO; return(MULOP); }
"/"		{ ECHO; return(MULOP); }
rem		{ ECHO; return(MULOP); }
"="   { ECHO; return(RELOP); }
"/="  { ECHO; return(RELOP); }
">"   { ECHO; return(RELOP); }
">="  { ECHO; return(RELOP); }
"<="  { ECHO; return(RELOP); }
"**"  { ECHO; return(EXPOP); }
"=>"  { ECHO; return(ARROW); }
begin		{ ECHO; return(BEGIN_); }
boolean		{ ECHO; return(BOOLEAN); }
end		{ ECHO; return(END); }
endreduce	{ ECHO; return(ENDREDUCE); }
function	{ ECHO; return(FUNCTION); }
integer		{ ECHO; return(INTEGER); }
is		{ ECHO; return(IS); }
reduce		{ ECHO; return REDUCE; }
returns		{ ECHO; return(RETURNS); }
and		{ ECHO; return(ANDOP); }
or    { ECHO; return(OROP); }
not   { ECHO; return(NOTOP);}
true      { ECHO; return(BOOLEAN_LITERAL); }
false     { ECHO; return(BOOLEAN_LITERAL); }
case      { ECHO; return(CASE); }
else      { ECHO; return(ELSE); }
endcase   { ECHO; return(ENDCASE); }
endif     { ECHO; return(ENDIF); }
if        { ECHO; return(IF); }
others    { ECHO; return(OTHERS); }
real      { ECHO; return(REAL); }
then      { ECHO; return(THEN); }
when      { ECHO; return(WHEN); }
{id}		{ ECHO; return(IDENTIFIER);}
{int}		{ ECHO; return(INT_LITERAL); }
{punc}		{ ECHO; return(yytext[0]); }
{realLit} { ECHO; return(REAL_LITERAL); }
.		{ ECHO; appendError(LEXICAL, yytext); }
%%
