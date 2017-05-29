---
title: Linux x86 elf 程序启动过程
date: 2017-03-16 15:37:27
category: Linux
tags:
- Linux
- x86
- elf
- main
- libc
- start
- init
- gdb
---



Kali rolling x86-64 环境，默认动态链接    
参考 32 位： http://dbp-consulting.com/tutorials/debugging/linuxProgramStartup.html 

流程图如下：

![流程图](http://dbp-consulting.com/tutorials/debugging/images/callgraph.png)

64 位草图

![](https://ww3.sinaimg.cn/large/006tNbRwly1fdunwuca6tj31120kuwro.jpg)

# 最简单的 main

```prog1.c
int main()
{
}
```

`gcc -ggdb -o prog1 prog1.c`

# execve

运行程序时，shell 或者 gui 调用 execve() 函数触发系统调用：

- 系统会分配栈区并将 argc, argv, envp 压栈
- 按照 shell 设定 FD
- 装载器负责重定位和调用`preinitializers`（图中`preinitarray1..n`）
- 从程序代码段中 _start 位置开始执行程序

# _start

`_start` 是程序执行的初始位置，通过`objdump -d prog1`查看汇编

```assembly
00000000004003b0 <_start>:
  4003b0:       31 ed                   xor    %ebp,%ebp
  4003b2:       49 89 d1                mov    %rdx,%r9                 # argv
  4003b5:       5e                      pop    %rsi                     # argc
  4003b6:       48 89 e2                mov    %rsp,%rdx                # linker destructor
  4003b9:       48 83 e4 f0             and    $0xfffffffffffffff0,%rsp
  4003bd:       50                      push   %rax
  4003be:       54                      push   %rsp
  4003bf:       49 c7 c0 30 05 40 00    mov    $0x400530,%r8            # <__libc_csu_fini>
  4003c6:       48 c7 c1 c0 04 40 00    mov    $0x4004c0,%rcx           # <__libc_csu_init>
  4003cd:       48 c7 c7 a6 04 40 00    mov    $0x4004a6,%rdi           # <main>
  4003d4:       ff 15 16 0c 20 00       callq  *0x200c16(%rip)        # 600ff0 <__libc_start_main@GLIBC_2.2.5>
  4003da:       f4                      hlt
  4003db:       0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)
```

`_start`的作用就是配置`__libc_start_main`的参数并进行调用：

- `xor %ebp, %ebp`用于将 `%ebp` 清零，同时作为最外层标记

- 对 `%rdi`, `%rsi`, `%rdx`, `%rcx`, `%r8`, `%r9` 的操作均为传参，因为共 7 个参数，还用到了栈来传递第一个参数
    1. `main`地址, 由`__libc_start_main`调用, 另外在程序终止后`main`的返回值会由`__libc_start_main`传递给`exit`
    2. `argc`
    3. `argv`
    4. `__libc_csu_init`
    5. `__libc_csu_fini`
    6. Destructor of dynamic linker. Registered by __libc_start_main with __cxat_exit()
       to call the FINI for dynamic libraries that got loaded before us.
    7. 栈 - 函数调用前的`%rsp`

- 为了[提升访存效率](http://coolshell.cn/articles/11377.html)，编译器通常采用 16B 对齐。为了保证函数调用时的新栈帧是 16B 对齐的，使用`and`指令将 %esp 对齐。

- 同时，为了将 %esp 保存在 16B 对齐的位置，使用`push %rax`提前填充 8B

`_start`调用`__libc_start_main`前的状态:

![before __libc_start_main](https://ww3.sinaimg.cn/large/006tNbRwly1fdu8v5ggcqj30ze138n64.jpg)

# __libc_start_main

`__libc_start_main`定义如下：

```csu/libc-start.c
int __libc_start_main(  
    int (*main) (int, char * *, char * *),
    int argc, 
    char * * ubp_av,
    void (*init) (void),
    void (*fini) (void),
    void (*rtld_fini) (void),
    void (* stack_end)
 );
```


`main`的完整参数调用应该是`int main(int argc, char** argv, char** envp)`, 但是`__libc_start_main`中却并不包含 `envp`, 因为`envp`可以由`argc`和`argv`计算得到

## ELF auxiliary vector

使用 gdb 调试 prog1, 在`_start`处下断点, 运行初始状态如下:
![_start](https://ww4.sinaimg.cn/large/006tNbRwly1fdtk4hiplwj30za13u145.jpg)
可以看到从栈顶向栈底依次放置的是: argc, argv, 0x0, 环境变量等, 即[`ELF 辅助向量`](http://articles.manugarg.com/aboutelfauxiliaryvectors.html). 

## __libc_start_main 的主要功能

- setuid, setgid

- 启动线程

- 寄存`fini`和`rtld_fini`的参数, 等待`at_exit`调用

- 调用`__libc_csu_init`

- 调用`main`

- 调用`exit`

  ​

# __libc_csu_init

![调用__libc_csu_init之前](https://ww2.sinaimg.cn/large/006tNbRwly1fdua01wgboj30zg124tj5.jpg)

```csu/elf-init.c
void __libc_csu_init (int argc, char **argv, char **envp)
{

  _init ();

  const size_t size = __init_array_end - __init_array_start;
  for (size_t i = 0; i < size; i++)
      (*__init_array_start [i]) (argc, argv, envp);
}
```
```assembly
00000000004004c0 <__libc_csu_init>:
  4004c0:	41 57                	push   %r15
  4004c2:	41 56                	push   %r14
  4004c4:	41 89 ff             	mov    %edi,%r15d
  4004c7:	41 55                	push   %r13
  4004c9:	41 54                	push   %r12
  4004cb:	4c 8d 25 76 09 20 00 	lea    0x200976(%rip),%r12        # 600e48 <__frame_dummy_init_array_entry>
  4004d2:	55                   	push   %rbp
  4004d3:	48 8d 2d 76 09 20 00 	lea    0x200976(%rip),%rbp        # 600e50 <__init_array_end>
  4004da:	53                   	push   %rbx
  4004db:	49 89 f6             	mov    %rsi,%r14
  4004de:	49 89 d5             	mov    %rdx,%r13
  4004e1:	4c 29 e5             	sub    %r12,%rbp
  4004e4:	48 83 ec 08          	sub    $0x8,%rsp
  4004e8:	48 c1 fd 03          	sar    $0x3,%rbp
  4004ec:	e8 9f fe ff ff       	callq  400390 <_init>
  4004f1:	48 85 ed             	test   %rbp,%rbp
  4004f4:	74 20                	je     400516 <__libc_csu_init+0x56>
  4004f6:	31 db                	xor    %ebx,%ebx
  4004f8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  4004ff:	00
  400500:	4c 89 ea             	mov    %r13,%rdx
  400503:	4c 89 f6             	mov    %r14,%rsi
  400506:	44 89 ff             	mov    %r15d,%edi
  400509:	41 ff 14 dc          	callq  *(%r12,%rbx,8)
  40050d:	48 83 c3 01          	add    $0x1,%rbx
  400511:	48 39 dd             	cmp    %rbx,%rbp
  400514:	75 ea                	jne    400500 <__libc_csu_init+0x40>
  400516:	48 83 c4 08          	add    $0x8,%rsp
  40051a:	5b                   	pop    %rbx
  40051b:	5d                   	pop    %rbp
  40051c:	41 5c                	pop    %r12
  40051e:	41 5d                	pop    %r13
  400520:	41 5e                	pop    %r14
  400522:	41 5f                	pop    %r15
  400524:	c3                   	retq
  400525:	90                   	nop
  400526:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  40052d:	00 00 00

```

```assembly
0000000000400390 <_init>:
  400390:	48 83 ec 08          	sub    $0x8,%rsp
  400394:	48 8b 05 5d 0c 20 00 	mov    0x200c5d(%rip),%rax        # 600ff8 <__gmon_start__>
  40039b:	48 85 c0             	test   %rax,%rax
  40039e:	74 02                	je     4003a2 <_init+0x12>
  4003a0:	ff d0                	callq  *%rax
  4003a2:	48 83 c4 08          	add    $0x8,%rsp
  4003a6:	c3                   	retq
```
`__libc_csu_init`返回`__libc_start_main`前:

![](https://ww2.sinaimg.cn/large/006tNbRwly1fduntp9dfcj30z412caip.jpg)

