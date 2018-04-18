// CMSC 430
// Duane J. Jarc

// This file contains the bodies of the evaluation functions

#include <string>
#include <vector>
#include <cmath>

using namespace std;

#include "values.h"
#include "listing.h"

int evaluateReduction(Operators operator_, int head, int tail)
{
	if (operator_ == ADD)
		return head + tail;
	return head * tail;
}


int evaluateRelational(int left, Operators operator_, int right)
{
	int result;
	switch (operator_)
	{
		case LESS:
			result = left < right;
			break;
		case EQL:
			result = left == right;
			break;
		case DIVA:
			result = left /= right;
			break;
		case GRT:
			result = left > right;
			break;
		case GREATEREQL:
			result = left >= right;
			break;
		case LESSEQL:
			result = left <= right;
			break;
	}
	return result;
}

int evaluateADD(int left, Operators operator_, int right)
{
	int result;
	switch (operator_)
	{
		case ADD:
			result = left + right;
			break;
		case SUBTRACT:
			result = left - right;
			break;
		case MULTIPLY:
			result = left * right;
			break;
		case DIVIDE:
			result = left / right;
			break;
		case REM:
			result = left % right;
			break;
		case EXOP:
			result = left ** right;
			break;
	}
	return result;
}
