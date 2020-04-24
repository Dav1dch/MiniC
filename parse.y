%{
    #include "main.h"
    #include "utils.h"
    extern node* programNode;
    extern "C"{
        int yywrap(void);
        int yylex(void);
        void yyerror(const char *s);
        extern int yylineno;
        extern char* yytext;
}
%}
%code requires{
}

%token <m_id> ID 
%token <m_num> NUM
%token <m_op> PLUS MINUS MULTI DIVIDE 
%token <m_op> LESS LESSEQUAL GREATER GREATEREQUAL EQUAL UNEQUAL
%token <m_op> ASSIGNMENT SEMICOLON COMMA 
%token <m_op> LEFTBRACKET RIGHTBRACKET LEFTSQUAREBRACKET RIGHTSQUAREBRACKET LEFTBRACE RIGHTBRACE
%token <m_reserved> ELSE IF INT VOID RETURN WHILE 

%type <m_node> declaration fun_declaration var_declaration param expression simple_expression additive_expression var term factor call program
%type <m_node> expression_stmt compound_stmt statement selection_stmt iteration_stmt return_stmt
%type <m_node> params local_declarations args
%type <m_node> statement_list param_list declaration_list 

%%

program : declaration_list {$$ = newStmtNode(ProgramK); $$->listChild[0] = $1;programNode = $$; programNode->attr.name = "helloworld";}
    ;

declaration_list : declaration_list declaration {addNode($1, $2);$$ = $1;}
    |   declaration {$$ = newStmtNode(DeclK); addNode($$, $1);}
    ;

declaration : var_declaration {$$ = $1;}
    | fun_declaration {$$ = $1;}
    ;

var_declaration : INT ID SEMICOLON{$$ = newExpNode(IdK); $$->attr.name = $2;}
    |   INT ID LEFTSQUAREBRACKET NUM RIGHTSQUAREBRACKET SEMICOLON {node *t = newExpNode(ConstK); t->attr.val = $4; $$ = newExpNode(ArrayK);$$->nodeChild[0] = t;}
    ;

fun_declaration : VOID ID LEFTBRACKET params RIGHTBRACKET compound_stmt{$$ = newStmtNode(VoidFundecK);
                                                                      $$->attr.name = $2; $$->listChild[0] = $4;
                                                                      $$->nodeChild[0] = $6;}
    |   INT ID LEFTBRACKET params RIGHTBRACKET compound_stmt{$$ = newStmtNode(IntFundecK);
                                                                      $$->attr.name = $2; $$->listChild[0] = $4;
                                                                      $$->nodeChild[0] = $6;}
 
    ;

params : param_list {$$ = $1;}
    |   VOID {$$ = nullptr;}
    ;

param_list : param_list COMMA param {addNode($1, $3); $$ = $1;}
    |   param {$$ = newStmtNode(ParamlK); addNode($$, $1);}
    ;

param : INT ID {$$ = newExpNode(IdK); $$->attr.name = $2;}
    |   INT ID LEFTSQUAREBRACKET RIGHTSQUAREBRACKET {$$ = newExpNode(ArrayptrK); $$->attr.name = $2;}
    ;

compound_stmt : LEFTBRACE local_declarations statement_list RIGHTBRACE {$$ = newStmtNode(CompK);
                                                                        $$->listChild[0] = $2;
                                                                        $$->listChild[1] = $3;}
    |   LEFTBRACE local_declarations RIGHTBRACE {$$ = newStmtNode(CompK); $$->listChild[0] = $2;}
    |   LEFTBRACE statement_list RIGHTBRACE {$$ = newStmtNode(CompK); $$->listChild[1] = $2;}
    ;

local_declarations : local_declarations var_declaration {addNode($1, $2); $$ = $1;}
    |   var_declaration {$$ = newStmtNode(LocdeclK); addNode($$, $1);}
    ;

statement_list : statement_list statement {addNode($1, $2); $$ = $1;}
    |   statement {$$ = newStmtNode(StmtlK); addNode($$, $1);}
    ;

statement : expression_stmt {$$ = $1;}
    |   selection_stmt {$$ = $1;}
    |   compound_stmt {$$ = $1;}
    |   iteration_stmt {$$ = $1;}
    |   return_stmt {$$ = $1;}
    ;

expression_stmt: expression SEMICOLON {$$ = newStmtNode(ExpressionK); $$->nodeChild[0] = $1;}
    |   SEMICOLON {$$ = newStmtNode(ExpressionK);}
    ;

selection_stmt : IF LEFTBRACKET expression RIGHTBRACKET statement {$$ = newStmtNode(SelectK); $$->nodeChild[0] = $3; $$->nodeChild[1] = $5;}
    |   IF LEFTBRACKET expression RIGHTBRACKET statement ELSE statement {$$ = newStmtNode(SelectK); $$->nodeChild[0] = $3; $$->nodeChild[1] = $5; $$->nodeChild[2] = $7;}
    ;

iteration_stmt : WHILE LEFTBRACKET expression RIGHTBRACKET statement {$$ = newStmtNode(IteraK); $$->nodeChild[0] = $3; $$->nodeChild[1] = $5;}
    ;

return_stmt : RETURN SEMICOLON {$$ = newStmtNode(ReturnK);}
    |   RETURN expression SEMICOLON {$$ = newStmtNode(ReturnK); $$->nodeChild[0] = $2;}
    ;

expression : var ASSIGNMENT expression {$$=newExpNode(AssignK); $$->nodeChild[0] = $1; $$->nodeChild[1] = $1;}
    |  simple_expression {$$ = $1;} 
    ;


var : ID {$$ = newExpNode(IdK); $$->attr.name = $1;}
    |   ID LEFTSQUAREBRACKET expression RIGHTSQUAREBRACKET {$$ = newExpNode(IndexK); $$->nodeChild[0] = $3;}
    ;

simple_expression : additive_expression LESSEQUAL additive_expression {$$ = newExpNode(OpK); $$->nodeChild[0] = $1; $$->nodeChild[1] = $3; $$->attr.op = $2;}
    |   additive_expression LESS additive_expression {$$ = newExpNode(OpK); $$->nodeChild[0]= $1; $$->nodeChild[1] = $3; $$->attr.op = $2;}
    |   additive_expression GREATER additive_expression {$$ = newExpNode(OpK); $$->nodeChild[0]= $1; $$->nodeChild[1] = $3; $$->attr.op = $2;}
    |   additive_expression GREATEREQUAL additive_expression {$$ = newExpNode(OpK); $$->nodeChild[0]= $1; $$->nodeChild[1] = $3; $$->attr.op = $2;}
    |   additive_expression EQUAL additive_expression {$$ = newExpNode(OpK); $$->nodeChild[0]= $1; $$->nodeChild[1] = $3; $$->attr.op = $2;}
    |   additive_expression UNEQUAL additive_expression {$$ = newExpNode(OpK); $$->nodeChild[0]= $1; $$->nodeChild[1] = $3; $$->attr.op = $2;}
    |   additive_expression {$$ = $1;}
    ;


additive_expression : additive_expression PLUS term  { $$ = newExpNode(AddK); $$->attr.op = $2; $$->nodeChild[0] = $1; $$->nodeChild[1] = $3;}
    |   additive_expression MINUS term  { $$ = newExpNode(AddK); $$->attr.op = $2; $$->nodeChild[0]= $1; $$->nodeChild[1] = $3;}
    |   term                     { $$ = $1;}
    ;

term : term MULTI factor {$$ = newExpNode(MulK); $$->attr.op = $2; $$->nodeChild[0] = $1; $$->nodeChild[1] = $3;}
    |   term DIVIDE factor {$$ = newExpNode(MulK); $$->attr.op = $2; $$->nodeChild[0] = $1; $$->nodeChild[1] = $3;}
    |   factor {$$ = $1;}
    ;

factor : LEFTBRACKET expression RIGHTBRACKET {$$ = $2;}
    |   var {$$ = $1;}
    |   call {$$ = $1;}
    |   NUM {$$ = newExpNode(ConstK); $$->attr.val = $1;}
    ;
    
call : ID LEFTBRACKET args RIGHTBRACKET {$$ = newExpNode(CallK); $$->listChild[0] = $3; $$->attr.name = $1;}
    |   ID LEFTBRACKET RIGHTBRACKET {$$ = newExpNode(CallK); $$->attr.name = $1;}
    ;

args : args COMMA expression {addNode($1, $3); $$ = $1;}
    |   expression {$$ = newStmtNode(ArgsK); addNode($$, $1);}
    ;
%%

void yyerror(const char *s){
    printf("error: %s\n in line : %d\n text: %s\n", s, yylineno, yytext);
}

