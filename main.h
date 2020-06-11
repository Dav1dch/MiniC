/*
 * @Copyright: minic
 * @Author: David.Huangjunlang
 * @Description: 主程序头文件
 * @LastEditors: David.Huangjunlang
 * @LastEditTime: 2020-04-29 02:47:12
 * @FilePath: /minic/main.h
 */


#ifndef MAIN_H
#define MAIN_H
#include <stdio.h>
#include <string>

// 枚举节点类型 
typedef enum
{
    StmtK,
    ExpK
} NodeKind;

// 枚举 statement node 类型
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


// 枚举 expression node 类型
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

// 每一个节点最多有三个子节点
#define MAXCHILDREN 3


// 用于语法树的结构体
typedef struct node
{

    node *nodeChild[MAXCHILDREN]; // 子节点
    int lineno;
    node *next; // 链表指针
    NodeKind nodekind; // 节点类型
    union {
        StmtKind stmt;
        ExpKind exp;
    } kind; // statement & expression 节点类型细分
    std::string op; // 运算符属性
    std::string name; // 变量名属性
    int val; // 常量属性
};

// 用于区分不同yacc 中token type 的变量
typedef struct
{
    std::string m_id; // string 类型存储id 的名字
    std::string m_reserved; // string 类型存储关键字
    int m_num; // int 类型 存储常量值
    std::string m_op; // string 类型 存储符号
    node *m_node; // node 存储语句
}   ytype;



// 定义 yacc 节点 token 类型
#define YYSTYPE ytype
#endif
