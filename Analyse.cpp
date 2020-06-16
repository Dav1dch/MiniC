#include "Analyse.h"
#include "Symtab.h"

// static int location = 0;

// static void traverse(node* t, void(*preProc) (node*), void(*postProc) (node*)) {
// 	if (t != NULL) {
// 		preProc(t);
// 		{
// 			for (int i = 0; i < MAXCHILDREN; i++) {
// 				traverse(t->nodeChild[i], preProc, postProc);
// 			}
// 		}
// 		postProc(t);
// 		traverse(t->next, preProc, postProc);
// 	}

// }

// static void nullProc(node* t) {
// 	if (t == NULL) {
// 		return;
// 	}
// 	else return;
// }

// static void insertNode(node* t) {
// 	switch (t->nodekind) {
// 	case ExpK:
// 		switch (t->kind.exp) {
// 		case IdK:
// 		case AssignK:
// 			if (st_lookup(t->name) == -1) {
// 				st_insert(t->name, t->lineno, location++);
// 			}
// 			else {
// 				st_insert(t->name, t->lineno, 0);
// 			}
// 			break;
// 		default:
// 			break;
// 		}
// 	default:
// 		break;
// 	}
// }

// void buildSymtab(node* syntaxTree) {
// 	traverse(syntaxTree, insertNode, nullProc);

// }

// static void typeError(node* t, char* message) {
// 	//
// }

// // 类型检查错误
// static void checkNode(node* t) {
// 	// switch (t->nodekind)
// 	// {
// 	// case ExpK:
// 	// 	switch (t->kind.exp)
// 	// 	{
// 	// 	case OpK:
// 	// 		if(t->nodeChild[0]->)
// 	// 	default:
// 	// 		break;
// 	// 	}
// 	// default:
// 	// 	break;
// 	// }
// }

// void typeCheck(node* syntaxTree) {
// 	traverse(syntaxTree, nullProc, checkNode);
// }

extern int HighScope;

static int scope_a = 0;
/* counter for variable memory locations */
static int location[MAX_SCOPE] = {0, 0, 0};

static int No_change = 0;
/* Procedure traverse is a generic recursive 
 * syntax tree traversal routine:
 * it applies preProc in preorder and postProc 
 * in postorder to tree pointed to by t
 */
static void traverse(node *t,
                     void (*preProc)(node *),
                     void (*postProc)(node *))
{
  if (t != NULL)
  {
    preProc(t);
    {
      int i;
      for (i = 0; i < MAXCHILDREN; i++)
        traverse(t->nodeChild[i], preProc, postProc);
    }
    postProc(t);
    traverse(t->next, preProc, postProc);
  }
}

/* nullProc is a do-nothing procedure to 
 * generate preorder-only or postorder-only
 * traversals from traverse
 */
static void nullProc(node *t)
{
  if (t == NULL)
    return;
  else
    return;
}

/* Procedure insertNode inserts 
 * identifiers stored in t into 
 * the symbol table 
 */
static void insertNode(node *t)
{
  switch (t->nodekind)
  {
  case StmtK:
    switch (t->kind.stmt)
    {
    case FunK:
      t->scope = 0; /* to parse tree */
                    /* all functios are global so searching in global scope */
      if (st_lookup(t->name, 0) == -1)
        /* not yet in table, so treat as new definition */
        st_insert(t->name, t->lineno, -1, 0, 0);
      else
        /* already in table, so ignore location, 
             add line number of use only */
        st_insert(t->name, t->lineno, -1, 0, 0);
      break;
    case CompK:
    {
      if (!No_change)
      {
        scope_a = scope_a + 1;
      }
      else
      {
        No_change = 0;
      }
      HighScope = scope_a;
      break;
    }
    case SelectK:
      if ((t->nodeChild[1])->kind.stmt == CompK)
        No_change = 1;
      break;
    case IteraK:
      if ((t->nodeChild[1])->kind.stmt == CompK)
        No_change = 1;
      break;
    case VarK:
      t->scope = t->isParameter == 1 ? scope_a + 1 : scope_a;
      if (st_lookup(t->name, t->isParameter == 1 ? scope_a + 1 : scope_a) == -1)
        /* not yet in table, so treat as new definition */
        st_insert(t->name, t->lineno, location[scope_a]++, t->isParameter == 1 ? scope_a + 1 : scope_a, t->isParameter == 1 ? 1 : 0);
      else
        /* already in table, so ignore location, 
             add line number of use only */
        st_insert(t->name, t->lineno, 0, t->isParameter == 1 ? scope_a + 1 : scope_a, t->isParameter == 1 ? 1 : 0);
      break;
    case ArrayK:
      if (t->isParameter)
      {
        t->scope = scope_a + 1;
        if (st_lookup(t->name, scope_a + 1) == -1)
          /* not yet in table, so treat as new definition */
          st_insert(t->name, t->lineno, location[scope_a + 1]++, scope_a + 1, 1);
        else
          /* already in table, so ignore location, 
             	add line number of use only */
          st_insert(t->name, t->lineno, 0, scope_a + 1, 1);
      }
      else
      {
        if (st_lookup(t->name, 0) == -1)
        {
          t->scope = scope_a; /* if not in global */
        }
        else
        {
          t->scope = 0; /* in global already do not insert to symbol*/
          break;
        }

        if (st_lookup(t->name, scope_a) == -1)
        {
          /* not yet in table, so treat as new definition */
          st_insert(t->name, t->lineno, location[scope_a]++, scope_a, t->isParameter == 1 ? 1 : 0);
          if (t->isParameter != 1)
            location[scope_a] = location[scope_a] + (t->val - 1);
        }
        else
          /* already in table, so ignore location, 
          	   add line number of use only */
          st_insert(t->name, t->lineno, 0, t->isParameter == 1 ? scope_a + 1 : scope_a, t->isParameter == 1 ? 1 : 0);
      }
      break;
    case CallK:
      // printf("%d %s\n",t->param_size,t->attr.name);
      t->scope = 0;
      /* all functios are global so searching in global scope */
      if (st_lookup(t->name, 0) == -1)
        /* not yet in table, so treat as new definition */
        st_insert(t->name, t->lineno, -1, 0, 0);
      else
        /* already in table, so ignore location, 
             add line number of use only */
        st_insert(t->name, t->lineno, -1, 0, 0);
      break;

    default:
      break;
    }
    break;
  case ExpK:
    switch (t->kind.exp)
    {
    case IdK:
      if (st_lookup(t->name, 0) == -1)
        t->scope = t->isParameter == 1 ? scope_a + 1 : scope_a;
      else
        t->scope = 0;
      /* all identifiers must be declared before use execpt parameter so we insert just parameters to symbol table*/
      if (t->isParameter == 1)
      {
        t->scope = t->isParameter == 1 ? scope_a + 1 : scope_a;
        if (st_lookup(t->name, t->isParameter == 1 ? scope_a + 1 : scope_a) == -1)
          /* not yet in table, so treat as new definition */
          st_insert(t->name, t->lineno, location[scope_a]++, t->isParameter == 1 ? scope_a + 1 : scope_a, t->isParameter == 1 ? 1 : 0);
        else
          /* already in table, so ignore location, 
             	add line number of use only */
          st_insert(t->name, t->lineno, 0, t->isParameter == 1 ? scope_a + 1 : scope_a, t->isParameter == 1 ? 1 : 0);
      }
      break;
    default:
      break;
    }
    break;
  default:
    break;
  }
}

/* Function buildSymtab constructs the symbol 
 * table by preorder traversal of the syntax tree
 */
void buildSymtab(node *syntaxTree)
{
  traverse(syntaxTree, insertNode, nullProc);
}

static void typeError(node *t, char *message)
{
}

/* Procedure checkNode performs
 * type checking at a single tree node
 */
static void checkNode(node *t)
{
}

/* Procedure typeCheck performs type checking 
 * by a postorder syntax tree traversal
 */
void typeCheck(node *syntaxTree)
{
  traverse(syntaxTree, nullProc, checkNode);
}
