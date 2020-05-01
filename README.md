# MiniC

## run in mfc

- 将项目目录下的 winflex 文件夹的目录（项目目录/winflex）添加进系统环境
- 右键点击MiniCAnalyser![image-20200430100350717](C:\Users\dav1d\AppData\Roaming\Typora\typora-user-images\image-20200430100350717.png)
- ![image-20200430100306796](C:\Users\dav1d\AppData\Roaming\Typora\typora-user-images\image-20200430100306796.png)
- 生成依赖项->生成自定义
- ![image-20200430100500204](C:\Users\dav1d\AppData\Roaming\Typora\typora-user-images\image-20200430100500204.png)
- 查找现有的，在目录 项目目录\winflex\custom_build_rules\Bison 下找到文件 win_flex_bison_custom_build.targets 选择打开，并如上图选中点击确定
- 编译运行

## run in Linux

### install bison & lex
### run the parser follow:
 - bison -d parse.y
 - lex scan.l
 - g++ main.cc utils.cc parse.tab.c lex.yy.c -o {fileNameYouWant}
 - modify test.minic
 - run the file



### 程序清单

```
utils.cpp // 生成节点，打印语法树等工具的实现
scan.flex.cpp // 由 lex 生成的 cpp 文件
parse.tab.cpp // 由 yacc 生成的 cpp 文件
parse.y // yacc定义文件
scan.l // lex 定义文件
```

