/*
 * @Copyright: minic
 * @Author: David.Huangjunlang 
 * @Description: 中间代码生成：实现中间代码的生成函数
 * @LastEditors: linmaosen
 * @LastEditTime: 2020-06-14
 * @FilePath: /minic/cGen.cpp
 */

#include "Cgen.h"
#include "Code.h"
#include "symtab.h"

// 记录输出
int TraceCode = 1;

static int main_locals = 0;

/*
  1 表示存储值
  0 表示存储地址
*/
static int getValue = 1;

/* prototype for internal recursive code generator */
static void cGen(node *tree);

static int tmp;

/*
1 表示会递归
0 表示不递归
*/
static int isRecursive = 1;
node *paramStack[10];
int top = 0;

/**
 * @description: 函数方法入栈
 * @param {node*} 
 * @return: int
 */
int pushParam(node *param)
{
    if (top == SIZE)
        return 1;

    paramStack[top++] = param;
    return 0;
}

/**
 * @description: 栈顶出栈，并返回栈顶
 * @param {} 
 * @return: node*
 */
node *popParam()
{
    if (top == 0)
        return NULL;

    return paramStack[--top];
}

/**
 * @description: 获取变量的地址
 * @param {node*} 
 * @return: void
 */
void emitGetAddr(node *var)
{
    BucketList v = var_lookup(var->name, var->scope);

    switch (var->scope)
    {
    case 0: // 全局的变量
        if (v->isArray)
        {
            emitRM("LDA", bx, -(st_lookup(var->name, 0)), gp, "get global array address");
        }
        else
        {
            emitRM("LDA", bx, -1 - (st_lookup(var->name, 0)), gp, "get global address");
        }
        break;
    case 1:
    case 2:
    case 3:
    case 4:
    case 5:
        if (var_lookup(var->name, var->scope)->isParam)
        {
            if (v->isArray)
            {
                emitRM("LD", bx, 2 + (st_lookup(var->name, var->scope)), bp, "get param array address");
            }
            else
            {
                emitRM("LDA", bx, 2 + (st_lookup(var->name, var->scope)), bp, "get param variable address");
            }
        }
        else
        {
            if (v->isArray)
            {
                emitRM("LDA", bx, -(st_lookup(var->name, var->scope)), bp, "get local array address");
            }
            else
            {
                emitRM("LDA", bx, -1 - (st_lookup(var->name, var->scope)), bp, "get local address");
            }
        }
        break;
    }
}

/**
 * @description: 对stmt结点进行中间代码生成
 * @param {node*} 
 * @return: void
 */
static void genStmt(node *tree)
{
    BucketList fun;
    node *p1, *p2, *p3;
    int savedLoc1, savedLoc2, currentLoc;
    switch (tree->kind.stmt)
    {
    case CallK:
        if (TraceCode)
            emitComment("-> call");
        p1 = tree->nodeChild[0]; // 参数
        if (p1 != NULL)
        {
            p1 = p1->next;
        }
        while (p1 != NULL)
        {
            pushParam(p1);
            p1 = p1->next;
        }

        isRecursive = 0;
        while ((p1 = popParam()) != NULL)
        {
            cGen(p1);
            emitRM("LDA", sp, -1, sp, "push prepare");
            emitRM("ST", ax, 0, sp, "push parameters");
        }
        isRecursive = 1;

        fun = fun_lookup(tree->name, 0);

        emitRM("LDA", ax, 3, pc, "store returned PC");
        emitRM("LDA", sp, -1, sp, "push prepare");
        emitRM("ST", ax, 0, sp, "push returned PC");
        emitRM("LDC", pc, fun->fun_start, 0, "jump to function");
        emitRM("LDA", sp, (tree->nodeChild[0]) != NULL ? (tree->nodeChild[0])->param_size : 0, sp, "release parameters");

        if (TraceCode)
            emitComment("<- call");
        break;
    case FunK:
        if (tree->name == "main")
            main_locals = tree->nodeChild[1]->param_size;
        if (TraceCode)
            emitComment("-> function:");

        p1 = tree->nodeChild[0]; // 参数
        p2 = tree->nodeChild[1]; // 方法体

        fun = fun_lookup(tree->name, 0);
        fun->fun_start = emitSkip(0);

        emitRM("LDA", sp, -1, sp, "push prepare");
        emitRM("ST", bp, 0, sp, "push old bp");
        emitRM("LDA", bp, 0, sp, "let bp == sp");
        emitRM("LDA", sp, -tree->local_size, sp, "allocate for local variables");

        cGen(p2);

        if (tree->type == 0)
        {
            // return
            emitRM("LDA", sp, 0, bp, "let sp == bp");
            emitRM("LDA", sp, 2, sp, "pop prepare");
            emitRM("LD", bp, -2, sp, "pop old bp");
            emitRM("LD", pc, -1, sp, "pop return addr");
        }

        if (TraceCode)
            emitComment("<- function");

        break;
    case ArrayK:
        if (tree->isGlobal != 1)
        {
            if (TraceCode)
                emitComment("-> array element");
            p1 = tree->nodeChild[0];

            emitGetAddr(tree);
            emitRM("LDA", sp, -1, sp, "push prepare");
            emitRM("ST", bx, 0, sp, "protect array address");

            tmp = getValue;
            getValue = 1;
            cGen(p1);
            getValue = tmp;

            emitRM("LDA", sp, 1, sp, "pop prepare");
            emitRM("LD", bx, -1, sp, "recover array address");

            emitRO("SUB", bx, bx, ax, "get address of array element");
            if (getValue)
                emitRM("LD", ax, 0, bx, "get value of array element");

            if (TraceCode)
                emitComment("<- array element");

        }
            break;
    case SelectK:
        if (TraceCode)
            emitComment("-> if");
        p1 = tree->nodeChild[0];
        p2 = tree->nodeChild[1];
        p3 = tree->nodeChild[2];

        cGen(p1);
        savedLoc1 = emitSkip(1);
        emitComment("if: jump to else belongs here");

        cGen(p2);
        savedLoc2 = emitSkip(1);
        emitComment("if: jump to end belongs here");
        currentLoc = emitSkip(0);
        emitBackup(savedLoc1);
        emitRM("JEQ", ax, currentLoc, zero,"if: jmp to else");
        emitRestore();
        // else
        cGen(p3);
        currentLoc = emitSkip(0);
        emitBackup(savedLoc2);
        emitRM("LDA", pc, currentLoc, zero,"jmp to end");
        emitRestore();
        if (TraceCode)
            emitComment("<- if");
        break;

    case IteraK:
        if (TraceCode)
            emitComment("-> while");
        p1 = tree->nodeChild[0];
        p2 = tree->nodeChild[1];
        savedLoc1 = emitSkip(0);
        emitComment("jump here after body");

        cGen(p1);
        savedLoc2 = emitSkip(1);
        emitComment("jump to end if test fails");

        cGen(p2);
        emitRM("LDA", pc, savedLoc1, zero, "jump to test");
        currentLoc = emitSkip(0);
        emitBackup(savedLoc2);
        emitRM("JEQ", ax, currentLoc, zero, "jump to end");
        emitRestore();
        if (TraceCode)
            emitComment("<- while");
        break;

    case ReturnK:
        if (TraceCode)
            emitComment("-> return");
        p1 = tree->nodeChild[0];

        if (p1 != NULL)
            cGen(p1);

        // return
        emitRM("LDA", sp, 0, bp, "let sp == bp");
        emitRM("LDA", sp, 2, sp, "pop prepare");
        emitRM("LD", bp, -2, sp, "pop old bp");
        emitRM("LD", pc, -1, sp, "pop return addr");

        if (TraceCode)
            emitComment("<- return");
        break;

    case CompK:
        if (TraceCode)
            emitComment("-> compound");
        p1 = tree->nodeChild[1];

        cGen(p1);

        if (TraceCode)
            emitComment("<- compound");
        break;
    default:
        break;
    }
}

/**
 * @description: 对exp结点进行中间代码生成
 * @param {node*} 
 * @return: void
 */
static void genExp(node *tree)
{
    node *p1, *p2;
    BucketList fun;
    switch (tree->kind.exp)
    {

    case AssignK:
        if (TraceCode)
            emitComment("-> assign");
        p1 = tree->nodeChild[0];
        p2 = tree->nodeChild[1];

        getValue = 0;
        cGen(p1);

        emitRM("LDA", sp, -1, sp, "push prepare");
        emitRM("ST", bx, 0, sp, "protect bx");

        getValue = 1;
        cGen(p2);

        emitRM("LDA", sp, 1, sp, "pop prepare");
        emitRM("LD", bx, -1, sp, "recover bx");
        // 赋值
        emitRM("ST", ax, 0, bx, "assign: store");
        if (TraceCode)
            emitComment("<- assign");
        break;

    case ConstK:
        if (TraceCode)
            emitComment("-> Const");

        emitRM("LDC", ax, tree->val, 0, "load const");
        if (TraceCode)
            emitComment("<- Const");
        break;

    case IdK:
    {
 if (TraceCode)
            emitComment("-> Id");

        emitGetAddr(tree);
        BucketList v = var_lookup(tree->name, tree->scope);

        if (getValue)
        {
            if (v->isArray)
                emitRM("LDA", ax, 0, bx, "get array variable value");
            else
                emitRM("LD", ax, 0, bx, "get variable value");
        }
        if (TraceCode)
            emitComment("<- Id");


    }
               break;

    case OpK:
        if (TraceCode)
            emitComment("-> Op");
        p1 = tree->nodeChild[0];
        p2 = tree->nodeChild[1];

        cGen(p1);

        emitRM("LDA", sp, -1, sp, "push prepare");
        emitRM("ST", ax, 0, sp, "op: protect left");

        cGen(p2);

        emitRM("LDA", sp, 1, sp, "pop prepare");
        emitRM("LD", bx, -1, sp, "op: recover left");

        switch (tree->type)
        {
        case 2:
            emitRO("ADD", ax, bx, ax, "op +");
            break;
        case 3:
            emitRO("SUB", ax, bx, ax, "op -");
            break;
        case 4:
            emitRO("MUL", ax, bx, ax, "op *");
            break;
        case 5:
            emitRO("DIV", ax, bx, ax, "op /");
            break;
        case 6:
            emitRO("SUB", ax, bx, ax, "op <");
            emitRM("JLT", ax, 2, pc, "br if true");
            emitRM("LDC", ax, 0, 0, "false case");
            emitRM("LDA", pc, 1, pc, "unconditional jmp");
            emitRM("LDC", ax, 1, 0, "true case");
            break;
        case 7:
            emitRO("SUB", ax, bx, ax, "op ==");
            emitRM("JEQ", ax, 2, pc, "br if true");
            emitRM("LDC", ax, 0, 0, "false case");
            emitRM("LDA", pc, 1, pc, "unconditional jmp");
            emitRM("LDC", ax, 1, 0, "true case");
            break;
        case 8:
            emitRO("SUB", ax, bx, ax, "op <=");
            emitRM("JLE", ax, 2, pc, "br if true");
            emitRM("LDC", ax, 0, 0, "false case");
            emitRM("LDA", pc, 1, pc, "unconditional jmp");
            emitRM("LDC", ax, 1, 0, "true case");
            break;
        case 9:
            emitRO("SUB", ax, bx, ax, "op >");
            emitRM("JGT", ax, 2, pc, "br if true");
            emitRM("LDC", ax, 0, 0, "false case");
            emitRM("LDA", pc, 1, pc, "unconditional jmp");
            emitRM("LDC", ax, 1, 0, "true case");
            break;
        case 10:
            emitRO("SUB", ax, bx, ax, "op >=");
            emitRM("JGE", ax, 2, pc, "br if true");
            emitRM("LDC", ax, 0, 0, "false case");
            emitRM("LDA", pc, 1, pc, "unconditional jmp");
            emitRM("LDC", ax, 1, 0, "true case");
            break;
        case 11:
            emitRO("SUB", ax, bx, ax, "op !=");
            emitRM("JNE", ax, 2, pc, "br if true");
            emitRM("LDC", ax, 0, 0, "false case");
            emitRM("LDA", pc, 1, pc, "unconditional jmp");
            emitRM("LDC", ax, 1, 0, "true case");
            break;
        default:
            emitComment("BUG: Unknown operator");
            break;
        }
        if (TraceCode)
            emitComment("<- Op");
        break;

    default:
        break;
    }
}

/**
 * @description: 分别对stmt和exp结点进行中间代码生成
 * @param {node*} 
 * @return: void
 */
static void cGen(node *tree)
{
    if (tree != NULL)
    {
        switch (tree->nodekind)
        {
        case StmtK:
            genStmt(tree);
            break;
        case ExpK:
            genExp(tree);
            break;
        // case DecK:
        // genDec(tree);
        default:
            break;
        }
        if (isRecursive)
            cGen(tree->next);
    }
}

/**
 * @description: 对语法树结点生成中间代码
 * @param {node*} 
 * @return: void
 */
void codeGen(node *syntaxTree)
{
    BucketList fun;

    emitComment("miniC- Compilation to MC Code");
    emitComment("Standard prelude:");
    emitRM("LD", gp, 0, zero, "load maxaddress from location 0");
    emitRM("ST", zero, 0, zero, "clear location 0");
    emitRM("LDA", sp, syntaxTree->kind.stmt != FunK ? -(syntaxTree->local_size) : 0, gp, "copy gp to sp & allocating global variables(if any)");
    emitComment("End of standard prelude.");

    // 找main方法
    if (TraceCode)
        emitComment("Jump to main()");
    int loc = emitSkip(6);

    // input output方法
    fun = fun_lookup("input", 0);
    if (fun != NULL)
    {
        if (TraceCode)
            emitComment("Begin input()");
        fun->fun_start = emitSkip(0);
        emitRO("IN", ax, 0, 0, "read input into ax");
        emitRM("LDA", sp, 1, sp, "pop prepare");
        emitRM("LD", pc, -1, sp, "pop return addr");
        if (TraceCode)
            emitComment("End input()");
    }

    fun = fun_lookup("output", 0);
    if (fun != NULL)
    {
        if (TraceCode)
            emitComment("Begin output()");
        fun->fun_start = emitSkip(0);
        emitRM("LD", ax, 1, sp, "load param into ax");
        emitRO("OUT", ax, 0, 0, "output using ax");
        emitRM("LDA", sp, 1, sp, "pop prepare");
        emitRM("LD", pc, -1, sp, "pop return addr");
        if (TraceCode)
            emitComment("End output()");
    }

    cGen(syntaxTree);

    emitBackup(loc);
    fun = fun_lookup("main", 0);
    if (fun == NULL)
    {
        fprintf(stderr, "main not found\n");
    }

    emitRM("LDA", ax, 3, pc, "store returned PC");
    emitRM("LDA", sp, -1, sp, "push prepare");
    emitRM("ST", ax, 0, sp, "push returned PC");
    emitRM("LDC", pc, fun->fun_start, 0, "jump to function");
    emitRM("LDA", sp, main_locals, sp, "release local var");

    emitComment("End of execution.");
    emitRO("HALT", 0, 0, 0, "");
}
