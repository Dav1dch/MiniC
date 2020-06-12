/*
 * @Copyright: minic
 * @Author: David.Huangjunlang
 * @Description: lex 文件，定义各token 匹配规则，并返回相应值，同时会判断identifier 是否为保留字
 * @LastEditors: David.Huangjunlang
 * @LastEditTime: 2020-04-30 10:11:42
 * @FilePath: /minic/scan.l
 */
%{
    #include "main.h"
    #include "parse.tab.h"
    /**
    * @description:  判断是否为关键字，如果不是则返回类型为ID 
    * @param {void} 
    * @return: int
    * @author: David.Huangjunlang
    */
    int isReservedWords();

    /**
    * @description: 打印词法树
    * @param {int} 
    * @return: void
    * @author: David.Huangjunlang
    */
    void lexAnalysis(int index);
    // 链接词法输出文件
    extern FILE* lexOut;
    extern "C"{
        int yywrap(void);
    }
    char c[4][10]={"ID","NUM","RESERVED","OPERATOR"};
%}
%x          COMMENT
digit       [0-9]
letter      [a-zA-Z]
delim       [" "\t]
nexLine     [\n]
whitespace  {delim}+
ID          {letter}+
NUM         {digit}+
%%
{ID}            {return isReservedWords();}
{NUM}           {yylval.m_num = atoi(yytext);lexAnalysis(1);return NUM;}
{whitespace}    {}
{nexLine}       {yylineno++;}
"+"             {yylval.m_op = yytext;lexAnalysis(3);return PLUS;}
"-"             {yylval.m_op = yytext;lexAnalysis(3);return MINUS;}
"*"             {yylval.m_op = yytext;lexAnalysis(3);return MULTI;}
"/"             {yylval.m_op = yytext;lexAnalysis(3);return DIVIDE;}
"<"             {yylval.m_op = yytext;lexAnalysis(3);return LESS;}
"<="            {yylval.m_op = yytext;lexAnalysis(3);return LESSEQUAL;}
">"             {yylval.m_op = yytext;lexAnalysis(3);return GREATER;}
">="            {yylval.m_op = yytext;lexAnalysis(3);return GREATEREQUAL;}
"=="            {yylval.m_op = yytext;lexAnalysis(3);return EQUAL;}
"!="            {yylval.m_op = yytext;lexAnalysis(3);return UNEQUAL;}
"="             {yylval.m_op = yytext;lexAnalysis(3);return ASSIGNMENT;}
";"             {yylval.m_op = yytext;lexAnalysis(3);return SEMICOLON;}
","             {yylval.m_op = yytext;lexAnalysis(3);return COMMA;}
"("             {yylval.m_op = yytext;lexAnalysis(3);return LEFTBRACKET;}
")"             {yylval.m_op = yytext;lexAnalysis(3);return RIGHTBRACKET;}
"["             {yylval.m_op = yytext;lexAnalysis(3);return LEFTSQUAREBRACKET;}
"]"             {yylval.m_op = yytext;lexAnalysis(3);return RIGHTSQUAREBRACKET;}
"{"             {yylval.m_op = yytext;lexAnalysis(3);return LEFTBRACE;}
"}"             {yylval.m_op = yytext;lexAnalysis(3);return RIGHTBRACE;}
"/*"            {BEGIN COMMENT;}
<COMMENT>"*/"   {BEGIN INITIAL;}
.               {;}
%%

/**
 * @description: lex 函数
 * @param {void} 
 * @return: void
 * @author: David.Huangjunlang
 */
int yywrap(){
    yy_flush_buffer(YY_CURRENT_BUFFER);
    {BEGIN INITIAL;}
    yylineno = 1;
    return 1;
}

/**
 * @description:  判断是否为关键字，如果不是则返回类型为ID 
 * @param {void} 
 * @return: int
 * @author: David.Huangjunlang
 */
int isReservedWords(){
        if(strcmp(yytext,"else") == 0){yylval.m_reserved = yytext;lexAnalysis(2);return ELSE;}
        if(strcmp(yytext,"if") == 0){yylval.m_reserved = yytext;lexAnalysis(2);return IF;}
        if(strcmp(yytext,"int") == 0){yylval.m_reserved = yytext;lexAnalysis(2);return INT;}
        if(strcmp(yytext,"return") == 0){yylval.m_reserved = yytext;lexAnalysis(2);return RETURN;}
        if(strcmp(yytext,"void") == 0){yylval.m_reserved = yytext;lexAnalysis(2);return VOID;}
        if(strcmp(yytext,"while") == 0){yylval.m_reserved = yytext;lexAnalysis(2);return WHILE;}
        if(strcmp(yytext,"output") == 0){yylval.m_reserved = yytext;lexAnalysis(2);return OUTPUT;}
        if(strcmp(yytext,"intput") == 0){yylval.m_reserved = yytext;lexAnalysis(2);return INPUT;}
        yylval.m_id = yytext;
        lexAnalysis(0);
        return ID;
}

/**
 * @description: 打印词法树
 * @param {int} 
 * @return: void
 * @author: David.Huangjunlang
 */
void lexAnalysis(int index){
    fprintf(lexOut, "< %-6d, %-10s, %-7s>\n", yylineno, c[index], yytext);
}

