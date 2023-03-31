# chisel学习仓库
## 说明
此仓库为我个人学习用仓库，将分支切换到`template`可作为模板使用  
此项目基于`OpenXiangShan`提供的`chisel`模板[OpenXiangShan/chisel-playground](https://github.com/OpenXiangShan/chisel-playground)，对其进行了一点修改，并为其添加了[verilator](https://verilator.org/)与[NJU-ProjectN/nvboard](https://github.com/NJU-ProjectN/nvboard)支持  
## 使用到的工具
[lefou/millw](https://github.com/lefou/millw): 自动获取与执行`mill`的脚本工具  
[com-lihaoyi/mill](https://github.com/com-lihaoyi/mill): `Scala`构建工具  
[verilator](https://verilator.org/): `verilog`仿真工具  
[NJU-ProjectN/nvboard](https://github.com/NJU-ProjectN/nvboard): `verilog`仿真工具, 可模拟一个图形化的FPGA, 支持LED, 七段数码管, 开关, 键盘和VGA  
**说明**: `mill`与`millw`使用任意一个即可, 使用`millw`时将脚本更名为`mill`后将路径添加到`PATH`即可进行`make`. 也可以选择不更名, 将`make`中所有`mill`改为`millw`.
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
├── nvboard         // nvboard用于仿真
│   ├── INC
│   ├── SRC
│   │   └── main.cpp // nvboard主函数
│   └── constr
│       └── top.nxdc // nvboard引脚绑定配置文件
├── playground
│   ├── src
│   │   └── main
│   │       ├── Elaborate.scala // 用于生成veriltor
│   │       └── TOP.scala       // 顶层模块
│   └── test
├── utils // 编译用工具
│   ├── firtool
│   └── firtool.elf.strip
└── verilator // verilator用于仿真
    ├── INC
    └── SRC
        └── main.cpp // verilator主函数
```