# 增加用户信息与组信息教程

## 运行实例

1. 创建用户组，并记录组 ID
2. 创建用户，填写所需组 ID
3. 是否需要为用户增加 ssh-key，是： 增加 ssh-contens
4. 将用户添加到组内，组名与用户名称
5. 添加 sudo 规则组

## 命令列表

- 增加用户
    - ansible-playbook 07-addaccount.yml --tags 'create_user' --extra-vars '@create_user.json'

- 增加组
    - ansible-playbook 07-addaccount.yml --tags 'create_group' --extra-vars '@create_group.json'

- 增加sudo 规则
    - ansible-playbook 07-addaccount.yml --tags 'add_sudoroles' --extra-vars '@add_sudoroles.json'

- 增加用户到组
    - ansible-playbook 07-addaccount.yml --tags 'exist_group' --extra-vars '@exist_group.json'

- 增加用户 ssh-key 属性
    - ansible-playbook 07-addaccount.yml --tags 'add_sshkey' --extra-vars '@add_sshkey.json'
    
 ### 配置文件说明
 
**create_user.json**

**参数说明**

- `user_name`: 用户名称
- `user_passwd`: 用户的密码
- `user_id`: 用户的 id 1000+
- `group_id`: 组 id

 ```json
{
    "user_name": ["lyl_test"],
    "user_passwd": "1qazxsw2",
    "user_id": "150",
    "group_id": "501",
    "comment": "userid 在创建的时候需要配置不同的开头 ID, gid 需要配置不同的组 id 从创建组时指定 jqbkj_manager=150, jqbkj_dev_team-leader=151,jqbkj_operations=152, jqbkj_dev=153, jqbkj_test=154"
}
```
**create_group.json**

**参数**

- `level`: 创建 OU 的层级
- `ou_name`: 要创建 ou 的名称
- `create_type`: 创建的cn 名称
- `group_name`: 创建的组名称相当于 CN 的名称
- `group_id`: 组 ID

```json
{
    "ou_name": "jenkins",
    "create_type": "cn",
    "group_name": "Linux_users",
    "level": "1",
    "group_id": 504
}
```

**add_sudoroles**

**参数说明**

- `group_name`: 组名

```json
{
    "group_name": "test"
}
```

**exist_group.json**

**参数说明**

- `ou_name`: ou 的名称
- `group_name`: 组名
- `user_name`: 用户名称，可以为list
- `level`: 表示 ou 的层级

```json
{
    "ou_name": "jenkins",
    "group_name": "jenkins-users",
    "user_name": ["liuhaoda"],
    "level": "2"
}
```

**add_sshkey.json**

**参数说明**

- `user_name`: 用户名
- `key_conents`: 公钥信息
- `add_sshkey`: 是否追加

```json
{
    "user_name": "test2",
    "key_conents": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDLtUWPMLPIgMTsgLL9ee1TXkqNjeK0yWwQpnj7b7Z1jcpck+DNzeR/qPM9r/t66UuBa8zxudxVPgZV6YfvsOGHM0NpAbVGBGMOj7MSzqeUyvd8vbkS/lZ+uxYmPz22gcVnT406PPqPimixu2I6YoFN/B4Qkt0gszThv7rYKgZGiQG8RenafQUOEf7CB+Oak4rMSQFjYJPeDghTmQXYlQlMhY5GT8bTot1NglHftOloN2dyYjcbZUVtH7KxI3LDXjGFtC77msmjBpJgAagVBhUzY9/VT2pL/VYXREDVzGejZ2TLJTcCidaP7lMin+99sBSpwH/5aL5FynsRUDfhAD1D yuloong@YuLoongdeMacBook-Pro.local",
    "add_sshkey": true
}
```