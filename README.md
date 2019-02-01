# LDAP Installation

## 软件版本信息

| 软件 | 版本 | 备注 |
| :---: | :---: | :---: |
| os | CentOS Linux release 7.5.1804 (Core) | 
| ldap | OpenLDAP: slapd 2.4.44 (Oct 30 2018 23:14:27)
| python | Python 3.6.5 |
| ansible | ansible 2.7.5 |

## 功能列表

| 功能 | 功能说明 | 备注 |
| :---: | :---: | :---: |
| 更改密码 | 用户可以自行更改密码 | 需要遵循密码规则(2个小写字符，包含数字，包含特殊字符，长度不得小于9位)[规则信息](./docs/password_Introduction.md) |
| ssh-key登录| 通过 ssh-key 登录 | 用户提供公钥进行公钥配置，连接时使用私钥进行连接无需密码(linux) |
| web-brower | web浏览器访问 | 用户可通过浏览器进行查看与配置 |
| sudo | 限制用户执行的命令 | 通过 sudo 规则进行用户行为限制 | 
| 时钟同步 | 主服务同步Internet，其他服务器同步主服务器 | 保持与 server端时间相同 |
| 可选添加模块 | 自行选择安装所需模块 | 根据实际情况进行模块的选择 |
| 自动添加 client | 可自动对客户端进行安装配置 | 配置 housts 进行 client 增加 |
| 添加用户与组 | 可自行添加所需用户与组 | 根据需求添加必要的组与用户 |
| 卸载LDAPserver 与 client | 自行选择卸载的服务器类型 | 因为一些原因 server 只是初始化安装 |

## 安装指南

| [快速安装](./docs/quick_install.md) | [基础配置安装](./docs/prepare_install.md) | [时钟同步](./docs/chrony_config.md) | [服务端安装](./docs/server_install.md)| [命令行使用](./docs/base_command.md)|
| :---: | :---: | :---: | :---: | :---: | 
| [扩展功能安装](./docs/plugin_add.md) | [客户端安装配置](./docs/client_install.md)  | [添加客户端](./docs/client_add.md) | [自定义用户添加](./docs/account_handle.md) | [卸载](./docs/reinstall_ldap.md) |


## 安装效果

![](https://d-img.oss-cn-shenzhen.aliyuncs.com/markdown/7qg1p.jpg)

## 测试
1. 创建用户、组
    
    [点我看具体详情](./ldap_account/README.md)

	**web**查看效果

	![](https://d-img.oss-cn-shenzhen.aliyuncs.com/markdown/ht14b.jpg)

2. 测试密码登录

	```bash
	ssh user5@172.16.10.10
	user5@172.16.10.10's password:
	You are required to change your password immediately (root enforced)
	need a new password
	Creating directory '/home/user5'.
	WARNING: Your password has expired.
	You must change your password now and login again!
	Changing password for user user5.
	(current) LDAP Password:
	```

	**密码策略生效，首次登录需要更改密码**

	```bash
	# 配置密码为123456，密码复杂度检测为生效
	check_password_quality: module error: (check_password.so) Password for dn="uid=user5,ou=Users,dc=laoshiren,dc=com" does not pass required number of strength checks for the required character sets (3 of 2).
	# 配置密码为qzaCZa,1 规则要匹配到自定义的复杂度要求
	passwd: all authentication tokens updated successfully.
	# 使用新密码登录成功
	ssh user5@172.16.10.10
	user5@172.16.10.10's password:
	Last login: Thu Jan 17 21:10:31 2019 from 172.16.10.1
	[user5@kubernetes-node1 ~]$
	```

3. 测试 sudo 规则

	```bash
	# 匹配到配置的 sudo 组策略，并且不需要输入密码
	[user5@kubernetes-node1 ~]$ sudo -l
	匹配 %2$s 上 %1$s 的默认条目：
	    !visiblepw, always_set_home, match_group_by_gid, env_reset, env_keep="COLORS DISPLAY HOSTNAME HISTSIZE KDEDIR LS_COLORS", env_keep+="MAIL PS1 PS2 QTDIR USERNAME LANG LC_ADDRESS LC_CTYPE",
	    env_keep+="LC_COLLATE LC_IDENTIFICATION LC_MEASUREMENT LC_MESSAGES", env_keep+="LC_MONETARY LC_NAME LC_NUMERIC LC_PAPER LC_TELEPHONE", env_keep+="LC_TIME LC_ALL LANGUAGE LINGUAS _XKB_CHARSET
	    XAUTHORITY", secure_path=/sbin\:/bin\:/usr/sbin\:/usr/bin, requiretty, !visiblepw, always_set_home, env_reset, env_keep="COLORS DISPLAY HOSTNAME HISTSIZE KDEDIR LS_COLORS", env_keep="MAIL PS1 PS2
	    QTDIR USERNAME LANG LC_ADDRESS LC_CTYPE", env_keep="LC_COLLATE LC_IDENTIFICATION LC_MEASUREMENT LC_MESSAGES", env_keep="LC_MONETARY LC_NAME LC_NUMERIC LC_PAPER LC_TELEPHONE", env_keep="LC_TIME
	    LC_ALL LANGUAGE LINGUAS _XKB_CHARSET XAUTHORITY", secure_path=/sbin:/bin:/usr/sbin:/usr/bin
	用户 user5 可以在 kubernetes-node1 上运行以下命令：
	    (ALL) NOPASSWD: /bin/bash, /bin/chmod, /bin/chown, /bin/mv, /usr/bin/vim, /usr/bin/passwd
	[user5@kubernetes-node1 ~]$
	```

4. 测试使用 ssh-key 方式登录

	**配置增加 objecclass 并增加 ssh-key**

	![](https://d-img.oss-cn-shenzhen.aliyuncs.com/markdown/yd3sa.jpg)

	![](https://d-img.oss-cn-shenzhen.aliyuncs.com/markdown/uxm4c.jpg)

	```bash
	# 使用私钥登录
	ssh -i ~/.ssh/id_rsa user5@172.16.10.10
	Last login: Thu Jan 17 21:11:51 2019 from 172.16.10.1
	[user5@kubernetes-node1 ~]$
	```

5. 验证ppolicy生效

	**查看更改密码历史，记录5次**

	![](https://d-img.oss-cn-shenzhen.aliyuncs.com/markdown/ttryc.jpg)

	**新建用户，测试密码过期提醒**

	```bash
	ssh user6@172.16.10.10
    user6@172.16.10.10's password:
    password will expire in 90 days
    Last login: Thu Jan 17 21:36:28 2019 from 172.16.10.1
	```
