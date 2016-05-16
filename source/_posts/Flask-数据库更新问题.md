---
title: Flask 数据库更新问题
date: 2016-05-16 21:52:45
category: Flask
tags: [Python, Flask-SQLAlchemy, Alembic, Flask-Migrate]
---



# 遇到的问题

学习到 8.4.6 测试登录时

```
(venv) $ python manage.py shell 
>>> u = User(email='john@example.com', username='john', password='cat') 
>>> db.session.add(u) 
>>> db.session.commit()
```
报错说表中无 email 列

确认代码无误后，判断应该是没有成功更新 models.py 中新建的 email 列，简单尝试无果，决定重新看一遍相关内容加深理解，再着手解决

# 粗暴的更新方法

如果数据库表已经存在于数据库中， 那么 db.create_all() 不会重新创建或者更新这个表。如果修改模型后要把改动应用到现有的数据库中，这一特 性会带来不便。更新现有数据库表的粗暴方式是先删除旧表再重新创建：

```
>>> db.drop_all() 
>>> db.create_all()
```

# 使用 Flask-Migrate 实现数据库迁移

> 更新表的更好方法是使用数据库迁移框架。源码版本控制工具可以跟踪源码文件的变化， 类似地，数据库迁移框架能跟踪数据库模式的变化，然后增量式的把变化应用到数据库中。

> SQLAlchemy 的主力开发人员编写了一个迁移框架，称为 Alembic（https://alembic.readthedocs. org/en/latest/index.html） 。 除 了 直 接 使 用 Alembic 之 外， Flask 程 序 还 可 使 用 Flask-Migrate （http://flask-migrate.readthedocs.org/en/latest/）扩展。这个扩展对 Alembic 做了轻量级包装，并 集成到 Flask-Script 中，所有操作都通过 Flask-Script 命令完成。

安装与配置略过不提   
几次尝试后，方才对几个主要命令的实际作用有了正确的理解

## init

创建迁移仓库和脚本，并不会生成或更新数据库文件，`migrations/versions/`中为空，如果此时`upgrade`会生成一个只包含`alembic_version`表的数据库

```
$ sqlite3 data-dev.sqlite
SQLite version 3.8.10.2 2015-05-20 18:17:19
Enter ".help" for usage hints.
sqlite> .dump
PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE alembic_version (
	version_num VARCHAR(32) NOT NULL
);
COMMIT;
sqlite>
```

## migrate

检测对数据库的操作，生成迁移脚本保存到`migrations/versions/`中，用于数据库迁移

不过按[官方文档](http://flask-migrate.readthedocs.io/en/latest/)所说，不一定能检测到所有对数据库的修改，所有需要自己对生成的迁移脚本进行检查，加上可能有遗漏的地方

## upgrade

用于把上述迁移运用到数据库中，即至此才会真正对数据库进行更新

```
$ sqlite3 data-dev.sqlite
SQLite version 3.8.10.2 2015-05-20 18:17:19
Enter ".help" for usage hints.
sqlite> .dump
PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE alembic_version (
	version_num VARCHAR(32) NOT NULL
);
INSERT INTO "alembic_version" VALUES('bb488872a057');
CREATE TABLE roles (
	id INTEGER NOT NULL,
	name VARCHAR(64),
	PRIMARY KEY (id),
	UNIQUE (name)
);
CREATE TABLE users (
	id INTEGER NOT NULL,
	email VARCHAR(64),
	username VARCHAR(64),
	role_id INTEGER,
	password_hash VARCHAR(128),
	PRIMARY KEY (id),
	FOREIGN KEY(role_id) REFERENCES roles (id)
);
CREATE UNIQUE INDEX ix_users_email ON users (email);
CREATE UNIQUE INDEX ix_users_username ON users (username);
COMMIT;
sqlite>
```

# OVER

这时回到 8.4.6 测试登录，就一切正常了
