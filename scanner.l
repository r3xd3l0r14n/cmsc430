/* Compiler Theory and Design
   Dr. Duane J. Jarc */

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
id		([a-zA-Z]+(?:_[a-zA-Z]+)*)
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
{id}		{ ECHO; return(IDENTIFIER);}
{int}		{ ECHO; return(INT_LITERAL); }
{punc}		{ ECHO; return(yytext[0]); }
{realLit} { ECHO; return(REAL_LITERAL); }
true      { ECHO; return(BOOL_LITERAL); }
false     { ECHO; return(BOOL_LITERAL); }
case      { ECHO; return(CASE); }
else      { ECHO; return(ELSE); }
endcase   { ECHO; return(ENDCASE); }
endif     { ECHO; return(ENDIF); }
if        { ECHO; return(IF); }
is        { ECHO; return(IS); }
others    { ECHO; return(OTHERS); }
real      { ECHO; return(REAL); }
returns   { ECHO; return(RETURNS); }
then      { ECHO; return(THEN); }
when      { ECHO; return(WHEN); }
.		{ ECHO; appendError(LEXICAL, yytext); }
%%

int main()
{
	firstLine();

	FILE *file = fopen("lexemes.txt", "wa");
	int token = yylex();
	while (token)
	{
		fprintf(file, "%d %s\n", token, yytext);
		token = yylex();
	}
	lastLine();
	fclose(file);
	return 0;
}
