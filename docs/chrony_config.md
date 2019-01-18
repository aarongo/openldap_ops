# chrony 安装配置

> 时钟服务器配置

**CHRONY_NTP:true** 是否进行时钟同步配置

**ansible-playbook 02-chrony.yml**

- 安装 `chrony`同步工具
- 配置主服务器同步 `internet`，其他服务器同步主服务器

```yaml
- hosts: all
  roles:
    - { role: chrony, CHRONY_NTP: true  }
```
