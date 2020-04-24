/*
 * @Copyright: minic
 * @Author: David.Huangjunlang 
 * @File: utils.cc
 * @Descriptions: undefined 
 * @Last Modified by: David.Huangjunlang
 * @Last Modified time: 2020-04-24 00:42:27
 */
#include "utils.h"

node *newStmtNode(StmtKind kind)
{
    node *t = (node *)malloc(sizeof(node));
    for (int i = 0; i < MAXCHILDREN; i++)
    {
        t->nodeChild[i] = nullptr;
        t->listChild[i] = nullptr;
    }

    t->nodekind = StmtK;
    t->kind.stmt = kind;
    t->next = nullptr;
    return t;
}

node *newExpNode(ExpKind kind)
{
    node *t = (node *)malloc(sizeof(node));
    for (int i = 0; i < MAXCHILDREN; i++)
    {
        t->nodeChild[i] = nullptr;
        t->listChild[i] = nullptr;
    }
    t->nodekind = ExpK;
    t->kind.exp = kind;
    t->next = nullptr;
    return t;
}

void addNode(node *list, node *stmt)
{
    node *temp = list;
    while (temp->next != nullptr)
    {
        temp = temp->next;
    }
    temp->next = stmt;
}

void printTree()
{
    node *temp = programNode->listChild[0];
    printList(temp);
}

void printList(node *t)
{
    node *temp = t;
    while (temp->next != nullptr)
    {
        temp = temp->next;
        printNode(temp, 0);
    }
}
// typedef enum
// {
//     ProgramK,
//     DeclK,
//     ParamlK,
//     LocdeclK,
//     StmtlK,
//     ArgsK,
//     VardecK,
//     FundecK,
//     ParamK,
//     CompK,
//     SelectK,
//     IteraK,
//     ExpressionK,
//     ReturnK
// } StmtKind;
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
        case IntFundecK:
        {
            fprintf(result, "fun-declaration: \n");
            fprintf(result, "\ttype: int\n");
            fprintf(result, "\tname: %s\n", t->attr.name.c_str());
            if (t->listChild[0] != nullptr)
            {
                printNode(t->listChild[0], level + 1);
            }
            else
            {
                fprintf(result, "\tparams: void\n");
            }

            printNode(t->nodeChild[0], level + 1);
            break;
        }
        case VoidFundecK:
        {
            fprintf(result, "fun-declaration: \n");
            fprintf(result, "\ttype: void\n");
            fprintf(result, "\tname: %s\n", t->attr.name.c_str());
            if (t->listChild[0] != nullptr)
            {
                printNode(t->listChild[0], level + 2);
            }
            else
            {
                fprintf(result, "\tparams: void\n");
            }

            printNode(t->nodeChild[0], level + 2);
            break;
        }
        case ParamlK:
        {
            if (t != nullptr)
            {
                fprintf(result, "\tparams: \n", preWhiteSpace.c_str());
                node *child = t;
                while (child->next != nullptr)
                {
                    child = child->next;
                    printNode(child, 2);
                }
            }
            else
            {
                fprintf(result, "\tparams: void\n", preWhiteSpace.c_str());
            }
            break;
        }
        case CompK:
        {
            fprintf(result, "\tcompound: \n", preWhiteSpace.c_str());
            if (t->listChild[0] != nullptr)
            {
                fprintf(result, "\t\tlocal-declarations: \n", preWhiteSpace.c_str());
                printNode(t->listChild[0], 3);
            }
            else
            {
                fprintf(result, "\t\tlocal-declarations: null\n", preWhiteSpace.c_str());
            }

            if (t->listChild[1] != nullptr)
            {
                fprintf(result, "\t\tstatement-list: \n", preWhiteSpace.c_str());
                printNode(t->listChild[1], 3);
            }
            else
            {
                fprintf(result, "\t\tstatement-list: null\n", preWhiteSpace.c_str());
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
        default:
            break;
        }
    }
    else
    {
        switch (t->kind.exp)
        {
        case AssignK:
            fprintf(result, "%sassignment: \n%s\tvarName: %s\n%s\texpression: \n", preWhiteSpace.c_str(), preWhiteSpace.c_str(), t->nodeChild[0]->attr.name.c_str(), preWhiteSpace.c_str());
            printNode(t->nodeChild[1], level + 1);
            break;
        case IdK:
            fprintf(result, "%svar: \n%s\tname: %s\n", preWhiteSpace.c_str(), preWhiteSpace.c_str(), t->attr.name.c_str());
            break;
        case IndexK:
            fprintf(result, "%sarrayIndex: \n%s\tname: %s\n%s\tindex: \n", preWhiteSpace.c_str(), preWhiteSpace.c_str(), t->attr.name.c_str(), preWhiteSpace.c_str());
            printNode(t->nodeChild[0], level + 1);
            break;
        case ArrayptrK:
            fprintf(result, "%sarrayPtr: \n%s\tname: %s\n", preWhiteSpace.c_str(), preWhiteSpace.c_str(), t->attr.name.c_str());
            break;
        case ArrayK:
            fprintf(result, "%svarArray: \n%s\tname: %s\n%s\tlength: %d\n", preWhiteSpace.c_str(),
                    preWhiteSpace.c_str(), t->attr.name, preWhiteSpace.c_str(), t->nodeChild[0]->attr.val);
            break;
        case ConstK:
            fprintf(result, "%sconst: \n%s\tval: %d\n", preWhiteSpace.c_str(), preWhiteSpace.c_str(), t->attr.val);
            break;
        case OpK:
            fprintf(result, "%ssimple-expression: \n", preWhiteSpace.c_str(), preWhiteSpace.c_str());
            if (t->nodeChild[1] == nullptr)
            {
                printNode(t->nodeChild[0], level + 1);
            }
            else
            {
                fprintf(result, "%s\tfirst:\n", preWhiteSpace.c_str());
                printNode(t->nodeChild[0], level + 2);
                fprintf(result, "%s\top: %s\n", preWhiteSpace.c_str(), t->attr.op.c_str());
                fprintf(result, "%s\tsecond:\n", preWhiteSpace.c_str());
                printNode(t->nodeChild[1], level + 2);
            }
            break;

        case AddK:
            fprintf(result, "%sadditive-expression: \n", preWhiteSpace.c_str(), preWhiteSpace.c_str());
            fprintf(result, "%s\tfirst:\n", preWhiteSpace.c_str());
            printNode(t->nodeChild[0], level + 2);
            fprintf(result, "%s\top: %s\n", preWhiteSpace.c_str(), t->attr.op.c_str());
            fprintf(result, "%s\tsecond:\n", preWhiteSpace.c_str());
            printNode(t->nodeChild[1], level + 2);
            break;
        case MulK:
            fprintf(result, "%sterm: \n", preWhiteSpace.c_str(), preWhiteSpace.c_str());
            fprintf(result, "%s\tfirst:\n", preWhiteSpace.c_str());
            printNode(t->nodeChild[0], level + 2);
            fprintf(result, "%s\top: %s\n", preWhiteSpace.c_str(), t->attr.op.c_str());
            fprintf(result, "%s\tsecond:\n", preWhiteSpace.c_str());
            printNode(t->nodeChild[1], level + 2);
            break;
        case CallK:
            fprintf(result, "%sfunctionCall: \n", preWhiteSpace.c_str(), preWhiteSpace.c_str());
            fprintf(result, "%s\tname: %s\n", preWhiteSpace.c_str(), t->attr.name.c_str());
            if (t->listChild[0] != nullptr)
            {
                fprintf(result, "%s\targs: \n", preWhiteSpace.c_str());
                printNode(t->listChild[0], level + 2);
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