/*
 * @Copyright: minic
 * @Author: linmaosen
 * @Description: 语义分析：实现构建符号表和类型检查的函数
 * @LastEditors: linmaosen
 * @LastEditTime: 2020-06-13
 * @FilePath: /minic/Analyse.cpp
 */

#include "Analyse.h"
#include "Symtab.h"

// 记录最大的scope
extern int HighScope;

// 记录是哪个scope
static int scope_a = 0;
static int location[MAX_SCOPE] = {0, 0, 0, 0, 0, 0, 0, 0};

static int No_change = 0;

/**
 * @description: 前序遍历生成符号表,后序遍历类型检查
 * @param {node*, void*, void*} 
 * @return: void
 */
static void traverse(node *t,
                     void (*preProc)(node *),
                     void (*postProc)(node *))
{
  if (t != NULL)
  {
    preProc(t);
    {
      int i;
      for (i = 0; i < MAXCHILDREN; i++)
        traverse(t->nodeChild[i], preProc, postProc);
    }
    postProc(t);
    traverse(t->next, preProc, postProc);
  }
}


/**
 * @description: 空函数，什么也不执行
 * @param {node*} 
 * @return: void
 */
static void nullProc(node *t)
{
  if (t == NULL)
    return;
  else
    return;
}


/**
 * @description: 将语法树结点中的变量、方法名插入符号表中
 * @param {node*} 
 * @return: void
 */
static void insertNode(node *t)
{
  switch (t->nodekind)
  {
  case StmtK:
    switch (t->kind.stmt)
    {
    case FunK:
      location[scope_a] = 0;
      t->scope = 0;  // scope==0 表示是全局的方法， main() gcd()
      if (st_lookup(t->name, 0) == -1)
        st_insert(t->name, t->lineno, -1, 0, 0, 0);
      else
        st_insert(t->name, t->lineno, -1, 0, 0, 0);
      break;
    case CompK:
    {
      if (!No_change)
      {
        scope_a = scope_a + 1;
      }
      else
      {
        No_change = 0;
      }
      HighScope = scope_a;
      break;
    }
    case SelectK:
      if ((t->nodeChild[1])->kind.stmt == CompK)
        No_change = 1;
      break;
    case IteraK:
      if ((t->nodeChild[1])->kind.stmt == CompK)
        No_change = 1;
      break;
    case VarK:
      t->scope = t->isParameter == 1 ? scope_a + 1 : scope_a;
      if (st_lookup(t->name, t->isParameter == 1 ? scope_a + 1 : scope_a) == -1)
        st_insert(t->name, t->lineno, location[scope_a]++, t->isParameter == 1 ? scope_a + 1 : scope_a, t->isParameter == 1 ? 1 : 0, 0);
      else
        st_insert(t->name, t->lineno, 0, t->isParameter == 1 ? scope_a + 1 : scope_a, t->isParameter == 1 ? 1 : 0, 0);
      break;
    case ArrayK:
      if (t->isParameter)
      {
        t->scope = scope_a + 1;
        if (st_lookup(t->name, scope_a + 1) == -1)
          st_insert(t->name, t->lineno, location[scope_a]++, scope_a + 1, 1, 1);
        else
          st_insert(t->name, t->lineno, 0, scope_a + 1, 1, 1);
      }
      else
      {
        if (st_lookup(t->name, 0) == -1)
        {
          t->scope = scope_a; // 不是全局的
        }
        else
        {
          t->scope = 0; 
          break;
        }

        if (st_lookup(t->name, scope_a) == -1)
        {
          st_insert(t->name, t->lineno, location[scope_a]++, scope_a, t->isParameter == 1 ? 1 : 0, 1);
          location[scope_a] += t->val - 1;
        }
        else
          st_insert(t->name, t->lineno, 0, t->isParameter == 1 ? scope_a + 1 : scope_a, t->isParameter == 1 ? 1 : 0, 1);
      }
      break;
    case CallK:
      t->scope = 0;
      if (st_lookup(t->name, 0) == -1)
        st_insert(t->name, t->lineno, -1, 0, 0, 0);
      else
        st_insert(t->name, t->lineno, -1, 0, 0, 0);
      break;

    default:
      break;
    }
    break;
  case ExpK:
    switch (t->kind.exp)
    {
    case IdK:
      if (st_lookup(t->name, 0) == -1)
        t->scope = t->isParameter == 1 ? scope_a + 1 : scope_a;
      else
        t->scope = 0;
        // 函数的参数
      if (t->isParameter == 1)
      {
        t->scope = scope_a + 1;
        if (st_lookup(t->name,scope_a + 1) == -1)
          st_insert(t->name, t->lineno, location[scope_a]++, scope_a + 1,1, 0);
        else
          st_insert(t->name, t->lineno, 0,scope_a + 1,  1, 0);
      }
      break;
    default:
      break;
    }
    break;
  default:
    break;
  }
}


/**
 * @description: 前序遍历构建符号表
 * @param {node*} 
 * @return: void
 */
void buildSymtab(node *syntaxTree)
{
  traverse(syntaxTree, insertNode, nullProc);
}


static void typeError(node *t, char *message)
{
}


static void checkNode(node *t)
{
}


/**
 * @description: 后序遍历类型检查
 * @param {node*} 
 * @return: void
 */
void typeCheck(node *syntaxTree)
{
  traverse(syntaxTree, nullProc, checkNode);
}

