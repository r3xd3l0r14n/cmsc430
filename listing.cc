// Compiler Theory and Design
// Colin R.R. Delorme
// 24 Mar 2018

// This file contains the bodies of the functions that produces the compilation
// listing

#include <cstdio>
#include <string>

using namespace std;

#include "listing.h"

static int lineNumber;
static string error = "";
static int totalErrors = 0;
static int lexErrors = 0;
static int semErrors = 0;
static int synErrors = 0;

static void displayErrors();

void firstLine()
{
	lineNumber = 1;
	printf("\n%4d  ",lineNumber);
}

void nextLine()
{
	displayErrors();
	lineNumber++;
	printf("%4d  ",lineNumber);
}

int lastLine()
{
	printf("\r");
	displayErrors();
	printf("     \n");
	if (totalErrors == 0)
	{
			printf("Compiled Succesfully");
	}
	else
	{
			printf("Lexical Errors: %4d\n", lexErrors);
			printf("Syntax Errors: %4d\n", synErrors);
			printf("Semantic Errors: %4d\n", semErrors);
	}

	return totalErrors;
}

void appendError(ErrorCategories errorCategory, string message)
{
	string messages[] = { "Lexical Error, Invalid Character ",
	  "Syntax Error, ",
		"Semantic Error, ", "Semantic Error, Duplicate Identifier: ",
		"Semantic Error, Undeclared " };
		//error = messages[errorCategory] + message;
	if (errorCategory == 0)
	{
		error += messages[errorCategory]+message+"\n";
		lexErrors++;
	} else if (errorCategory == 1)
	{
		error += messages[errorCategory]+message+"\n";
		synErrors++;
	} else
	{
		error += messages[errorCategory]+message+"\n";
		semErrors++;
	}
	/*error = messages[errorCategory] + message;*/
	totalErrors++;
}

void displayErrors()
{
	if (error != "")
		printf("%s", error.c_str());
	error = "";
}
