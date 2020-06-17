/*
 * @Copyright: minic
 * @Author: linmaosen
 * @Description: 语义分析：定义构建符号表和类型检查的函数
 * @LastEditors: linmaosen
 * @LastEditTime: 2020-06-13
 * @FilePath: /minic/Analyse.h
 */

#pragma once
#include"main.h"

/**
 * @description: 构建符号表
 * @param {node*} 
 * @return: void
 */
void buildSymtab(node*);


/**
 * @description: 类型检查
 * @param {node*} 
 * @return: void
 */
void typeCheck(node*);