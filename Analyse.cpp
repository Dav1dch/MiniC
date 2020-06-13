#include"Analyse.h"
#include"Symtab.h"

static int location = 0;

static void traverse(node* t, void(*preProc) (node*), void(*postProc) (node*)) {
	if (t != NULL) {
		preProc(t);
		{
			for (int i = 0; i < MAXCHILDREN; i++) {
				traverse(t->nodeChild[i], preProc, postProc);
			}
		}
		postProc(t);
		traverse(t->next, preProc, postProc);
	}

}


static void nullProc(node* t) {
	if (t == NULL) {
		return;
	}
	else return;
}





static void insertNode(node* t) {
	switch (t->nodekind) {
	case ExpK:
		switch (t->kind.exp) {
		case IdK:
		case AssignK:
			if (st_lookup(t->name) == -1) {
				st_insert(t->name, t->lineno, location++);
			}
			else {
				st_insert(t->name, t->lineno, 0);
			}
			break;
		default:
			break;
		}
	default:
		break;
	}
}


void buildSymtab(node* syntaxTree) {
	traverse(syntaxTree, insertNode, nullProc);

}


static void typeError(node* t, char* message) {
	//
}


// 类型检查错误
static void checkNode(node* t) {
	// switch (t->nodekind)
	// {
	// case ExpK:
	// 	switch (t->kind.exp)
	// 	{
	// 	case OpK:
	// 		if(t->nodeChild[0]->)
	// 	default:
	// 		break;
	// 	}
	// default:
	// 	break;
	// }
}



void typeCheck(node* syntaxTree) {
	traverse(syntaxTree, nullProc, checkNode);
}