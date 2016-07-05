---
title: brackets-live-preview-gulp
date: 2016-07-05 18:23:57
category: AngularJS
tags: [Coursera, JavaScript, AngularJS, Brackets, gulp, browser-sync]
---

今天学习 Coursera 的 AngularJS 课程时尝试使用`ng-include`添加模板   
发觉 Brackets 的 Live Preview 在 Chrome 里总是无法正常显示   
 
[这篇博文](http://blog.csdn.net/aitangyong/article/details/43490117)提到：

>chrome提示很明显：不能跨域访问。通过上面的错误提示，可以看到:使用ng-include指令的时候，会用到AJAX请求XMLHttpRequest。但是我们是直接用浏览器打开的parent.html，并没有通过web容器访问，所以存在跨域访问问题，加载child.html也就失败了。解决办法很简单：将代码部署到tomcat等web容器下，通过http访问即可。

[Coursera Discussions](https://www.coursera.org/learn/angular-js/discussions/weeks/3/threads/rWCY3qGmEeWF6gpqp4BTmQ) 里也有人提到了这个问题，可以有 3 种解决方式

# gulp

之前的课程刚好提到 gulp 可以使用 brower-sync 建立一个 Web 容器来访问项目   
把`Gulpfile.js`略作修改之后`gulp watch`却仍然无法访问   

在 stackoverflow ([1](http://stackoverflow.com/questions/32171725/chrome-cant-open-localhost3000-with-gulp-browsersync?rq=1), [2](http://stackoverflow.com/questions/30233218/browser-sync-is-blocked-by-chrome-csp)) 找到答案，又是 Chrome 的锅，触发了其`Content-Security-Policy`   

修改端口号即可解决

# Brackets Live Preview

尝试之后发现，我在预览单个 html 时，使用的是`file`协议，在 Chrome 里无法跨域访问   
而使用 Brackets 打开整个项目时，Live Preview 将项目放入了自建的 Web 容器里，使用的是`http`协议，即可在 Chrome 中正常跨域访问

#  http-server or json-server

使用 node 安装其它小型 Web 容器后放入运行也可解决

大致如此.

