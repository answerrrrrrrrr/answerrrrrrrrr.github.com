---
title: Q 判断 Gadget 时遇到 align 伪指令的问题
date: 2016-08-23 13:13:57
category: rop
tags:	[Q, asm, align, capstone, ida]
---

今天在利用 Q 判断 Gadget 时发现，在 IDA 中静态分析时显示如下的指令片段：

```
align 10h
ret
```

会被判断为 Gadget，并且还莫名其妙扯上了 esi

```
8d7600c3
MoveReg(Address: 0x40000, Complexity 0.67, Stack 0x4, Ip 0x0, Output: esi, Inputs [esi])
AndGadget(Address: 0x40000, Complexity 0.67, Stack 0x4, Ip 0x0, Output: esi, Inputs [esi, esi])
OrGadget(Address: 0x40000, Complexity 0.67, Stack 0x4, Ip 0x0, Output: esi, Inputs [esi, esi])
```

实在百思不得其解   

按理说`伪指令`并没有实际的机器码与之对应，但是`ret`对应`c3`，那么只能解释为`align 10h`对应`8d7600`了

好在 Google 到了[一篇文章](http://www.codingnow.com/2000/frame.htm?http://www.codingnow.com/2000/essay/align.htm)，提到了汇编器处理`align`伪指令的原理

>我原来以为, VC 将插入 NOP 来对齐代码, 结果发现, 为了提高效率, VC 按情况填入了单字节,双字节, 三字节指令做空操作, 使空操作的时间最短. 当需要插入 1 字节时, 理所当然的插入一个 0x90 (NOP); 需要插入 2 字节时则是 0x8b 0xff (MOV DI,DI) 这也无可厚非, 此指令不破坏任何寄存器, 也不影响标志位; 可需要填入 3 个字节的时候, 我用的 VC6 却令人费解的填入了 0x8d 0x49 0x00 (LEA CX,[BX+DI+00]), 很明显它影响了 CX, 而风魂的代码就是受到了它的影响.

我这才恍然大悟，拿 capstone 反汇编了一下`8d7600`得到

```
lea	esi, dword ptr [esi]
```

果然，汇编器在处理`align`时，插入了这样一个`不破坏任何寄存器也不影响标志位`的指令来实现对齐效果

而 Q（使用 capstone 反汇编）接收到传入的指令时，自然会按照实际的机器指令而不是`align 10h`来进行 Gadget 判断，所以出现了上面的结果

大致如此...