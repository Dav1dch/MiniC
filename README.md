# MiniC

## run in mfc

- 双击打开MiniCAnalyser.vcxproj

- 将项目目录下的 winflex 文件夹的目录（项目目录/winflex）添加进系统环境

  - 
- 右键点击MiniCAnalyser![image-20200501171802653](C:\Users\11500\AppData\Roaming\Typora\typora-user-images\image-20200501171802653.png)
  - 打开电脑的系统环境path![image-20200618182123244](C:\Users\11500\AppData\Roaming\Typora\typora-user-images\image-20200618182123244.png)
  - 将winflex的环境加到最下面![image-20200618182207736](C:\Users\11500\AppData\Roaming\Typora\typora-user-images\image-20200618182207736.png)

- 

- 生成依赖项->生成自定义

- ![image-20200501171642145](C:\Users\11500\AppData\Roaming\Typora\typora-user-images\image-20200501171642145.png)

- 

- 查找现有的，在目录 项目目录\winflex\custom_build_rules\Bison 下找到文件 win_flex_bison_custom_build.targets 选择打开，并如上图选中点击确定

- ![image-20200501172047984](C:\Users\11500\AppData\Roaming\Typora\typora-user-images\image-20200501172047984.png)

- ![image-20200501172011630](C:\Users\11500\AppData\Roaming\Typora\typora-user-images\image-20200501172011630.png)

- 

- 编译运行即可

- 选择打开的文件，example{X}.txt都是符合MiniC语法的，选择example2.txt，这是排序的程序，兼容了MiniC的全部语法

- ![image-20200618183758485](C:\Users\11500\AppData\Roaming\Typora\typora-user-images\image-20200618183758485.png)

  ![image-20200618183829444](C:\Users\11500\AppData\Roaming\Typora\typora-user-images\image-20200618183829444.png)

  

- 点击生成语法树

- ![image-20200618183909820](C:\Users\11500\AppData\Roaming\Typora\typora-user-images\image-20200618183909820.png)

- 

- 点击查看语法树

- ![image-20200618183926567](C:\Users\11500\AppData\Roaming\Typora\typora-user-images\image-20200618183926567.png)

- ![image-20200618183945805](C:\Users\11500\AppData\Roaming\Typora\typora-user-images\image-20200618183945805.png)



点击生成符号表和中间代码

![image-20200618184030035](C:\Users\11500\AppData\Roaming\Typora\typora-user-images\image-20200618184030035.png)



点击查看符号表

![image-20200618184047054](C:\Users\11500\AppData\Roaming\Typora\typora-user-images\image-20200618184047054.png)



​	![image-20200618184111900](C:\Users\11500\AppData\Roaming\Typora\typora-user-images\image-20200618184111900.png)



点击查看中间代码

![image-20200618184125587](C:\Users\11500\AppData\Roaming\Typora\typora-user-images\image-20200618184125587.png)

![image-20200618185145458](C:\Users\11500\AppData\Roaming\Typora\typora-user-images\image-20200618185145458.png)

中间代码保存在txt文件夹的code.txt里面

在命令行进行项目目录的txt文件夹，执行命令 .\miniC.exe .\code.txt  使用虚拟机来运行中间代码

如果miniC.exe 执行不了，参考虚拟机的使用说明

运行结果如下，正确对数组进行排序并且输出

![image-20200618184226993](C:\Users\11500\AppData\Roaming\Typora\typora-user-images\image-20200618184226993.png)









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
Cgen.cpp // 生成中间代码的cpp文件
```

