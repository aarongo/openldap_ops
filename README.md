# LDAP Installation

## 说明放到最前

```txt
minPoints 2
useCracklib 0
minUpper 2
minLower 4
minDigit 1
minPunct 1
```

| 属性项 | 属性说明 | 备注 |
| :---: | :---: | :---: |
| minPoints | 密码的质量点 | 配置值为 `整数`，包含几种字符 |
| minUpper | 密码的大写字符 | 配置为 `整数`， 包含几个大写字符 |
| minLower | 密码的小写字符 | 配置为 `整数`， 包含几个小写字符 |
| minDigit | 密码的数字 | 配置为 `整数`， 包含几个数字 |
| minPunct | 密码的标点符号 | 配置为 `整数`，包含几个标点符号 |

## 功能列表

| 功能 | 功能说明 | 备注 |
| :---: | :---: | :---: |
| 更改密码 | 用户可以自行更改密码 | 需要遵循密码规则(2个小写字符，包含数字，包含特殊字符，长度不得小于9位) |
| ssh-key登录| 通过 ssh-key 登录 | 用户提供公钥进行公钥配置，连接时使用私钥进行连接无需密码(linux) |
| web-brower | web浏览器访问 | 用户可通过浏览器进行查看与配置 |
| sudo | 限制用户执行的命令 | 通过 sudo 规则进行用户行为限制 | 
| 时钟同步 | 主服务同步Internet，其他服务器同步主服务器 | 保持与 server端时间相同 |
| 可选添加模块 | 自行选择安装所需模块 | 根据实际情况进行模块的选择 |
| 自动添加 client | 可自动对客户端进行安装配置 | 配置 housts 进行 client 增加 |
| 添加用户与组 | 可自行添加所需用户与组 | 根据需求添加必要的组与用户 |

**使用 `Ansible` 进行安装配置**

## 配置过程

## 基础命令使用

**查询所有 dn 信息**

```angular2
ldapsearch -x -D cn=config -b "cn=config" -w K7KdHqkEed -LLL dn
```

## 功能列表

**一键安装配置**
```yaml
- hosts: all
  roles:
    - { role: prepare}
    - { role: chrony, CHRONY_NTP: true}

# 服务端基础配置，开启 TSL/SSL、导入基本配置信息
- hosts: server
  roles:
    - { role: ldap_server, install_server: true, ENABLE_SSL: true}
    - { role: ldap_expan, add_memberof: true, add_web: true, sudo_ssh: true, ppolicy: true}

# 客户端配置，开启 TSL/SSL、配置使用 sudo 与 ssh-key
- hosts: clients
  roles:
    - { role: ldap_client, install_client: true}
    - { role: support_ssh_sudo, support: true}
```

## 运行过程

0. ansible-playbook 00-setup.yml
1. ansible-playbook 01-prepare.yml
2. ansible-playbook 02-chrony.yml
3. ansible-playbook 03-server.yml
4. ansible-playbook 04-add_plugin.yml
5. ansible-playbook 05-client.yml
6. ansible-playbook 06-addclient.yml
7. ansible-playbook 07-addaccount.yml 

**7**:运行时参数说明:
- `user_name`： 要创建的用户名
- `user_id`: 要创建的用户 id （1000+）
- `group_id`: 要创建的组 id（500+）
- `mail`: 用户邮箱地址
- `group_name`: 用户组名称
- `create_group`: 是否创建 true|false
- `create_user`: 是否要创建用户 true|false
- `sudo_roles`: 是否开启默认sudo 组策略 | true|false
- `user_passwd`: 用户密码
- `add_group`: 是否添加组

## 安装效果

![](https://d-img.oss-cn-shenzhen.aliyuncs.com/markdown/7qg1p.jpg)

## 测试
1. 创建用户、组

	```bash
	ansible-playbook 07-addaccount.yml --extra-vars "@account_json.json"
	cat account_json.json
	{
	  "user_name": "user5",
	  "user_passwd": "1qazxsw2",
	  "group_name": "dev_ops",
	  "user_id": "1005",
	  "group_id": "505",
	  "mail": "liuyulong@jiumiaodai.com",
	  "sudo_roles": true,
	  "create_group": true,
	  "create_user": true,
	  "add_group": true
	}
	```

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
