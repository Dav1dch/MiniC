/*
 * @Copyright: minic
 * @Author: linmaosen
 * @Description: 实现中间代码的记录出口等函数
 * @LastEditors: linmaosen
 * @LastEditTime: 2020-06-13
 * @FilePath: /minic/Code.cpp
 */

#include "Code.h"

extern FILE *code;

extern int TraceCode;

// 当前指令的位置
static int emitLoc = 0 ;

// 最大的位置
static int highEmitLoc = 0;


/**
 * @description: 输出注释
 * @param {char*} 
 * @return: void
 */
void emitComment( char * c )
{ if (TraceCode) fprintf(code,"* %s\n",c);}


/**
 * @description: 添加中间代码
 * @param {char*, int, int, int, char*} 
 * @return: void
 */
void emitRO( char *op, int r, int s, int t, char *c)
{ fprintf(code,"%3d:  %5s  %d,%d,%d ",emitLoc++,op,r,s,t);
  if (TraceCode) fprintf(code,"\t%s",c) ;
  fprintf(code,"\n") ;
  if (highEmitLoc < emitLoc) highEmitLoc = emitLoc ;
} /* emitRO */


/**
 * @description: 添加中间代码
 * @param {char*, int, int, int, char*} 
 * @return: void
 */
void emitRM( char * op, int r, int d, int s, char *c)
{ fprintf(code,"%3d:  %5s  %d,%d(%d) ",emitLoc++,op,r,d,s);
  if (TraceCode) fprintf(code,"\t%s",c) ;
  fprintf(code,"\n") ;
  if (highEmitLoc < emitLoc)  highEmitLoc = emitLoc ;
} /* emitRM */


/**
 * @description: 让emitLoc加上howMany, 并返回之前的位置
 * @param {int} 
 * @return: int
 */
int emitSkip( int howMany)
{  int i = emitLoc;
   emitLoc += howMany ;
   if (highEmitLoc < emitLoc)  highEmitLoc = emitLoc ;
   return i;
} /* emitSkip */


/**
 * @description: 回退到指定位置，用于回退设置出口
 * @param {int} 
 * @return: void
 */
void emitBackup( int loc)
{ if (loc > highEmitLoc) emitComment("BUG in emitBackup");
  emitLoc = loc ;
} /* emitBackup */


/**
 * @description: 让emitLoc等于最大值，回到最大的位置
 * @param {} 
 * @return: void
 */
void emitRestore(void)
{ emitLoc = highEmitLoc;}


/**
 * @description: 转换成绝对位置
 * @param {char*, int, int, char*} 
 * @return: void
 */
void emitRM_Abs( char *op, int r, int a, char * c)
{ fprintf(code,"%3d:  %5s  %d,%d(%d) ",
               emitLoc,op,r,a-(emitLoc+1),pc);
  ++emitLoc ;
  if (TraceCode) fprintf(code,"\t%s",c) ;
  fprintf(code,"\n") ;
  if (highEmitLoc < emitLoc) highEmitLoc = emitLoc ;
} /* emitRM_Abs */
