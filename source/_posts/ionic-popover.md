---
title: ionic 使用 popover 时的一点小问题
date: 2016-09-27 16:52:04
category: [ionic]
tags: [JavaScript, ionic, AngularJS, ngResource]
---

使用 ionic 附带的 ngResource 时需要在 index.html 中加上

```
    <script src="lib/ionic/js/angular/angular-resource.js"></script>
```

否则会报错

另外，[官方文档](http://ionicframework.com/docs/api/service/$ionicPopover/)中关于使用`popover`独立 html 模板的格式有点小问题：

```
<script id="my-popover.html" type="text/ng-template">
  <ion-popover-view>
    <ion-header-bar>
      <h1 class="title">My Popover Title</h1>
    </ion-header-bar>
    <ion-content>
      Hello!
    </ion-content>
  </ion-popover-view>
</script>
```

需改为

```
<ion-popover-view>
  <ion-header-bar>
    <h1 class="title">My Popover Title</h1>
  </ion-header-bar>
  <ion-content>
    Hello!qwew
  </ion-content>
</ion-popover-view>
```

否则会无法找到对应 template 而产生`Error: popoverEle[0] is undefined`