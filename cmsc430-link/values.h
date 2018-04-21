// CMSC 430
// Duane J. Jarc

// This file contains function definitions for the evaluation functions

typedef char* CharPtr;
enum Operators {LESS, ADD, MULTIPLY, SUBTRACT, DIVIDE,REM,EQL,DIVA,GRT,GREATEREQL,LESSEQL,EXP};

int evaluateReduction(Operators operator_, int head, int tail);
int evaluateRelational(int left, Operators operator_, int right);
int evaluateADD(int left, Operators operator_, int right);
int evaluateif(int left, Operators operator_ int right);
int evaluatecase(int left);
