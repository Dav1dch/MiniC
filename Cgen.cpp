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


/*
函数调用的数组
*/
node *paramStack[10];
int top = 0;

/*
函数入栈
*/
int pushParam(node *param)
{
  if (top == SIZE)
    return 1;

  paramStack[top++] = param;
  return 0;
}

/*
栈顶出栈
*/
node *popParam()
{
  if (top == 0)
    return NULL;

  return paramStack[--top];
}

/*
获取变量的地址
*/
void emitGetAddr(node *var)
{

  switch (var->scope)
  {
  case 0:  // 全局的变量
    if (var->isArray)
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
      if (var->isArray)
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
      if (var->isArray)
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

/* 
针对函数、变量以及数组的定义
 */
static void genDec(node *tree)
{
  int loc;
  BucketList fun;
  node *p1, *p2;
  switch (tree->kind.exp)
  {

  case FunK:
    if (tree->name == "main")
      main_locals = tree->nodeChild[1]->local_size;
    if (TraceCode)
      emitComment("-> function:");

    p1 = tree->nodeChild[0]->next; // 参数
    p2 = tree->nodeChild[1];       // 方法体

    fun = fun_lookup(tree->name, 0);
    fun->fun_start = emitSkip(0);

    emitRM("LDA", sp, -1, sp, "push prepare");
    emitRM("ST", bp, 0, sp, "push old bp");
    emitRM("LDA", bp, 0, sp, "let bp == sp");
    emitRM("LDA", sp, p2->nodeChild[0] != NULL ? -((p2->nodeChild[0])->local_size) : 0, sp, "allocate for local variables");


    cGen(p2);

    if (tree->type == 0)
    {
      /*return*/
      emitRM("LDA", sp, 0, bp, "let sp == bp");
      emitRM("LDA", sp, 2, sp, "pop prepare");
      emitRM("LD", bp, -2, sp, "pop old bp");
      emitRM("LD", pc, -1, sp, "pop return addr");
    }

    if (TraceCode)
      emitComment("<- function");

    break;
  case VarK:
    /* if(TraceCode) emitComment("-> variable");
  	     emitGetAddr(tree);

             if(getValue){
              if(tree->isArray)
               emitRM("LDA",ax,0,bx,"get array variable value( == address)");
             else
                emitRM("LD",ax,0,bx,"get variable value");

             }
             if(TraceCode) emitComment("<- variable");
            */
    break;
  case ArrayK:

    if (tree->isGlobal)
    {
      if (TraceCode)
        emitComment("-> array element");
      p1 = tree->nodeChild[0]; /*index expression*/

      emitGetAddr(tree);

      emitRM("LDA", sp, -1, sp, "push prepare");
      emitRM("ST", bx, 0, sp, "protect array address");

      tmp = getValue;
      getValue = 1;
      cGen(p1);
      getValue = tmp;

      /* recover bx*/
      emitRM("LDA", sp, 1, sp, "pop prepare");
      emitRM("LD", bx, -1, sp, "recover array address");

      emitRO("SUB", bx, bx, ax, "get address of array element");
      if (getValue)
        emitRM("LD", ax, 0, bx, "get value of array element");

      if (TraceCode)
        emitComment("<- array element");
    }
    break; 

  default:
    emitComment("BUG: Unknown declaration");
    break;
  }
} 

/*
针对 stmt结点 
 */
static void genStmt(node *tree)
{
  BucketList fun;
  node *p1, *p2, *p3;
  int savedLoc1, savedLoc2, currentLoc;
  //int loc;
  switch (tree->kind.stmt)
  {
  case CallK:
    if (TraceCode)
      emitComment("-> call");
    p1 = tree->nodeChild[0]; /*arguments*/
    if (p1 != NULL) {
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
    /* emitCall(fun); */
    emitRM("LDA", ax, 3, pc, "store returned PC");
    emitRM("LDA", sp, -1, sp, "push prepare");
    emitRM("ST", ax, 0, sp, "push returned PC");
    emitRM("LDC", pc, fun->fun_start, 0, "jump to function");
    emitRM("LDA", sp, (tree->nodeChild[0]) != NULL ? (tree->nodeChild[0])->param_size : 0, sp, "release parameters");
    //	printf("%d %s\n",(tree->nodeChild[0])!=NULL?(tree->nodeChild[0])->param_size:0,tree->name);

    if (TraceCode)
      emitComment("<- call");
    break;
  case FunK:
    if (tree->name == "main")
      main_locals = tree->nodeChild[1]->local_size;
    if (TraceCode)
      emitComment("-> function:");

    p1 = tree->nodeChild[0]; /*parameter*/
    p2 = tree->nodeChild[1]; /*body*/

    fun = fun_lookup(tree->name, 0);
    fun->fun_start = emitSkip(0);

    /*prepare bp & sp*/
    emitRM("LDA", sp, -1, sp, "push prepare");
    emitRM("ST", bp, 0, sp, "push old bp");
    emitRM("LDA", bp, 0, sp, "let bp == sp");
    emitRM("LDA", sp, p2->nodeChild[0] != NULL ? -((p2->nodeChild[0])->local_size) : 0, sp, "allocate for local variables");

    /*generate body*/
    cGen(p2);
    //  popTable();

    /*generate return code for void functions*/
    if (tree->type == 0)
    {
      /*return*/
      emitRM("LDA", sp, 0, bp, "let sp == bp");
      emitRM("LDA", sp, 2, sp, "pop prepare");
      emitRM("LD", bp, -2, sp, "pop old bp");
      emitRM("LD", pc, -1, sp, "pop return addr");
    }

    if (TraceCode)
      emitComment("<- function");

    break;
  case VarK:
    /* if(TraceCode) emitComment("-> variable");
  	     emitGetAddr(tree);

             if(getValue){
              if(tree->isArray)
               emitRM("LDA",ax,0,bx,"get array variable value( == address)");
             else
                emitRM("LD",ax,0,bx,"get variable value");

             }
             if(TraceCode) emitComment("<- variable");
            */
    break;
  case ArrayK:

    if (tree->isGlobal)
    {
      if (TraceCode)
        emitComment("-> array element");
      p1 = tree->nodeChild[0]; /*index expression*/

      //  var = lookup_var(tree->name);
      emitGetAddr(tree);

      /* protect bx*/
      emitRM("LDA", sp, -1, sp, "push prepare");
      emitRM("ST", bx, 0, sp, "protect array address");

      tmp = getValue;
      getValue = 1;
      cGen(p1);
      getValue = tmp;

      /* recover bx*/
      emitRM("LDA", sp, 1, sp, "pop prepare");
      emitRM("LD", bx, -1, sp, "recover array address");

      emitRO("SUB", bx, bx, ax, "get address of array element");
      if (getValue)
        emitRM("LD", ax, 0, bx, "get value of array element");

      if (TraceCode)
        emitComment("<- array element");
    }
    break; /* ArrayK */

  case SelectK:
    if (TraceCode)
      emitComment("-> if");
    p1 = tree->nodeChild[0];
    p2 = tree->nodeChild[1];
    p3 = tree->nodeChild[2];
    /* generate code for test expression */
    cGen(p1);
    savedLoc1 = emitSkip(1);
    emitComment("if: jump to else belongs here");
    /* recurse on then part */
    cGen(p2);
    savedLoc2 = emitSkip(1);
    emitComment("if: jump to end belongs here");
    currentLoc = emitSkip(0);
    emitBackup(savedLoc1);
    emitRM_Abs("JEQ", ax, currentLoc, "if: jmp to else");
    emitRestore();
    /* recurse on else part */
    cGen(p3);
    currentLoc = emitSkip(0);
    emitBackup(savedLoc2);
    emitRM_Abs("LDA", pc, currentLoc, "jmp to end");
    emitRestore();
    if (TraceCode)
      emitComment("<- if");
    break; 

  case IteraK:
    if (TraceCode)
      emitComment("-> while");
    p2 = tree->nodeChild[0];
    p1 = tree->nodeChild[1];
    savedLoc1 = emitSkip(0);
    emitComment("jump here after body");
    /* generate code for test */
    cGen(p1);
    savedLoc2 = emitSkip(1);
    emitComment("jump to end if test fails");
    /* generate code for body */
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
    /*Only calculate non-voild value*/
    if (p1 != NULL)
      cGen(p1);

    /*return*/
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
    p1 = tree->nodeChild[0]; /*local declarations*/
    p2 = tree->nodeChild[1]; /*statements */

    if (p1 != NULL)
      cGen(p1);
    if (p2 != NULL)
      cGen(p2);

    if (TraceCode)
      emitComment("<- compound");
    break;
  default:
    break;
  }
} /* genStmt */

/* Procedure genExp generates code at an expression node */
static void genExp(node *tree)
{ //int loc;
  node *p1, *p2;
  BucketList fun;
  switch (tree->kind.exp)
  {

  case AssignK:
    if (TraceCode)
      emitComment("-> assign");
    p1 = tree->nodeChild[0]; /*left*/
    p2 = tree->nodeChild[1]; /*right*/
    /* left value (get its address -> bx)*/
    getValue = 0;
    cGen(p1);
    /* protect bx*/
    emitRM("LDA", sp, -1, sp, "push prepare");
    emitRM("ST", bx, 0, sp, "protect bx");
    /* right value -> ax*/
    getValue = 1;
    cGen(p2);
    /* recover bx*/
    emitRM("LDA", sp, 1, sp, "pop prepare");
    emitRM("LD", bx, -1, sp, "recover bx");
    /* now we can assign*/
    emitRM("ST", ax, 0, bx, "assign: store");
    if (TraceCode)
      emitComment("<- assign");
    break;

  case ConstK:
    if (TraceCode)
      emitComment("-> Const");
    /* gen code to load integer constant using LDC */
    emitRM("LDC", ax, tree->val, 0, "load const");
    if (TraceCode)
      emitComment("<- Const");
    break; /* ConstK */

  case IdK:
    if (TraceCode)
      emitComment("-> Id");
    //loc = st_lookup(tree->name,tree->scope);
    emitGetAddr(tree);

    if (getValue)
    {
      if (tree->isArray)
        emitRM("LDA", bx, 0, bx, "get array variable value");
      else
        emitRM("LD", ax, 0, bx, "get variable value");
    }
    if (TraceCode)
      emitComment("<- Id");
    break; /* IdK */

  case OpK:
    if (TraceCode)
      emitComment("-> Op");
    p1 = tree->nodeChild[0];
    p2 = tree->nodeChild[1];
    /* gen code for ac = left arg */
    cGen(p1);
    /* gen code to push left operand */
    emitRM("LDA", sp, -1, sp, "push prepare");
    emitRM("ST", ax, 0, sp, "op: protect left");
    /* gen code for ac = right operand */
    cGen(p2);
    /* now load left operand */
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
    } /* case op */
    if (TraceCode)
      emitComment("<- Op");
    break; /* OpK */

  default:
    break;
  }
} /* genExp */


/*
生成中间代码
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


/*
递归生成中间代码
*/
void codeGen(node *syntaxTree)
{
  BucketList fun; /*function bucket */

  emitComment("miniC- Compilation to MC Code");
  /* generate standard prelude */
  emitComment("Standard prelude:");
  emitRM("LD", gp, 0, zero, "load maxaddress from location 0");
  emitRM("LDA", sp, syntaxTree->kind.stmt != FunK ? -(syntaxTree->param_size) : 0, gp, "copy gp to sp &allocating global variables(if any)");
  emitRM("ST", zero, 0, zero, "clear location 0");
  emitComment("End of standard prelude.");

  /*jump to main */
  if (TraceCode)
    emitComment("Jump to main()");
  int loc = emitSkip(6); /*A call consumes 5 instructions, and we need halt after main()*/

  /*defining Input & output fuction as if they were in-built(global) */
  /* if only necessary  i,e. if they are used in program */
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

  /* generate code for TINY program */
  cGen(syntaxTree);
  /* finish */

  /* Fill up jump-to-main code */
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
