/*
 * @Copyright: minic
 * @Author: linmaosen
 * @Description: 实现查询、插入符号表以及输出符号表到文件的函数
 * @LastEditors: linmaosen
 * @LastEditTime: 2020-06-01
 * @FilePath: /minic/Symtab.cpp
 */

#include <stdio.h>
#include <cstdlib>
#include "Symtab.h"
#include <string>
using namespace std;

extern int HighScope;
#define SHIFT 4

/**
 * @description: 返回哈希值
 * @param {string} 
 * @return: int
 */
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


/**
 * @description: 插入符号表，如果哈希值对应的位置不存在，则在头部插入，如果哈希值对应的位置存在，则在尾部连上
 * @param {string, int, int, int, int} 
 * @return: void
 */
void st_insert(string name, int lineno, int loc, int sp, int para, int arr)
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
    l->isArray = arr;
    l->lines = (LineList)malloc(sizeof(struct LineListRec));
    l->lines->lineno = lineno;
    l->memloc = loc;
    l->lines->next = NULL;
    l->next = Scope[sp].hashTable[h];
    Scope[sp].hashTable[h] = l;
  }
  else 
  {
    LineList t = l->lines;
    while (t->next != NULL)
      t = t->next;
    t->next = (LineList)malloc(sizeof(struct LineListRec));
    t->next->lineno = lineno;
    t->next->next = NULL;
  }
} 


/**
 * @description: 查询函数名在符号表中的位置
 * @param {string, int} 
 * @return: BucketList
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


/**
 * @description: 查询变量在符号表中的位置
 * @param {string, int} 
 * @return: BucketList
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


/**
 * @description: 查询符号在符号表中的位置
 * @param {string, int} 
 * @return: int
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


/**
 * @description: 在指定文件中输出符号表
 * @param {FILE} 
 * @return: void
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
} 
