/*
 * @Copyright: minic
 * @Author: linmaosen
 * @Description: 定义中间代码的记录出口函数
 * @LastEditors: linmaosen
 * @LastEditTime: 2020-06-13
 * @FilePath: /minic/Code.h
 */

#pragma once
#include"main.h"



#define  pc 7

#define  gp 6

#define bp 5

#define sp 4
 
#define  bx 2

#define  ax 1

#define  zero 0



/**
 * @description: 输出注释
 * @param {char*} 
 * @return: void
 */
void emitComment( char * c );


/**
 * @description: 添加指令的中间代码
 * @param {char*, int, int, int, char*} 
 * @return: void
 */
void emitRO( char *op, int r, int s, int t, char *c);


/**
 * @description: 添加指令的中间代码
 * @param {char*, int, int, int, char*} 
 * @return: void
 */
void emitRM( char * op, int r, int d, int s, char *c);


/**
 * @description: 让emitLoc加上howMany, 并返回之前的位置
 * @param {int} 
 * @return: int
 */
int emitSkip( int howMany);


/**
 * @description: 回退到指定位置，用于回退设置出口
 * @param {int} 
 * @return: void
 */
void emitBackup( int loc);


/**
 * @description: 让emitLoc等于最大值，回到最大的位置
 * @param {} 
 * @return: void
 */
void emitRestore(void);


/**
 * @description: 转换成绝对位置
 * @param {char*, int, int, char*} 
 * @return: void
 */
void emitRM_Abs( char *op, int r, int a, char * c);