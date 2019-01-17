# LDAP Installation

**使用 `Ansible` 进行安装配置**

## 配置过程

**当单独运行某个角色的时候需要运行基础配置**
#密码必须由管理员重置
pwdReset: TRUE

## 基础命令使用

**查询所有 dn 信息**

```angular2
ldapsearch -x -D cn=config -b "cn=config" -w K7KdHqkEed -LLL dn
```

## 功能列表

```yaml
- hosts: all
  roles:
    - { role: prepare}
    - { role: chrony, CHRONY_NTP: true}

- hosts: server
  roles:
    - { role: ldap_server, INSTALL: true}
  tags:
    - server

- hosts: server
  roles:
    - { role: ldap_expan}
  tags:
    - add_memberof
```

## 运行过程

**问题：** 执行过一次之后再运行出现存在不能继续，需要优化

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
- `group_exist`: 组是否存在 true|false
- `create_user`: 是否要创建用户 true|false
- `user_passwd`: 用户密码