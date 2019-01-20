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

 ```json
{
    "user_name": "liuyulong",
    "display_name": "jenkins_user1",
    "user_passwd": "1qazxsw2",
    "user_id": "1010",
    "group_id": "510",
    "mail": "jenkins_user1@qq.com"
}
```
**create_group.json**

```json
{
    "group_name": "jenkins_groups",
    "group_id": "510"
}
```

**add_sudoroles**

```json
{
    "group_name": "liuyulong"
}
```

**exist_group.json**

```json
{
    "group_name": "jenkins_groups",
    "user_name": ["liuyulong","user1"]
}
```

**add_sshkey.json**

```json
{
    "user_name": "liuyulong",
    "key_conents": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDLtUWPMLPIgMTsgLL9ee1TXkqNjeK0yWwQpnj7b7Z1jcpck+DNzeR/qPM9r/t66UuBa8zxudxVPgZV6YfvsOGHM0NpAbVGBGMOj7MSzqeUyvd8vbkS/lZ+uxYmPz22gcVnT406PPqPimixu2I6YoFN/B4Qkt0gszThv7rYKgZGiQG8RenafQUOEf7CB+Oak4rMSQFjYJPeDghTmQXYlQlMhY5GT8bTot1NglHftOloN2dyYjcbZUVtH7KxI3LDXjGFtC77msmjBpJgAagVBhUzY9/VT2pL/VYXREDVzGejZ2TLJTcCidaP7lMin+99sBSpwH/5aL5FynsRUDfhAD1D yuloong@YuLoongdeMacBook-Pro.local",
}
```