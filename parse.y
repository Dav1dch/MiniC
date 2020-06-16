/*
 * @Copyright: minic
 * @Author: David.Huangjunlang
 * @Description: Yacc 文件，包含 token 定义，以及规则移进规约定义，以及解析错误时输出错误信息
 * @LastEditors: David.Huangjunlang
 * @LastEditTime: 2020-04-30 09:30:51
 * @FilePath: /minic/parse.y
 */
%{
    #include "main.h"
    #include "utils.h"
    extern node* programNode;
    extern FILE* result;
    extern int yylineno;
    extern char* yytext;
    extern int yylex(void);
    extern "C"{
        void yyerror(const char *s);
        int yywrap(void);
}
%}


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

program : declaration_list {$$ = newStmtNode(ProgramK); $$->nodeChild[0] = $1;programNode = $$; programNode->name = "helloworld";$$->lineno = yylineno;}
    ;

declaration_list : declaration_list declaration {addNode($1, $2);$$ = $1;$$->lineno = yylineno; $1->isGlobal = 1;}
    |   declaration {$$ = newStmtNode(DeclK); addNode($$, $1);$$->lineno = yylineno; $1->isGlobal = 1;}
    ;

declaration : var_declaration {$$ = $1;$$->lineno = yylineno;}
    | fun_declaration {$$ = $1;$$->lineno = yylineno;}
    ;

var_declaration : INT ID{$$ = newStmtNode(VarK); $$->name = $2;$$->lineno = yylineno;}
    |   INT ID LEFTSQUAREBRACKET NUM RIGHTSQUAREBRACKET{node *t = newExpNode(ConstK); t->val = $4; $$ = newStmtNode(ArrayK);$$->nodeChild[0] = t;$$->lineno = yylineno; $$->isArray = 1;}
    ;

fun_declaration : VOID ID LEFTBRACKET params RIGHTBRACKET compound_stmt{$$ = newStmtNode(FunK);$$->lineno = yylineno;
                                                                      $$->type = 0;
                                                                      $$->name = $2; $$->nodeChild[0] = $4;
                                                                      if($4 != nullptr){$$->param_size = $4->param_size;};
                                                                      $$->local_size = $6->local_size;
                                                                      $$->nodeChild[1] = $6;}
    |   INT ID LEFTBRACKET params RIGHTBRACKET compound_stmt{$$ = newStmtNode(FunK);$$->lineno = yylineno;
                                                                      $$->type = 1;
                                                                      $$->name = $2; $$->nodeChild[0] = $4;
                                                                      if($4 != nullptr){$$->param_size = $4->param_size;};
                                                                      $$->local_size = $6->local_size;
                                                                      $$->nodeChild[1] = $6;}
 
    ;

params : param_list {$$ = $1;$$->lineno = yylineno;}
    |   VOID {$$ = nullptr;}
    ;

param_list : param_list COMMA param {addNode($1, $3); $$ = $1; $$->param_size += 1;}
    |   param {$$ = newStmtNode(ParamlK); $$->param_size += 1;addNode($$, $1);$$->lineno = yylineno;}
    ;

param : INT ID {$$ = newStmtNode(VarK); $$->name = $2;$$->lineno = yylineno;$$->isParameter = 1;}
    |   INT ID LEFTSQUAREBRACKET RIGHTSQUAREBRACKET {$$ = newStmtNode(ArrayK); $$->name = $2;$$->lineno = yylineno;$$->isParameter = 1; $$->isArray = 1;}
    ;

compound_stmt : LEFTBRACE local_declarations statement_list RIGHTBRACE {$$ = newStmtNode(CompK);$$->lineno = yylineno;
                                                                        $$->local_size = $2->local_size;
                                                                        $$->nodeChild[0] = $2;
                                                                        $$->nodeChild[1] = $3;}
    |   LEFTBRACE local_declarations RIGHTBRACE {$$ = newStmtNode(CompK); $$->nodeChild[0] = $2;
                                                                        $$->local_size = $2->local_size;
                                                                        $$->lineno = yylineno;}
    |   LEFTBRACE statement_list RIGHTBRACE {$$ = newStmtNode(CompK); $$->nodeChild[1] = $2;$$->lineno = yylineno;}
    ;

local_declarations : local_declarations var_declaration SEMICOLON {addNode($1, $2); $$ = $1;$$->lineno = yylineno; $$->local_size += 1;}
    |   var_declaration COMMA {$$ = newStmtNode(LocdeclK); addNode($$, $1);$$->lineno = yylineno; $$->local_size += 1;}
    |   {}
    ;

statement_list : statement_list statement {addNode($1, $2); $$ = $1;$$->lineno = yylineno;}
    |   statement {$$ = newStmtNode(StmtlK); addNode($$, $1);$$->lineno = yylineno;}
    ;

statement : expression_stmt {$$ = $1;$$->lineno = yylineno;}
    |   selection_stmt {$$ = $1;$$->lineno = yylineno;}
    |   compound_stmt {$$ = $1;$$->lineno = yylineno;}
    |   iteration_stmt {$$ = $1;$$->lineno = yylineno;}
    |   return_stmt {$$ = $1;$$->lineno = yylineno;}
    ;

expression_stmt: expression SEMICOLON {$$ = $1;$$->lineno = yylineno;}
    |   SEMICOLON {}
    ;

selection_stmt : IF LEFTBRACKET expression RIGHTBRACKET statement {$$ = newStmtNode(SelectK); $$->nodeChild[0] = $3; $$->nodeChild[1] = $5;$$->lineno = yylineno;}
    |   IF LEFTBRACKET expression RIGHTBRACKET statement ELSE statement {$$ = newStmtNode(SelectK); $$->nodeChild[0] = $3; $$->nodeChild[1] = $5; $$->nodeChild[2] = $7;$$->lineno = yylineno;}
    ;

iteration_stmt : WHILE LEFTBRACKET expression RIGHTBRACKET statement {$$ = newStmtNode(IteraK); $$->nodeChild[0] = $3; $$->nodeChild[1] = $5;$$->lineno = yylineno;}
    ;

return_stmt : RETURN SEMICOLON {$$ = newStmtNode(ReturnK);$$->lineno = yylineno;}
    |   RETURN expression SEMICOLON {$$ = newStmtNode(ReturnK); $$->nodeChild[0] = $2;$$->lineno = yylineno;}
    ;

expression : var ASSIGNMENT expression {$$=newExpNode(AssignK); $$->nodeChild[0] = $1; $$->nodeChild[1] = $3;$$->lineno = yylineno;}
    |  simple_expression {$$ = $1;$$->lineno = yylineno;} 
    ;


var : ID {$$ = newExpNode(IdK); $$->name = $1;$$->lineno = yylineno;}
    |   ID LEFTSQUAREBRACKET expression RIGHTSQUAREBRACKET {$$ = newStmtNode(ArrayK); $$->nodeChild[0] = $3;$$->lineno = yylineno;}
    ;

simple_expression : additive_expression LESSEQUAL additive_expression {$$ = newExpNode(OpK); $$->type=8;$$->nodeChild[0] = $1; $$->nodeChild[1] = $3; $$->op = $2;$$->lineno = yylineno;}
    |   additive_expression LESS additive_expression {$$ = newExpNode(OpK); $$->type=6;$$->nodeChild[0]= $1; $$->nodeChild[1] = $3; $$->op = $2;$$->lineno = yylineno;}
    |   additive_expression GREATER additive_expression {$$ = newExpNode(OpK); $$->type=9;$$->nodeChild[0]= $1; $$->nodeChild[1] = $3; $$->op = $2;$$->lineno = yylineno;}
    |   additive_expression GREATEREQUAL additive_expression {$$ = newExpNode(OpK); $$->type=10;$$->nodeChild[0]= $1; $$->nodeChild[1] = $3; $$->op = $2;$$->lineno = yylineno;}
    |   additive_expression EQUAL additive_expression {$$ = newExpNode(OpK); $$->type=7;$$->nodeChild[0]= $1; $$->nodeChild[1] = $3; $$->op = $2;$$->lineno = yylineno;}
    |   additive_expression UNEQUAL additive_expression {$$ = newExpNode(OpK); $$->type=11;$$->nodeChild[0]= $1; $$->nodeChild[1] = $3; $$->op = $2;$$->lineno = yylineno;}
    |   additive_expression {$$ = $1;$$->lineno = yylineno;}
    ;


additive_expression : additive_expression PLUS term  { $$ = newExpNode(OpK); $$->op = $2; $$->type=2;$$->nodeChild[0] = $1; $$->nodeChild[1] = $3;$$->lineno = yylineno;}
    |   additive_expression MINUS term  { $$ = newExpNode(OpK); $$->op = $2; $$->type=3;$$->nodeChild[0]= $1; $$->nodeChild[1] = $3;$$->lineno = yylineno;}
    |   term                     { $$ = $1;$$->lineno = yylineno;}
    ;

term : term MULTI factor {$$ = newExpNode(OpK); $$->op = $2; $$->type=4;$$->nodeChild[0] = $1; $$->nodeChild[1] = $3;$$->lineno = yylineno;}
    |   term DIVIDE factor {$$ = newExpNode(OpK); $$->op = $2; $$->type=5;$$->nodeChild[0] = $1; $$->nodeChild[1] = $3;$$->lineno = yylineno;}
    |   factor {$$ = $1;$$->lineno = yylineno;}
    ;

factor : LEFTBRACKET expression RIGHTBRACKET {$$ = $2;$$->lineno = yylineno;}
    |   var {$$ = $1;$$->lineno = yylineno;}
    |   call {$$ = $1;$$->lineno = yylineno;}
    |   NUM {$$ = newExpNode(ConstK); $$->val = $1;$$->lineno = yylineno;}
    ;
    
call : ID LEFTBRACKET args RIGHTBRACKET {$$ = newStmtNode(CallK); $$->nodeChild[0] = $3; $$->name = $1;$$->lineno = yylineno;}
    |   ID LEFTBRACKET RIGHTBRACKET {$$ = newStmtNode(CallK); $$->name = $1;$$->lineno = yylineno;}
    ;

args : args COMMA expression {addNode($1, $3); $$ = $1;$$->lineno = yylineno; $$->param_size += 1; }
    |   expression {$$ = newStmtNode(ArgsK); addNode($$, $1);$$->lineno = yylineno; $$->param_size += 1;}
    ;
%%

/**
 * @description: 处理解析错误并打印到文件
 * @param {void} 
 * @return: void
 * @author: David.Huangjunlang
 */
void yyerror(const char *s){
    fprintf(result ,"error: %s\n in line : %d\n unexpected token: %s\n", s, yylineno, yytext);
    yywrap();
}

