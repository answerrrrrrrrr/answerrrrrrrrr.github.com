---
title: Flask 数据库更新问题
date: 2016-05-16 21:52:45
category: Flask
tags: [Python, Flask-SQLAlchemy, Alembic, Flask-Migrate]
---



# 更新列

## 遇到的问题

学习到 8.4.6 测试登录时

```
(venv) $ python manage.py shell 
>>> u = User(email='john@example.com', username='john', password='cat') 
>>> db.session.add(u) 
>>> db.session.commit()
```
报错说表中无 email 列

确认代码无误后，判断应该是没有成功更新 models.py 中新建的 email 列，简单尝试无果，决定重新看一遍相关内容加深理解，再着手解决

## 粗暴的更新方法

如果数据库表已经存在于数据库中， 那么 db.create_all() 不会重新创建或者更新这个表。如果修改模型后要把改动应用到现有的数据库中，这一特 性会带来不便。更新现有数据库表的粗暴方式是先删除旧表再重新创建：

```
>>> db.drop_all() 
>>> db.create_all()
```

## 使用 Flask-Migrate 实现数据库迁移

> 更新表的更好方法是使用数据库迁移框架。源码版本控制工具可以跟踪源码文件的变化， 类似地，数据库迁移框架能跟踪数据库模式的变化，然后增量式的把变化应用到数据库中。

> SQLAlchemy 的主力开发人员编写了一个迁移框架，称为 Alembic（https://alembic.readthedocs. org/en/latest/index.html） 。 除 了 直 接 使 用 Alembic 之 外， Flask 程 序 还 可 使 用 Flask-Migrate （http://flask-migrate.readthedocs.org/en/latest/）扩展。这个扩展对 Alembic 做了轻量级包装，并 集成到 Flask-Script 中，所有操作都通过 Flask-Script 命令完成。

安装与配置略过不提   
几次尝试后，方才对几个主要命令的实际作用有了正确的理解

### init

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

### migrate

检测对数据库的操作，生成迁移脚本保存到`migrations/versions/`中，用于数据库迁移

不过按[官方文档](http://flask-migrate.readthedocs.io/en/latest/)所说，不一定能检测到所有对数据库的修改，所有需要自己对生成的迁移脚本进行检查，加上可能有遗漏的地方

### upgrade

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



# 管理员角色

## 遇到的问题

学习到 10.3.2后，发现以管理员邮箱注册的帐号并不能打开`管理员级别的资料编辑器`   
手动查看数据库：
```
INSERT INTO "users" VALUES(1,'huamingrui@163.com','huamingrui',NULL,'pbkdf2:sha1:1000$wpqGMEz8$a3bf86fcb0be120a7510a8f702077eb2fdfa1980',1,NULL,NULL,NULL,'2016-05-17 14:17:48.930851','2016-05-17 14:19:00.735339');
```
发现`role_id`项为空，即角色没有被成功赋予

## Role.insert_roles()

回去翻书，找到 9.3 最后的部分说到
> 在你阅读下一章之前，最好重新创建或者更新开发数据库，如此一来，那些在实现角色和 权限之前创建的用户账户就被赋予了角色。

然而实测发现，对于管理员用户，必须在注册之前就完成 9.1 最后的`Role.insert_roles()`步骤，才能成功为管理员邮箱用户赋予`管理员角色`

```
$ rm data-dev.sqlite
$ python manage.py db upgrade
INFO  [alembic.runtime.migration] Context impl SQLiteImpl.
INFO  [alembic.runtime.migration] Will assume non-transactional DDL.
INFO  [alembic.runtime.migration] Running upgrade  -> 02ccb3e6a553, empty message
$ sqlite3 data-dev.sqlite
SQLite version 3.8.10.2 2015-05-20 18:17:19
Enter ".help" for usage hints.
sqlite> .dump
PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE alembic_version (
	version_num VARCHAR(32) NOT NULL
);
INSERT INTO "alembic_version" VALUES('02ccb3e6a553');
CREATE TABLE roles (
	id INTEGER NOT NULL,
	name VARCHAR(64),
	"default" BOOLEAN,
	permissions INTEGER,
	PRIMARY KEY (id),
	UNIQUE (name),
	CHECK ("default" IN (0, 1))
);
CREATE TABLE users (
	id INTEGER NOT NULL,
	email VARCHAR(64),
	username VARCHAR(64),
	role_id INTEGER,
	password_hash VARCHAR(128),
	confirmed BOOLEAN,
	name VARCHAR(64),
	location VARCHAR(64),
	about_me TEXT,
	member_since DATETIME,
	last_seen DATETIME,
	PRIMARY KEY (id),
	FOREIGN KEY(role_id) REFERENCES roles (id),
	CHECK (confirmed IN (0, 1))
);
CREATE INDEX ix_roles_default ON roles ("default");
CREATE UNIQUE INDEX ix_users_email ON users (email);
CREATE UNIQUE INDEX ix_users_username ON users (username);
COMMIT;
sqlite> ^D
$ python manage.py shell
>>> Role.insert_roles()
>>> Role.query.all()
[<Role u'Moderator'>, <Role u'Administrator'>, <Role u'User'>]
>>> ^D
$ sqlite3 data-dev.sqlite
SQLite version 3.8.10.2 2015-05-20 18:17:19
Enter ".help" for usage hints.
sqlite> .dump
PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE alembic_version (
	version_num VARCHAR(32) NOT NULL
);
INSERT INTO "alembic_version" VALUES('02ccb3e6a553');
CREATE TABLE roles (
	id INTEGER NOT NULL,
	name VARCHAR(64),
	"default" BOOLEAN,
	permissions INTEGER,
	PRIMARY KEY (id),
	UNIQUE (name),
	CHECK ("default" IN (0, 1))
);
INSERT INTO "roles" VALUES(1,'Moderator',0,15);
INSERT INTO "roles" VALUES(2,'Administrator',0,255);
INSERT INTO "roles" VALUES(3,'User',1,7);
CREATE TABLE users (
	id INTEGER NOT NULL,
	email VARCHAR(64),
	username VARCHAR(64),
	role_id INTEGER,
	password_hash VARCHAR(128),
	confirmed BOOLEAN,
	name VARCHAR(64),
	location VARCHAR(64),
	about_me TEXT,
	member_since DATETIME,
	last_seen DATETIME,
	PRIMARY KEY (id),
	FOREIGN KEY(role_id) REFERENCES roles (id),
	CHECK (confirmed IN (0, 1))
);
CREATE INDEX ix_roles_default ON roles ("default");
CREATE UNIQUE INDEX ix_users_email ON users (email);
CREATE UNIQUE INDEX ix_users_username ON users (username);
COMMIT;
sqlite> ^D
$ python manage.py runserver
```
注册管理员邮箱
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
INSERT INTO "alembic_version" VALUES('02ccb3e6a553');
CREATE TABLE roles (
	id INTEGER NOT NULL,
	name VARCHAR(64),
	"default" BOOLEAN,
	permissions INTEGER,
	PRIMARY KEY (id),
	UNIQUE (name),
	CHECK ("default" IN (0, 1))
);
INSERT INTO "roles" VALUES(1,'Moderator',0,15);
INSERT INTO "roles" VALUES(2,'Administrator',0,255);
INSERT INTO "roles" VALUES(3,'User',1,7);
CREATE TABLE users (
	id INTEGER NOT NULL,
	email VARCHAR(64),
	username VARCHAR(64),
	role_id INTEGER,
	password_hash VARCHAR(128),
	confirmed BOOLEAN,
	name VARCHAR(64),
	location VARCHAR(64),
	about_me TEXT,
	member_since DATETIME,
	last_seen DATETIME,
	PRIMARY KEY (id),
	FOREIGN KEY(role_id) REFERENCES roles (id),
	CHECK (confirmed IN (0, 1))
);
INSERT INTO "users" VALUES(1,'huamingrui@163.com','MrHua',2,'pbkdf2:sha1:1000$tSmBVC7j$6f3d994eb5b6b455347b56d3112a4cac26fc97e1',1,NULL,NULL,NULL,'2016-05-17 14:34:36.781740','2016-05-17 14:52:08.764862');
CREATE INDEX ix_roles_default ON roles ("default");
CREATE UNIQUE INDEX ix_users_email ON users (email);
CREATE UNIQUE INDEX ix_users_username ON users (username);
COMMIT;
sqlite>
```
