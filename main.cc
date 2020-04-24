#include "main.h"
#include "utils.h"

extern FILE* yyin;
extern int yylex(void);
extern int yyparse(void);
extern int yylineno;
extern char* yytext;
FILE* result;
node *programNode = (node *) malloc(sizeof(node));

int main(){
    int ntoken, vtoken;
    yyin = fopen("test.minc", "r");
    yyparse();
    result = fopen("parse.txt", "w+");
    printTree();
    fclose(result);
    fclose(yyin);
    // FILE* lexicalAnalysis = fopen("lexAnalysis.txt", "w+");
    // yyparse();
    // ntoken = yylex();
    // while (ntoken)
    // {
    //     fprintf(lexicalAnalysis, "<%d, %d, %s>\n", yylineno, ntoken, yytext);
    //     ntoken = yylex();
    // }
    // fclose(yyin);
    // fclose(lexicalAnalysis);
    return 0;
}

