---
title: Flask-SQLAlchemy 中的 relationship & backref
date: 2016-08-16 14:29:07
category: Flask
tags: [Flask, Flask-SQLAlchemy, relationship, backref]
---

今天重看 Flask 时，发现对`backref`仍然没有理解透彻。查阅[文档](http://flask-sqlalchemy.pocoo.org/2.1/models/)后发现，以前试图孤立地理解`backref`是问题之源，`backref`是与`relationship`配合使用的。

# 一对多关系

`db.relationship()`用于在两个表之间建立`一对多关系`。例如书中 roles 表中一个 User 角色，可以对应 users 表中多个实际的普通用户。实现这种关系时，要在“多”这一侧加入一个外键，指向“一”这一侧联接的记录。

```py
class Role(db.Model):
	# ...
	users = db.relationship('User', backref='role')

class User(db.Model):
	# ...
	role_id = db.Column(db.Integer, db.ForeignKey('roles.id'))
```

## relationship & ForeighKey

大多数情况下, db.relationship() 都能自行找到关系中的外键, 但有时却无法决定把 哪一列作为外键。 例如, 如果 User 模型中有两个或以上的列定义为 Role 模型的外键, SQLAlchemy 就不知道该使用哪列。如果无法决定外键,你就要为 db.relationship() 提供额外参数,从而确定所用外键。（见书 P49）

## relationship & backref
通过`db.relationship()`，Role 模型有了一个可以获得对应角色所有用户的属性`users`。默认是列表形式，`lazy='dynamic'`时返回的是一个 query 对象。即`relationship`提供了 Role 对 User 的访问。

而`backref`正好相反，提供了 User 对 Role 的访问。

不妨设一个 Role 实例为 `user_role`，一个 User 实例为 `u`。relationship 使 `user_role.users` 可以访问所有符合角色的用户，而 backref 使 `u.role` 可以获得用户对应的角色。

### 示例

```
$ p manage.py shell

>>> user_role = Role.query.filter_by(name='User').all()
>>> user_role
[<Role u'User'>]

>>> user_role = Role.query.filter_by(name='User').first()
>>> user_role
<Role u'User'>

>>> user_role.users
<sqlalchemy.orm.dynamic.AppenderBaseQuery object at 0x1087c1050>

>>> user_role.users.order_by(User.username).all()
[<User u'alice78'>, <User u'andrea86'>, <User u'hmr'>]

>>> Role.query.all()
[<Role u'Moderator'>, <Role u'Administrator'>, <Role u'User'>]

>>> user_role.users.count()
3

>>> u = User.query.filter_by(username='hmr').first()
>>> u
<User u'hmr'>

>>> u.role
<Role u'User'>
>>>
```

# 一对一关系

除了一对多之外, 还有几种其他的关系类型。一对一关系可以用前面介绍的一对多关系表示, 但调用 db.relationship() 时要把 uselist 设为 False , 把“多”变成“一”。 


# 多对多关系

`多对多关系`书 P131 讲得很清楚。需要注意的就是`关联表`是`db.Table`而非`db.Model`。关联表就是一个简单的表，不是模型，SQLAlchemy 会自动接管这个表。






















