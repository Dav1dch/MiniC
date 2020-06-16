/*
 * @Copyright: minic
 * @Author: David.Huangjunlang
 * @Description: 工具集的函数实现，包括新节点生成，以及打印语法树
 * @LastEditors: David.Huangjunlang
 * @LastEditTime: 2020-04-30 10:12:27
 * @FilePath: /minic/utils.cpp
 */

#include "utils.h"
// 链接程序根节点
extern node *programNode;
// 链接语法树输出文件
extern FILE *result;
/**
 * @description: 新建一个 statement 类型的 node 并返回 
 * @param {StmtKind} 
 * @return: node*
 */
node *newStmtNode(StmtKind kind)
{
    node *t = new node;
    for (int i = 0; i < MAXCHILDREN; i++)
    {
        t->nodeChild[i] = nullptr;
    }

    t->nodekind = StmtK;
    t->kind.stmt = kind;
    t->next = nullptr;
    t->isArray = 0;
    t->isGlobal = 0;
    t->isParameter = 0;
    t->local_size = 0;
    t->param_size = 0;
    t->val = 0;
    return t;
}

/**
 * @description: 新建一个 expression 类型的 node 并返回
 * @param {ExpKind} 
 * @return: node*
 * @author: David.Huangjunlang
 */
node *newExpNode(ExpKind kind)
{
    node *t = new node;
    for (int i = 0; i < MAXCHILDREN; i++)
    {
        t->nodeChild[i] = nullptr;
    }
    t->nodekind = ExpK;
    t->kind.exp = kind;
    t->next = nullptr;
    t->isArray = 0;
    t->isGlobal = 0;
    t->isParameter = 0;
    t->local_size = 0;
    t->param_size = 0;
    t->val = 0;

    return t;
}

/**
 * @description: 在 nodeList 链表的末尾添加一个 statement 类型的 node 
 * @param {node*, node*} 
 * @return: void
 * @author: David.Huangjunlang
 */
void addNode(node *list, node *stmt)
{
    node *temp = list;
    while (temp->next != nullptr)
    {
        temp = temp->next;
    }
    temp->next = stmt;
}

/**
 * @description: 从程序根节点遍历语法树，并打印到文件中
 * @param {void} 
 * @return: void
 * @author: David.Huangjunlang
 */
void printTree()
{
    node *temp = programNode->nodeChild[0];
    if (temp == nullptr)
    {
        return;
    }
    while (temp->next != nullptr)
    {
        temp = temp->next;
        printNode(temp, 0);
    }
}

/**
 * @description: 打印节点信息到文件中， level 参数用于设定输出缩进格式
 * @param {node*, int} 
 * @return: void
 * @author: David.Huangjunlang
 */
void printNode(node *t, int level)
{
    std::string preWhiteSpace = "";
    for (int i = 0; i < level; i++)
    {
        preWhiteSpace += "\t";
    }

    if (t->nodekind == StmtK)
    {
        switch (t->kind.stmt)
        {
        case FunK:
        {
            fprintf(result, "fun-declaration: \n");
            fprintf(result, "\ttype: int\n");
            fprintf(result, "\tname: %s\n", t->name.c_str());
            if (t->nodeChild[0] != nullptr)
            {
                printNode(t->nodeChild[0], level + 1);
            }
            else
            {
                fprintf(result, "\tparams: void\n");
            }

            printNode(t->nodeChild[1], level + 1);
            break;
        }
        case ParamlK:
        {
            if (t != nullptr)
            {
                fprintf(result, "\tparams: \n");
                node *child = t;
                while (child->next != nullptr)
                {
                    child = child->next;
                    printNode(child, 2);
                }
            }
            else
            {
                fprintf(result, "\tparams: void\n");
            }
            break;
        }
        case CompK:
        {
            fprintf(result, "\tcompound: \n");
            if (t->nodeChild[0] != nullptr)
            {
                fprintf(result, "\t\tlocal-declarations: \n");
                printNode(t->nodeChild[0], 3);
            }
            else
            {
                fprintf(result, "\t\tlocal-declarations: null\n");
            }

            if (t->nodeChild[1] != nullptr)
            {
                fprintf(result, "\t\tstatement-list: \n");
                printNode(t->nodeChild[1], 3);
            }
            else
            {
                fprintf(result, "\t\tstatement-list: null\n");
            }
            break;
        }
        case LocdeclK:
        case StmtlK:
        {
            node *child = t;
            while (child->next != nullptr)
            {
                child = child->next;
                printNode(child, level);
            }
            break;
        }
        case ExpressionK:
        {
            if (t->nodeChild[0] != nullptr)
            {
                printNode(t->nodeChild[0], level);
            }
            else
            {
                fprintf(result, "%sexpression-stmt: null\n", preWhiteSpace.c_str());
            }
            break;
        }
        case SelectK:
        {
            fprintf(result, "%sselection-stmt:\n%s\texpression: \n", preWhiteSpace.c_str(), preWhiteSpace.c_str());
            printNode(t->nodeChild[0], level + 2);
            fprintf(result, "%s\tstatement: \n", preWhiteSpace.c_str());
            printNode(t->nodeChild[1], level + 2);
            if (t->nodeChild[2] != nullptr)
            {
                fprintf(result, "%s\telse-statement: \n", preWhiteSpace.c_str());
                printNode(t->nodeChild[2], level + 2);
            }
            break;
        }
        case DeclK:
        {
            fprintf(result, "program: \n");
            break;
        }
        case IteraK:
        {
            fprintf(result, "%siteration-stmt: \n%s\texpression: \n", preWhiteSpace.c_str(), preWhiteSpace.c_str());
            printNode(t->nodeChild[0], level + 2);
            fprintf(result, "%s\tstatement: \n", preWhiteSpace.c_str());
            printNode(t->nodeChild[1], level + 2);
            break;
        }
        case ReturnK:
        {
            if (t->nodeChild[0] != nullptr)
            {
                fprintf(result, "%sreturn-stmt: \n%s\texpression: \n", preWhiteSpace.c_str(), preWhiteSpace.c_str());
                printNode(t->nodeChild[0], level + 2);
            }
            else
            {
                fprintf(result, "%sreturn-stmt: \n%s\texpression: null\n", preWhiteSpace.c_str(), preWhiteSpace.c_str());
            }

            break;
        }
        case ArgsK:
        {
            node *child = t;
            while (child->next != nullptr)
            {
                child = child->next;
                printNode(child, level);
            }

            break;
        }
        case ArrayK:
            fprintf(result, "%svarArray: \n%s\tname: %s\n%s\t\n", preWhiteSpace.c_str(),
                    preWhiteSpace.c_str(), t->name.c_str(), preWhiteSpace.c_str());
            break;
        default:
            break;
        }
    }
    else
    {
        switch (t->kind.exp)
        {
        case AssignK:
            fprintf(result, "%sassignment: \n%s\tvarName: %s\n%s\texpression: \n", preWhiteSpace.c_str(), preWhiteSpace.c_str(), t->nodeChild[0]->name.c_str(), preWhiteSpace.c_str());
            printNode(t->nodeChild[1], level + 1);
            break;
        case IdK:
            fprintf(result, "%svar: \n%s\tname: %s\n", preWhiteSpace.c_str(), preWhiteSpace.c_str(), t->name.c_str());
            break;
        case VarK:
            fprintf(result, "%svar: \n%s\tname: %s\n", preWhiteSpace.c_str(), preWhiteSpace.c_str(), t->name.c_str());
            break;
            // case IndexK:
            //     fprintf(result, "%sarrayIndex: \n%s\tname: %s\n%s\tindex: \n", preWhiteSpace.c_str(), preWhiteSpace.c_str(), t->name.c_str(), preWhiteSpace.c_str());
            //     printNode(t->nodeChild[0], level + 1);
            //     break;
            // case ArrayptrK:
            //     fprintf(result, "%sarrayPtr: \n%s\tname: %s\n", preWhiteSpace.c_str(), preWhiteSpace.c_str(), t->name.c_str());
            //     break;

        case ConstK:
            fprintf(result, "%sconst: \n%s\tval: %d\n", preWhiteSpace.c_str(), preWhiteSpace.c_str(), t->val);
            break;
        case OpK:
            fprintf(result, "%ssimple-expression: \n", preWhiteSpace.c_str());
            if (t->nodeChild[1] == nullptr)
            {
                printNode(t->nodeChild[0], level + 1);
            }
            else
            {
                fprintf(result, "%s\tfirst:\n", preWhiteSpace.c_str());
                printNode(t->nodeChild[0], level + 2);
                fprintf(result, "%s\top: %s\n", preWhiteSpace.c_str(), t->op.c_str());
                fprintf(result, "%s\tsecond:\n", preWhiteSpace.c_str());
                printNode(t->nodeChild[1], level + 2);
            }
            break;

       /* case AddK:
            fprintf(result, "%sadditive-expression: \n", preWhiteSpace.c_str());
            fprintf(result, "%s\tfirst:\n", preWhiteSpace.c_str());
            printNode(t->nodeChild[0], level + 2);
            fprintf(result, "%s\top: %s\n", preWhiteSpace.c_str(), t->op.c_str());
            fprintf(result, "%s\tsecond:\n", preWhiteSpace.c_str());
            printNode(t->nodeChild[1], level + 2);
            break;
        case MulK:
            fprintf(result, "%sterm: \n", preWhiteSpace.c_str());
            fprintf(result, "%s\tfirst:\n", preWhiteSpace.c_str());
            printNode(t->nodeChild[0], level + 2);
            fprintf(result, "%s\top: %s\n", preWhiteSpace.c_str(), t->op.c_str());
            fprintf(result, "%s\tsecond:\n", preWhiteSpace.c_str());
            printNode(t->nodeChild[1], level + 2);
            break;*/
        case CallK:
            fprintf(result, "%sfunctionCall: \n", preWhiteSpace.c_str());
            fprintf(result, "%s\tname: %s\n", preWhiteSpace.c_str(), t->name.c_str());
            if (t->nodeChild[0] != nullptr)
            {
                fprintf(result, "%s\targs: \n", preWhiteSpace.c_str());
                printNode(t->nodeChild[0], level + 2);
            }
            else
            {
                fprintf(result, "%s\targs: void\n", preWhiteSpace.c_str());
            }
            break;
        default:
            break;
        }
    }
}
