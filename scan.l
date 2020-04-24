%{
    #include "main.h"
    #include "parse.tab.h"
    int isReservedWords();
    extern "C"{
        int yywrap(void);
        int yylex(void);
    }
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
{NUM}           {yylval.m_num = atoi(yytext);return NUM;}
{whitespace}    {}
{nexLine}       {yylineno++;}
"+"             {yylval.m_op = yytext;return PLUS;}
"-"             {yylval.m_op = yytext;return MINUS;}
"*"             {yylval.m_op = yytext;return MULTI;}
"/"             {yylval.m_op = yytext;return DIVIDE;}
"<"             {yylval.m_op = yytext;return LESS;}
"<="            {yylval.m_op = yytext;return LESSEQUAL;}
">"             {yylval.m_op = yytext;return GREATER;}
">="            {yylval.m_op = yytext;return GREATEREQUAL;}
"=="            {yylval.m_op = yytext;return EQUAL;}
"!="            {yylval.m_op = yytext;return UNEQUAL;}
"="             {yylval.m_op = yytext;return ASSIGNMENT;}
";"             {yylval.m_op = yytext;return SEMICOLON;}
","             {yylval.m_op = yytext;return COMMA;}
"("             {yylval.m_op = yytext;return LEFTBRACKET;}
")"             {yylval.m_op = yytext;return RIGHTBRACKET;}
"["             {yylval.m_op = yytext;return LEFTSQUAREBRACKET;}
"]"             {yylval.m_op = yytext;return RIGHTSQUAREBRACKET;}
"{"             {yylval.m_op = yytext;return LEFTBRACE;}
"}"             {yylval.m_op = yytext;return RIGHTBRACE;}
"/*"            {BEGIN COMMENT;}
<COMMENT>"*/"   {BEGIN INITIAL;}
.               {;}
%%
int yywrap(){
    return 1;
}

int isReservedWords(){
        if(strcmp(yytext,"else") == 0){yylval.m_reserved = yytext;return ELSE;}
        if(strcmp(yytext,"if") == 0){yylval.m_reserved = yytext;return IF;}
        if(strcmp(yytext,"int") == 0){yylval.m_reserved = yytext;return INT;}
        if(strcmp(yytext,"return") == 0){yylval.m_reserved = yytext;return RETURN;}
        if(strcmp(yytext,"void") == 0){yylval.m_reserved = yytext;return VOID;}
        if(strcmp(yytext,"while") == 0){yylval.m_reserved = yytext;return WHILE;}
        yylval.m_id = yytext;
        return ID;
}