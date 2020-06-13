#pragma once
#include"main.h"

void buildSymtab(node*);

/* Procedure typeCheck performs type checking
 * by a postorder syntax tree traversal
 */
void typeCheck(node*);