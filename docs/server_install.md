# LDAP-Server 安装配置

## 功能列表
-  安装基本软件
-  配置是否开启 TLS/SSL（`ENABLE_SSL: true`)
-  开启服务日志
-  生成自签名证书
-  创建基础`cn`信息
-  配置`server`生效

**ansible-playbook 03-server.yml**

**install_server: true** 是否安装`server`端

```yaml
- hosts: server
  roles:
    - { role: prepare}
    - { role: chrony, CHRONY_NTP: true}
    - { role: ldap_server, install_server: true, ENABLE_SSL: true}
```
