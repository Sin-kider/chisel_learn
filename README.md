# chisel学习仓库
## 说明
此仓库为我个人学习用仓库，将分支切换到`template`可作为模板使用  
此项目基于`OpenXiangShan`提供的`chisel`模板[OpenXiangShan/chisel-playground](https://github.com/OpenXiangShan/chisel-playground)，对其进行了一点修改，并为其添加了[verilator](https://verilator.org/)与[NJU-ProjectN/nvboard](https://github.com/NJU-ProjectN/nvboard)支持  
## 使用到的工具
[lefou/millw](https://github.com/lefou/millw): 自动获取与执行`mill`的脚本工具  
[com-lihaoyi/mill](https://github.com/com-lihaoyi/mill): `Scala`构建工具  
[verilator](https://verilator.org/): `verilog`仿真工具  
[NJU-ProjectN/nvboard](https://github.com/NJU-ProjectN/nvboard): `verilog`仿真工具, 可模拟一个图形化的FPGA, 支持LED, 七段数码管, 开关, 键盘和VGA  
[gtkwave/gtkwave](https://github.com/gtkwave/gtkwave): 用于查看`verilator`生成的波形文件  

---  
**说明**: `mill`与`millw`使用任意一个即可, 使用`millw`时将脚本更名为`mill`后将路径添加到`PATH`即可进行`make`. 也可以选择不更名, 将`make`中所有`mill`改为`millw`.

## 命令使用
**说明**: 以下命令都需要配置相应的工具或环境. 若出现错误请查看上文的工具是否安装齐全, 安装方法工具主页都有相关说明. 基本工具如`make`, `gcc`等请自行`STFW`.  

---
verilator  
`make val`          编译verilator  
`make valrun`       运行verilator并生成波形文件  
`make valsim`       运行gtkwave查看波形  

---
nvboard  
`make nv`           编译nvboard  
`make nvrun`        运行nvboard  

---
chisel  
`make test`         chisel测试  
`make verilog`      chisel生成verilog  
`make help`         查看circt工具帮助信息  
`make compile`      编译  
`make bsp`          生成idea所需文件  
`make reformat`     代码整理  
`make checkformat`  检查.scalafmt.conf文件  

---
其他  
`make clean`        移除全部生成文件 ~~若出现权限问题请手动删除~~  
`make cleannv`      移除nvboard生成文件  
`make cleanchi`     移除chisel生成文件  
`make cleanval`     移除verlator生成文件  

## 项目结构
```SHELL
$ git checkout template
$ tree -a .
.
├── .gitignore
├── .mill-version   // millw工具版本控制文件
├── .scalafmt.conf  // scala代码整理设置
├── Makefile        // makefile 写的烂(但是能用)
├── README.md       // 项目说明
├── build.sc        // mill编译配置文件
├── nvboard         // nvboard用于仿真 [不使用可删]
│   ├── INC
│   ├── SRC
│   │   └── main.cpp // nvboard主函数
│   └── constr
│       └── top.nxdc // nvboard引脚绑定配置文件
├── playground
│   ├── src                 // 源文件夹
│   │   ├── Elaborate.scala // 用于生成verilog文件
│   │   ├── TOP.scala       // nvboard所需顶层模块
│   │   └── main
│   │       └── example.scala       // 样例
│   └── test                        // 测试文件夹
│       └── src
│           ├── TOP.scala           // TOP模块测试代码
│           └── main
│               └── example.scala   // example模块测试代码
├── utils // 编译用工具
│   ├── firtool
│   └── firtool.elf.strip
└── verilator           // verilator用于仿真 [不使用可删]
    ├── INC
    └── SRC
        └── main.cpp    // verilator主函数
```

## 其余工作
1. \[**必须**\] 完成`mill`或`millw`工具的配置, 按照前面给出的github链接中的安装方法安装, 安装完成后可以使用`make compile`测试是否能够编译.  
2. \[**可选**\] 安装`verilator`, 前面同样给出了对应链接, 按照官方文档安装`5.008`版本(最新版也可以, 但不保证能正常运行此项目), 使用`make val`测试是否可以编译.  
3. \[**可选**\] 安装`nvboard`, 同样对照项目说明配置好. 使用`make nv`可进行编译.