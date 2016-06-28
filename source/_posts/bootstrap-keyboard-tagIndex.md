---
title: bootstrap-keyboard-tagIndex
date: 2016-06-28 16:16:57
category: JavaScript
tags:	[bootstrap, keyboard, tagIndex]
---

这两天在 Coursera 上学习 Bootstrap   
第四周的作业是把非 JavaScript 实现的 Modal 改成用 JavaScript 实现（https://www.coursera.org/learn/web-frameworks/peer/jAXUU/assignment-4-detailed-instructions-and-submission）   

按照 http://getbootstrap.com/javascript/#modals-methods 找到了解决方案：

```js
    <script>
        $('#reserveButton').on('click', function () {
            $('#reserveModal').modal('toggle');
        });
    </script>
```

作业是解决了，但是发现一个小问题：不管我怎么改`keyboard`属性，都不能用`esc`关闭`modal`

搜了一下得知：在`modal`所在`div`中加入`tabindex="-1"`属性即可   
那么问题又来了...这个`tabindex="-1"`是什么鬼...   

搜索加测试了一下之后终于搞清楚了   
`tabindex`用来帮助键盘党使用`tab`键定位网页元素，按其值由小到大跳转，默认是 0    
如果值相等，则按先后顺序跳转
  
在未加入`tabindex="-1"`时，`modal`和主页中所有元素值都是 0   
当前键盘的焦点仍然在主页而非`modal`上，相当于在主页按`esc`，`modal`监听不到所以无任何反应   
加入`tabindex="-1"`后，`modal`的优先级最高，键盘焦点到了`modal`上，这时再按`esc`就能正确触发关闭`modal`事件了

# 参考

- http://blog.163.com/huan12_8/blog/static/1305190902011274739628/
- https://segmentfault.com/q/1010000004954562
- http://www.w3school.com.cn/tags/att_standard_tabindex.asp
- http://www.mamicode.com/info-detail-494399.html