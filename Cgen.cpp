#include"Cgen.h"
#include"Code.h"
#include"symtab.h"


static int tmpOffset = 0;

static void cGen(node * tree);


static void genStmt(node * tree){
    node *p1, *p2, *p3;
    int savedLoc1, savedLoc2, currentLoc;
    int loc;
    switch (tree->kind.stmt)
    {
    case SelectK:
        p1 = tree->nodeChild[0];
        p2 = tree->nodeChild[1];
        p3 = tree->nodeChild[2];
        cGen(p1);
        savedLoc1 = emitSkip(1);

        cGen(p2);
        savedLoc2 = emitSkip(1);

        currentLoc = emitSkip(0);
        emitBackup(savedLoc1);
        emitRM_Abs("JEQ", ac, currentLoc, "if: jmp to else");
        emitRestore();

        // else part
        cGen(p3);
        currentLoc = emitSkip(0);
        emitBackup(savedLoc2);
        emitRM_Abs("LDA", pc, currentLoc, "if: jum to end");
        emitRestore();
        break;
    case IteraK:
        p1 = tree->nodeChild[0];
        p2 = tree->nodeChild[1];
        savedLoc1 = emitSkip(0);
        cGen(p1);
        savedLoc2 = emitSkip(1);

        cGen(p2);
        currentLoc = emitSkip(0);
        emitRM_Abs("JEQ", ac, savedLoc1, "while: jum to body");
        emitRestore();
      
        emitBackup(savedLoc2);
        emitRM_Abs("LDA", pc, currentLoc, "while: jum to end");
        emitRestore();
        break;

    case DeclK:
        // 方法入口
        p1 = tree->nodeChild[0];
        p2 = tree->nodeChild[1];
        cGen(p2);
    default:
        break;
    }
}


static void genExp(node * tree){
    int loc;
    node *p1, *p2;
    switch (tree->kind.exp)
    {
    case ConstK:
        emitRM("LDC", ac, tree->val, 0, "load const");
        break;
    
    case IdK:
        loc = st_lookup(tree->name.data());
        emitRM("LD", ac, loc, gp, "load id value");
        break;

    case OpK:
        p1 = tree->nodeChild[0];
        p2 = tree->nodeChild[1];
        cGen(p1);
        emitRM("ST", ac, tmpOffset--, mp, "op: push left");
        cGen(p2);
        emitRM("LD", ac1, ++tmpOffset, mp, "op load left");
        if(tree->op == "+"){
            emitRO("ADD", ac, ac1, ac, "op +");
        }
        else if(tree->op == "-"){
            emitRO("SUB", ac, ac1, ac, "op -");
        }
        else if(tree->op == "*"){
            emitRO("MUL", ac, ac1, ac, "op *");
        }
        else if(tree->op == "/"){
            emitRO("DIV", ac, ac1, ac, "op /");
        }
        else if(tree->op == "<"){
            emitRO("SUB", ac, ac1, ac, "op <");
            emitRM("JLT", ac, 2, pc, "br if true");
            emitRM("LDC", ac, 0, ac, "false case");
            emitRM("LDA", pc, 1, pc, "unconditional jmp");
            emitRM("LDC", ac, 1, ac, "truecase");
        }
        else if(tree->op == "=="){
            emitRO("SUB",ac,ac1,ac,"op ==") ;
            emitRM("JEQ",ac,2,pc,"br if true");
            emitRM("LDC",ac,0,ac,"false case") ;
            emitRM("LDA",pc,1,pc,"unconditional jmp") ;
            emitRM("LDC",ac,1,ac,"true case") ;
        }
        break;
    case ReadK:
        emitRO("IN", ac, 0, 0, "read integer value");
        loc = st_lookup(tree->name.data());
        emitRM("ST", ac, loc, gp, "read: store value");
        break;
    case WriteK:
        cGen(tree->nodeChild[0]);
        emitRO("OUT", ac, 0, 0, "write ac");
        break;

    case AssignK:
        cGen(tree->nodeChild[0]);
        loc = st_lookup(tree->name.data());
        emitRM("ST", ac, loc, gp, "assign: store value");
        break;
    default:
        break;
    }
}




static void cGen(node * tree){
    if(tree != NULL){
        switch (tree->nodekind)
        {
        case StmtK:
            genStmt(tree);
            break;
        case ExpK:
            genExp(tree);
            break;
        default:
            break;
        }
        cGen(tree->next);
    }
}


void codeGen(node * syntaxTree, string codefile){
    char* s = (char*)malloc(codefile.length() + 7);
    strcpy(s, "File: ");
    strcat(s, codefile.c_str());
    emitComment("TINY Compilation to TM Code");
    emitComment(s);

    emitComment("Standard prelude:");
    emitRM("LD", mp, 0, ac, "load maxaddress from location 0");
    emitRM("ST", ac, 0, ac, "clear location 0");
    emitComment("End of standard prelude.");

    cGen(syntaxTree);

    emitComment("End of execution.");
    emitRO("HALT", 0, 0, 0, "");
}