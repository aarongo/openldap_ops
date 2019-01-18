# Client 安装配置

## 功能
- 使用自动命令`autoconfig`进行配置`client`端

**ansible-playbook 05-client.yml**

**`install_client: true`** 配置是否进行客户端安装

```yaml
- hosts: clients
  roles:
    - { role: ldap_client, install_client: true}
```