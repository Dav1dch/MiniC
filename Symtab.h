/*
 * @Copyright: minic
 * @Author: linmaosen
 * @Description: 定义符号表的结构体以及查询、插入符号表的函数
 * @LastEditors: linmaosen
 * @LastEditTime: 2020-06-01
 * @FilePath: /minic/Symtab.h
 */

#pragma once
#include <stdio.h>
#include<string>
// #include"main.h"
using namespace std;

#define SIZE 211
#define MAX_SCOPE 8

/**
 * @description: 定义行的结构体
 * @param {} 
 * @return: 
 */
typedef struct LineListRec
{
   int lineno;
   struct LineListRec *next;
} * LineList;


/**
 * @description: 定义bucket结构体
 * @param {} 
 * @return: 
 */
typedef struct BucketListRec
{
   string name;
   LineList lines;
   int memloc;    
   int scope;     
   int isParam;   
   int fun_start; 
   struct BucketListRec *next;
} * BucketList;


/**
 * @description: 定义scope的结构体
 * @param {} 
 * @return: 
 */
static struct ScopeList
{
   BucketList hashTable[SIZE];
} Scope[MAX_SCOPE];


/**
 * @description: 插入符号表，如果哈希值对应的位置不存在，则在头部插入，如果哈希值对应的位置存在，则在尾部连上
 * @param {string, int, int, int, int} 
 * @return: void
 */
void st_insert(string name, int lineno, int loc, int scope, int isparam);


/**
 * @description: 查询符号在符号表中的位置
 * @param {string, int} 
 * @return: int
 */
int st_lookup(string name, int scope);


/**
 * @description: 查询函数名在符号表中的位置
 * @param {string, int} 
 * @return: BucketList
 */
BucketList fun_lookup(string name, int sp1);


/**
 * @description: 查询变量在符号表中的位置
 * @param {string, int} 
 * @return: BucketList
 */
BucketList var_lookup(string name, int sp1);


/**
 * @description: 在指定文件中输出符号表
 * @param {FILE} 
 * @return: void
 */
void printSymTab(FILE *listing);




