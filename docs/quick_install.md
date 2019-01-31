# 快速安装配置
## 安装列表
![](https://d-img.oss-cn-shenzhen.aliyuncs.com/markdown/2019-01-31-021826.png)

**ansible-playbook 00-setup.yml**
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

## 独立安装

**注:** 独立进行安装过程中 都需要首先执行`prepare`进行初始化配置，排除新增客户端时已经集成了`prepare`
