#include <stdio.h>
#include <cstdlib>
#include "Symtab.h"
#include <string>
using namespace std;

extern int HighScope;

/* SHIFT is the power of two used as multiplier
   in hash function  */
#define SHIFT 4

/* the hash function */
static int Hash(string key)
{
  int temp = 0;
  int i = 0;
  while (key[i] != '\0')
  {
    temp = ((temp << SHIFT) + key[i]) % SIZE;
    ++i;
  }
  return temp;
}

/* Procedure st_insert inserts line numbers and
 * memory locations into the symbol table
 * loc = memory location is inserted only the
 * first time, otherwise ignored
 */
void st_insert(string name, int lineno, int loc, int sp, int para)
{
  int h = Hash(name);
  BucketList l = Scope[sp].hashTable[h];
  while ((l != NULL) && name != l->name)
    l = l->next;
  if (l == NULL) /* variable not yet in table */
  {
    //l = (BucketList)malloc(sizeof(struct BucketListRec));
    l = new BucketListRec();
    l->name = name;
    l->scope = sp;     /* scope of variable */
    l->isParam = para; /* parameter or not */
    l->lines = (LineList)malloc(sizeof(struct LineListRec));
    l->lines->lineno = lineno;
    l->memloc = loc;
    l->lines->next = NULL;
    l->next = Scope[sp].hashTable[h];
    Scope[sp].hashTable[h] = l;
  }
  else /* found in table, so just add line number */
  {
    LineList t = l->lines;
    while (t->next != NULL)
      t = t->next;
    t->next = (LineList)malloc(sizeof(struct LineListRec));
    t->next->lineno = lineno;
    t->next->next = NULL;
  }
} /* st_insert */

/* Function fun_lookup returns the  bucket 
 * location of a funtion or NULL if not found
 */
BucketList fun_lookup(string name, int sp)
{
  int h = Hash(name);
  BucketList l = Scope[sp].hashTable[h];
  while ((l != NULL) && (name != l->name))
    l = l->next;
  if (l == NULL)
    return NULL;
  else
    return l;
}

/* Function var_lookup returns the  bucket 
 * location of a var or NULL if not found
 */
BucketList var_lookup(string name, int sp)
{
  int h = Hash(name);
  BucketList l = Scope[sp].hashTable[h];
  while ((l != NULL) && (name != l->name))
    l = l->next;
  if (l == NULL)
    return NULL;
  else
    return l;
}

/* Function st_lookup returns the memory 
 * location of a variable or -1 if not found
 */
int st_lookup(string name, int sp)
{
  int h = Hash(name);
  BucketList l = Scope[sp].hashTable[h];
  while ((l != NULL) && (name != l->name))
    l = l->next;
  if (l == NULL)
    return -1;
  else
    return l->memloc;
}

/* Procedure printSymTab prints a formatted 
 * listing of the symbol table contents 
 * to the listing file
 */
void printSymTab(FILE *listing)
{
  int i, j;
  for (j = 0; j <= HighScope; j++)
  {
    fprintf(listing, "Scope Variable Name  Location   Line Numbers\n");
    fprintf(listing, "----- -------------  --------   ------------\n");
    for (i = 0; i < SIZE; ++i)
    {
      if (Scope[j].hashTable[i] != NULL)
      {
        BucketList l = Scope[j].hashTable[i];
        while (l != NULL)
        {
          LineList t = l->lines;
          fprintf(listing, "%-6d ", l->scope);
          fprintf(listing, "%-14s ", l->name);
          fprintf(listing, "%-8d  ", l->memloc);
          while (t != NULL)
          {
            fprintf(listing, "%4d ", t->lineno);
            t = t->next;
          }
          fprintf(listing, "\n");
          l = l->next;
        }
      }
    }
    fprintf(listing, "\n");
  }
} /* printSymTab */
