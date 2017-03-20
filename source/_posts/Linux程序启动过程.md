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

# Linux x86 elf 程序启动过程

Kali rolling x86-64 环境，默认动态链接    
参考 32 位： http://dbp-consulting.com/tutorials/debugging/linuxProgramStartup.html 

流程图如下：

![流程图](http://dbp-consulting.com/tutorials/debugging/images/callgraph.png)

## 最简单的 main

```prog1.c
int main()
{
}
```

`gcc -ggdb -o prog1 prog1.c`

## execve

运行程序时，shell 或者 gui 调用 execve() 函数触发系统调用：

- 系统会分配栈区并将 argc, argv, envp 压栈
- 按照 shell 设定 FD
- 装载器负责重定位和调用`preinitializers`（图中`preinitarray1..n`）
- 从程序代码段中 _start 位置开始执行程序

## _start

`_start` 是程序执行的初始位置，通过`objdump -d prog1`查看汇编

```
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
`main`的完整参数调用应该是`int main(int argc, char** argv, char** envp)`, 但是`__libc_start_main`中却并不包含 envp

使用 gdb 调试 prog1, 在`_start`处下断点, 运行初始状态如下:
![_start](_start.png)
可以看到从栈顶向栈底依次放置的是: argc, argv, 0x0, 环境变量. 可见 envp 其实可以由 argc 和 argv 计算得到

{% asset_path Linux程序启动过程 %}
{% asset_img _start.png qwe %}
{% asset_link slug [title] %}






```csu/elf-init.c
void __libc_csu_init (int argc, char **argv, char **envp)
{

  _init ();

  const size_t size = __init_array_end - __init_array_start;
  for (size_t i = 0; i < size; i++)
      (*__init_array_start [i]) (argc, argv, envp);
}
```