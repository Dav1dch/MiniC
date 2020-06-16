#pragma once
#include <stdio.h>
#include<string>
// #include"main.h"
using namespace std;

/* SIZE is the size of the hash table */
#define SIZE 211

/* MAX_SCOPE is maximum allowed scope can be changed for larger programs*/
#define MAX_SCOPE 8

/* the list of line numbers of the source 
 * code in which a variable is referenced
 */
typedef struct LineListRec
{
   int lineno;
   struct LineListRec *next;
} * LineList;

/* The record in the bucket lists for
 * each variable, including name, 
 * assigned memory location, and
 * the list of line numbers in which
 * it appears in the source code
 */
typedef struct BucketListRec
{
   string name;
   LineList lines;
   int memloc;    /* memory location for variable */
   int scope;     /* scope of the variable */
   int isParam;   /* param */
   int fun_start; /*function start location */
   struct BucketListRec *next;
} * BucketList;

/* the hash table */
//static BucketList hashTable[SIZE];

static struct ScopeList
{

   BucketList hashTable[SIZE];
} Scope[MAX_SCOPE];

/* Procedure st_insert inserts line numbers and
 * memory locations into the symbol table
 * loc = memory location is inserted only the
 * first time, otherwise ignored
 */
void st_insert(string name, int lineno, int loc, int scope, int isparam);

/* Function st_lookup returns the memory 
 * location of a variable or -1 if not found
 */
int st_lookup(string name, int scope);

/* Function fun_lookup returns the  bucket 
 * location of a funtion or NULL if not found
 */
BucketList fun_lookup(string name, int sp1);

/* Function var_lookup returns the  bucket 
 * location of a var or NULL if not found
 */
BucketList var_lookup(string name, int sp1);

/* Procedure printSymTab prints a formatted 
 * listing of the symbol table contents 
 * to the listing file
 */
void printSymTab(FILE *listing);
