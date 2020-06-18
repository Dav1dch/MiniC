# MiniC

## run in mfc

- 双击打开MiniCAnalyser.vcxproj
- 将项目目录下的 winflex 文件夹的目录（项目目录/winflex）添加进系统环境

  - 
- 右键点击MiniCAnalyser![image-20200501171802653](C:\Users\11500\AppData\Roaming\Typora\typora-user-images\image-20200501171802653.png)
- 
- 生成依赖项->生成自定义
- ![image-20200501171642145](C:\Users\11500\AppData\Roaming\Typora\typora-user-images\image-20200501171642145.png)
- 查找现有的，在目录 项目目录\winflex\custom_build_rules\Bison 下找到文件 win_flex_bison_custom_build.targets 选择打开，并如上图选中点击确定
- ![image-20200501172047984](C:\Users\11500\AppData\Roaming\Typora\typora-user-images\image-20200501172047984.png)
- ![image-20200501172011630](C:\Users\11500\AppData\Roaming\Typora\typora-user-images\image-20200501172011630.png)
- 编译运行即可
- 选择打开的文件，其中example1.txt是符合MiniC语法的，选择example1.txt即可
- ![image-20200501172315959](C:\Users\11500\AppData\Roaming\Typora\typora-user-images\image-20200501172315959.png)
- ![image-20200501172603382](C:\Users\11500\AppData\Roaming\Typora\typora-user-images\image-20200501172603382.png)
- ![image-20200501174842211](C:\Users\11500\AppData\Roaming\Typora\typora-user-images\image-20200501174842211.png)
- 点击生成语法树
- ![image-20200501174904879](C:\Users\11500\AppData\Roaming\Typora\typora-user-images\image-20200501174904879.png)
- 点击查看语法树
- ![image-20200501174945116](C:\Users\11500\AppData\Roaming\Typora\typora-user-images\image-20200501174945116.png)
- ![image-20200501175012821](C:\Users\11500\AppData\Roaming\Typora\typora-user-images\image-20200501175012821.png)

注意：编辑框内的更改暂时不起作用，没有设置保存按钮

项目的.exe可运行程序在MiniC文件夹中

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
Symtab.cpp // 查询插入符号表的cpp文件
Analyse.cpp // 构建符号表的cpp文件
Code.cpp // 记录指令的cpp文件
Cgen.cpp // 中间代码生成的cpp文件
```

