/*
 * @Copyright: minic
 * @Author: David.Huangjunlang
 * @Description: 主函数
 * @LastEditors: David.Huangjunlang
 * @LastEditTime: 2020-04-29 02:52:32
 * @FilePath: /minic/main.cc
 */

#include "main.h"
#include "utils.h"

// 链接由 yacc lex 提供的输入文件
extern FILE *yyin;
// 链接 lex 分析函数
extern int yylex(void);
// 链接 yacc 解析函数
extern int yyparse(void);
// 链接 lex 行数变量
extern int yylineno;
// 链接 lex 当前token变量
extern char *yytext;
// 打印语法树目标文件
FILE *result;
// 打印词法树目标文件
FILE *lexOut;
// 程序根节点
node *programNode = (node *)malloc(sizeof(node));

int main()
{
    int ntoken, vtoken;
    yyin = fopen("test.minc", "r");
    lexOut = fopen("lex.txt", "w+");
    fprintf(lexOut, "< %-6s, %-10s, %-7s>\n", "lineno", "type", "name");
    result = fopen("parse.txt", "w+");
    yyparse();
    printTree();
    fclose(result);
    fclose(yyin);
    fclose(lexOut);
    return 0;
}