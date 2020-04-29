
# TinySyntaxAnalyse
TinySyntaxAnalyse
# MiniC
### install bison & lex
### run the parser follow:
 - bison -d parse.y
 - lex scan.l
 - g++ main.cc utils.cc parse.tab.c lex.yy.c -o {fileNameYouWant}
 - modify test.minic
 - run the file
