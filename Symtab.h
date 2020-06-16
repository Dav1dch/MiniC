#pragma once
#include <stdio.h>
#include<string>
// #include"main.h"
using namespace std;


#define SIZE 211


#define MAX_SCOPE 8


typedef struct LineListRec
{
   int lineno;
   struct LineListRec *next;
} * LineList;


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



static struct ScopeList
{
   BucketList hashTable[SIZE];
} Scope[MAX_SCOPE];

/*
插入符号表
*/
void st_insert(string name, int lineno, int loc, int scope, int isparam);

/*
查询符号表里是否存在
*/
int st_lookup(string name, int scope);

/*
查询符号表里方法是否存在
*/
BucketList fun_lookup(string name, int sp1);

/*
查询符号表里变量是否存在
*/
BucketList var_lookup(string name, int sp1);


/*
输出符号表
*/
void printSymTab(FILE *listing);
