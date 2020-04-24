#ifndef UTILS_H
#define UTILS_H
#include "main.h"

extern node *programNode;
extern FILE *result;
node * newStmtNode(StmtKind kind);
node * newExpNode(ExpKind kind);
void addNode(node *list, node *stmt);
void printTree();
void printNode(node *, int);
void printList(node *);

#endif