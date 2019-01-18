# Account 操作

## 功能
- 添加组
- 添加用户
- 添加默认 `sudo` 组策略

- **ansible-playbook 07-addaccount.yml  --extra-vars "@account_json.json"**

    ```yaml
    - hosts: server
      roles:
        - ldap_account
    ```
    
    运行时参数说明:
     - `user_name`： 要创建的用户名
     - `user_id`: 要创建的用户 id （1000+）
     - `group_id`: 要创建的组 id（500+）
     - `mail`: 用户邮箱地址
     - `group_name`: 用户组名称
     - `create_group`: 是否创建 `true|false` （如果组存在不进行创建）
     - `create_user`: 是否要创建用户 `true|false`
     - `sudo_roles`: 是否开启默认sudo 组策略 | `true|false` （只需要在第一次配置组的 sudo 权限是开启）
     - `user_passwd`: 用户密码
     - `add_group`: 是否添加组
     
 - 添加实例
 
 ```json
{
  "user_name": "user6",
  "user_passwd": "1qazxsw2",
  "group_name": "dev_ops",
  "user_id": "1006",
  "group_id": "505",
  "mail": "liuyulong@jiumiaodai.com",
  "sudo_roles": false,
  "create_group": false,
  "create_user": true,
  "add_group": true
}
```