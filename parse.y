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
%token <m_reserved> ELSE IF INT VOID RETURN WHILE OUTPUT INPUT

%type <m_node> declaration fun_declaration var_declaration param expression simple_expression additive_expression var term factor call program
%type <m_node> expression_stmt compound_stmt statement selection_stmt iteration_stmt return_stmt
%type <m_node> params local_declarations args
%type <m_node> statement_list param_list declaration_list 

%%

program : declaration_list {$$ = newStmtNode(ProgramK); $$->nodeChild[0] = $1;programNode = $$; programNode->name = "helloworld";$$->lineno = yylineno;}
    ;

declaration_list : declaration_list declaration {addNode($1, $2);$$ = $1;$$->lineno = yylineno;}
    |   declaration {$$ = newStmtNode(DeclK); addNode($$, $1);$$->lineno = yylineno;}
    ;

declaration : var_declaration {$$ = $1;$$->lineno = yylineno;}
    | fun_declaration {$$ = $1;$$->lineno = yylineno;}
    ;

var_declaration : INT ID{$$ = newExpNode(IdK); $$->name = $2;$$->lineno = yylineno;}
    |   INT ID LEFTSQUAREBRACKET NUM RIGHTSQUAREBRACKET{node *t = newExpNode(ConstK); t->val = $4; $$ = newExpNode(ArrayK);$$->nodeChild[0] = t;$$->lineno = yylineno;}
    ;

fun_declaration : VOID ID LEFTBRACKET params RIGHTBRACKET compound_stmt{$$ = newStmtNode(VoidFundecK);$$->lineno = yylineno;
                                                                      $$->name = $2; $$->nodeChild[0] = $4;
                                                                      $$->nodeChild[1] = $6;}
    |   INT ID LEFTBRACKET params RIGHTBRACKET compound_stmt{$$ = newStmtNode(IntFundecK);$$->lineno = yylineno;
                                                                      $$->name = $2; $$->nodeChild[0] = $4;
                                                                      $$->nodeChild[1] = $6;}
 
    ;

params : param_list {$$ = $1;$$->lineno = yylineno;}
    |   VOID {$$ = nullptr;}
    ;

param_list : param_list COMMA param {addNode($1, $3); $$ = $1;}
    |   param {$$ = newStmtNode(ParamlK); addNode($$, $1);$$->lineno = yylineno;}
    ;

param : INT ID {$$ = newExpNode(IdK); $$->name = $2;$$->lineno = yylineno;}
    |   INT ID LEFTSQUAREBRACKET RIGHTSQUAREBRACKET {$$ = newExpNode(ArrayptrK); $$->name = $2;$$->lineno = yylineno;}
    ;

compound_stmt : LEFTBRACE local_declarations statement_list RIGHTBRACE {$$ = newStmtNode(CompK);$$->lineno = yylineno;
                                                                        $$->nodeChild[0] = $2;
                                                                        $$->nodeChild[1] = $3;}
    |   LEFTBRACE local_declarations RIGHTBRACE {$$ = newStmtNode(CompK); $$->nodeChild[0] = $2;$$->lineno = yylineno;}
    |   LEFTBRACE statement_list RIGHTBRACE {$$ = newStmtNode(CompK); $$->nodeChild[1] = $2;$$->lineno = yylineno;}
    ;

local_declarations : local_declarations var_declaration SEMICOLON {addNode($1, $2); $$ = $1;$$->lineno = yylineno;}
    |   var_declaration COMMA {$$ = newStmtNode(LocdeclK); addNode($$, $1);$$->lineno = yylineno;}
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

expression_stmt: expression SEMICOLON {$$ = newStmtNode(ExpressionK); $$->nodeChild[0] = $1;$$->lineno = yylineno;}
    |   SEMICOLON {$$ = newStmtNode(ExpressionK);$$->lineno = yylineno;}
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
    |   ID LEFTSQUAREBRACKET expression RIGHTSQUAREBRACKET {$$ = newExpNode(IndexK); $$->nodeChild[0] = $3;$$->lineno = yylineno;}
    ;

simple_expression : additive_expression LESSEQUAL additive_expression {$$ = newExpNode(OpK); $$->nodeChild[0] = $1; $$->nodeChild[1] = $3; $$->op = $2;$$->lineno = yylineno;}
    |   additive_expression LESS additive_expression {$$ = newExpNode(OpK); $$->nodeChild[0]= $1; $$->nodeChild[1] = $3; $$->op = $2;$$->lineno = yylineno;}
    |   additive_expression GREATER additive_expression {$$ = newExpNode(OpK); $$->nodeChild[0]= $1; $$->nodeChild[1] = $3; $$->op = $2;$$->lineno = yylineno;}
    |   additive_expression GREATEREQUAL additive_expression {$$ = newExpNode(OpK); $$->nodeChild[0]= $1; $$->nodeChild[1] = $3; $$->op = $2;$$->lineno = yylineno;}
    |   additive_expression EQUAL additive_expression {$$ = newExpNode(OpK); $$->nodeChild[0]= $1; $$->nodeChild[1] = $3; $$->op = $2;$$->lineno = yylineno;}
    |   additive_expression UNEQUAL additive_expression {$$ = newExpNode(OpK); $$->nodeChild[0]= $1; $$->nodeChild[1] = $3; $$->op = $2;$$->lineno = yylineno;}
    |   additive_expression {$$ = $1;$$->lineno = yylineno;}
    ;


additive_expression : additive_expression PLUS term  { $$ = newExpNode(AddK); $$->op = $2; $$->nodeChild[0] = $1; $$->nodeChild[1] = $3;$$->lineno = yylineno;}
    |   additive_expression MINUS term  { $$ = newExpNode(AddK); $$->op = $2; $$->nodeChild[0]= $1; $$->nodeChild[1] = $3;$$->lineno = yylineno;}
    |   term                     { $$ = $1;$$->lineno = yylineno;}
    ;

term : term MULTI factor {$$ = newExpNode(MulK); $$->op = $2; $$->nodeChild[0] = $1; $$->nodeChild[1] = $3;$$->lineno = yylineno;}
    |   term DIVIDE factor {$$ = newExpNode(MulK); $$->op = $2; $$->nodeChild[0] = $1; $$->nodeChild[1] = $3;$$->lineno = yylineno;}
    |   factor {$$ = $1;$$->lineno = yylineno;}
    ;

factor : LEFTBRACKET expression RIGHTBRACKET {$$ = $2;$$->lineno = yylineno;}
    |   var {$$ = $1;$$->lineno = yylineno;}
    |   call {$$ = $1;$$->lineno = yylineno;}
    |   NUM {$$ = newExpNode(ConstK); $$->val = $1;$$->lineno = yylineno;}
    ;
    
call : ID LEFTBRACKET args RIGHTBRACKET {$$ = newExpNode(CallK); $$->nodeChild[0] = $3; $$->name = $1;$$->lineno = yylineno;}
    |   ID LEFTBRACKET RIGHTBRACKET {$$ = newExpNode(CallK); $$->name = $1;$$->lineno = yylineno;}
    |   INPUT LEFTBRACKET RIGHTBRACKET {$$ = newExpNode(ReadK);$$->lineno = yylineno;}
    |   OUTPUT LEFTBRACKET simple_expression RIGHTBRACKET {$$ = newExpNode(WriteK);$$->lineno = yylineno; $$->nodeChild[0] = $3;}
    ;

args : args COMMA expression {addNode($1, $3); $$ = $1;$$->lineno = yylineno;}
    |   expression {$$ = newStmtNode(ArgsK); addNode($$, $1);$$->lineno = yylineno;}
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

