/*
 * @Copyright: minic 
 * @Author: David.Huangjunlang 
 * @File: main.h 
 * @Descriptions: undefined 
 * @Last Modified by: David.Huangjunlang
 * @Last Modified time: 2020-04-24 00:59:23
 */

#ifndef MAIN_H
#define MAIN_H
#include <stdio.h>
#include <stdlib.h>
#include <string>

typedef enum
{
    StmtK,
    ExpK
} NodeKind;
typedef enum
{
    ProgramK,
    DeclK,
    ParamlK,
    LocdeclK,
    StmtlK,
    ArgsK,
    VardecK,
    VoidFundecK,
    IntFundecK,
    ParamK,
    CompK,
    SelectK,
    IteraK,
    ExpressionK,
    ReturnK
} StmtKind;
typedef enum
{
    IdK,
    ConstK,
    ArrayK,
    ArrayptrK,
    IndexK,
    AssignK,
    OpK,
    MulK,
    CallK,
    AddK
} ExpKind;

#define MAXCHILDREN 3

typedef struct node
{
    node *nodeChild[MAXCHILDREN];
    node *listChild[MAXCHILDREN];
    node *next;
    NodeKind nodekind;
    int lineno;
    union {
        StmtKind stmt;
        ExpKind exp;
    } kind;
    union {
        std::string op;
        std::string name;
        int val;
    } attr;
};

typedef struct
{
    std::string m_id;
    std::string m_reserved;
    int m_num;
    std::string m_op;
    node *m_node;
}   ytype;

extern node *programNode;

#define YYSTYPE ytype
#endif