#pragma once
#include<stdio.h>

void st_insert(char* name, int lineno, int loc);

/* Function st_lookup returns the memory
 * location of a variable or -1 if not found
 */
int st_lookup(char* name);

/* Procedure printSymTab prints a formatted
 * listing of the symbol table contents
 * to the listing file
 */
void printSymTab(FILE* listing);
