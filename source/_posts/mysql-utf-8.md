---
title: Mac 安装 MySQL 并设置 utf-8
date: 2016-04-07 22:23:29
category: Mac
tags: [mysql, utf-8]
---

# 下载安装
http://dev.mysql.com/downloads/mysql/5.6.html

# 关闭服务
`系统偏好设置 - MySQL - Stop MySQL Server`

# 环境变量
```shell
$ vim ~/.zshrc

...
# Add mysql
export PATH="$PATH":/usr/local/mysql/bin
...

$ source ~/.zshrc
```

# 设置 utf-8
```shell
$ sudo cp /usr/local/mysql/support-files/my-default.cnf /etc/my.cnf
$ sudo vim /etc/my.cnf

...
[client]
default-character-set = utf8

[mysqld]
default-storage-engine = INNODB
character-set-server = utf8
collation-server = utf8_general_ci
...
```

# 开启服务
`系统偏好设置 - MySQL - Start MySQL Server`

# 验证 utf-8
```
$ mysql -u root -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 5
Server version: 5.6.29 MySQL Community Server (GPL)

Copyright (c) 2000, 2016, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show variables like '%char%';
+--------------------------+--------------------------------------------------------+
| Variable_name            | Value                                                  |
+--------------------------+--------------------------------------------------------+
| character_set_client     | utf8                                                   |
| character_set_connection | utf8                                                   |
| character_set_database   | utf8                                                   |
| character_set_filesystem | binary                                                 |
| character_set_results    | utf8                                                   |
| character_set_server     | utf8                                                   |
| character_set_system     | utf8                                                   |
| character_sets_dir       | /usr/local/mysql-5.6.29-osx10.8-x86_64/share/charsets/ |
+--------------------------+--------------------------------------------------------+
8 rows in set (0.00 sec)

mysql>
```

# mysql.connector
```
(venv3.5)$ pip3 install mysql-connector-python-rf
```

# 参考

- http://www.liaoxuefeng.com/wiki/0014316089557264a6b348958f449949df42a6d3a2e542c000/0014320107391860b39da6901ed41a296e574ed37104752000
- http://blog.csdn.net/waleking/article/details/7620983
- http://jingyan.baidu.com/article/48a42057e2b2b9a9242504a2.html