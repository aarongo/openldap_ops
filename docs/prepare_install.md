# prepare 准备安装

## 功能列表

- 配置主机 `hosts` 文件，客户端连接 server 端地址
- 增加 `epel`源
- 更新系统软件

> 对所有服务器进行 server 端 IP 解析

**ansible-playbook 01-prepare.yml**

```yaml
# 所有主机进行基础准备配置
- hosts: all
  roles:
    - { role: prepare}
```