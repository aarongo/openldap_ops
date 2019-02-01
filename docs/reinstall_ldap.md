# LDAP卸载

运行实例：

ansible-playbook 08-uninstall.yml --extra-vars "@uninstall.json"

```json
{
  "type_server": "server"
}
```

- `type_server`: 要卸载的服务,对应 ansible hosts文件组名称