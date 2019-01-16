# LDAP Installation

**使用 `Ansible` 进行安装配置**

## 配置过程



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