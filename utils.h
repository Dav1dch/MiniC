/*
 * @Copyright: minic
 * @Author: David.Huangjunlang
 * @Description: 工具集的头文件，定义函数
 * @LastEditors: David.Huangjunlang
 * @LastEditTime: 2020-04-29 02:31:38
 */
#ifndef UTILS_H
#define UTILS_H
#include "main.h"
#include <string>


/**
 * @description: 新建一个 statement 类型的 node 并返回 
 * @param {StmtKind} 
 * @return: node*
 */
node *newStmtNode(StmtKind kind);

/**
 * @description: 新建一个 expression 类型的 node 并返回
 * @param {ExpKind} 
 * @return: node*
 * @author: David.Huangjunlang
 */
node *newExpNode(ExpKind kind);

/**
 * @description: 在 nodeList 链表的末尾添加一个 statement 类型的 node 
 * @param {node*, node*} 
 * @return: void
 * @author: David.Huangjunlang
 */
void addNode(node *list, node *stmt);

/**
 * @description: 从程序根节点遍历语法树，并打印到文件中
 * @param {void} 
 * @return: void
 * @author: David.Huangjunlang
 */
void printTree();

/**
 * @description: 打印节点信息到文件中， level 参数用于设定输出缩进格式
 * @param {node*, int} 
 * @return: void
 * @author: David.Huangjunlang
 */
void printNode(node *, int);

#endif
