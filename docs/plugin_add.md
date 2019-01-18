# Plugin 安装

## 功能
- 增加基础 memberof 属性
- 开启 `ldap-server`端 web 访问
- 开启`server`端 `sudo`配置
- 开启`server`端`ssh-key`配置
- 开启`server`端`ppolicy`密码策略配置

**ansible-playbook 04-add_plugin.yml**

- 配置开启与关闭安装额外功能

    **`add_memberof: true` `add_web: true` `sudo_ssh: true` `ppolicy: true`** 
    
```yaml
 - hosts: server
   roles:
     - { role: ldap_expan, add_memberof: true, add_web: true, sudo_ssh: true, ppolicy: true}
 ```